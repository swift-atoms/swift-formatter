#if Number
    public import Cardinal
    public import Rational

    extension Formatter {
        public struct Number: Sendable {
            public enum Scale: Sendable {
                case number
                case percent
            }

            public let fractionDigits: Int?
            public let rounding: FloatingPointRoundingRule
            public let scale: Scale

            /// The fewest integer digits written, made up with leading zeros: a padding of 4 writes 660 as 0660.
            public let padding: Cardinal

            /// How the integer digits are grouped, or nil to write them in one run.
            public let grouping: Grouping?

            public init(
                fractionDigits: Int? = nil,
                rounding: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
                scale: Scale = .number,
                padding: Cardinal = 1,
                grouping: Grouping? = nil
            ) {
                precondition(
                    fractionDigits.map { (0...324).contains($0) } ?? true,
                    "fractionDigits must be between 0 and 324"
                )
                precondition(padding > 0, "padding must be at least 1")
                self.fractionDigits = fractionDigits
                self.rounding = rounding
                self.scale = scale
                self.padding = padding
                self.grouping = grouping
            }
        }
    }

    extension Formatter.Number: Formatter.`Protocol` {
        public typealias Input = Double
        public typealias Output = String
        public typealias Failure = Never

        public func format(_ value: Double) -> String {
            if value.isNaN { return "nan" + suffix }
            let negative = value.sign == .minus
            if value.isInfinite { return (negative ? "-" : "") + "inf" + suffix }

            let parts = String(value.magnitude).split(separator: "e", omittingEmptySubsequences: false)
            let exponent: Int
            if parts.count == 2 {
                guard let parsed = Int(parts[1]) else {
                    preconditionFailure("Exponent of a formatted Double is an integer")
                }
                exponent = parsed
            } else {
                exponent = 0
            }
            let mantissa = parts[0].split(separator: ".", omittingEmptySubsequences: false)
            return assemble(
                digits: parts[0].utf8.filter { $0 != 46 }.map { $0 - 48 },
                point: mantissa[0].count + exponent + decimalShift,
                negative: negative,
                inexact: false
            )
        }
    }

    extension Formatter.Number {
        var suffix: String { scale == .percent ? "%" : "" }

        var decimalShift: Int { scale == .percent ? 2 : 0 }

        /// Writes a decimal magnitude given as `digits` with the decimal point after the first `point`
        /// of them. `inexact` says that the value goes on beyond `digits` with something nonzero; such
        /// a value is rounded at `fractionDigits`, or at 324 fraction digits when there are none.
        func assemble(digits: [UInt8], point: Int, negative: Bool, inexact: Bool) -> String {
            var digits = digits
            var point = point
            if point <= 0 {
                digits.insert(contentsOf: repeatElement(UInt8(0), count: 1 - point), at: 0)
                point = 1
            }
            if point > digits.count {
                digits.append(contentsOf: repeatElement(UInt8(0), count: point - digits.count))
            }

            if let fractionDigits = fractionDigits ?? (inexact ? 324 : nil) {
                let kept = point + fractionDigits
                if inexact && digits.count <= kept {
                    digits.append(contentsOf: repeatElement(UInt8(0), count: kept + 1 - digits.count))
                }
                if digits.count > kept {
                    let discarded = digits[kept...]
                    let nonzero = inexact || discarded.contains { $0 != 0 }
                    let increment: Bool
                    switch rounding {
                    case .towardZero: increment = false
                    case .awayFromZero: increment = nonzero
                    case .up: increment = !negative && nonzero
                    case .down: increment = negative && nonzero
                    case .toNearestOrAwayFromZero: increment = digits[kept] >= 5

                    case .toNearestOrEven:
                        increment =
                            digits[kept] > 5
                            || (digits[kept] == 5
                                && (inexact
                                    || discarded.dropFirst().contains { $0 != 0 }
                                    || digits[kept - 1] % 2 == 1))

                    @unknown default:
                        preconditionFailure("Unsupported rounding rule")
                    }
                    digits.removeSubrange(kept...)
                    if increment {
                        var cursor = digits.count
                        while cursor > 0 && digits[cursor - 1] == 9 {
                            cursor -= 1
                            digits[cursor] = 0
                        }
                        if cursor == 0 {
                            digits.insert(1, at: 0)
                            point += 1
                        } else {
                            digits[cursor - 1] += 1
                        }
                    }
                } else if digits.count < kept {
                    digits.append(contentsOf: repeatElement(UInt8(0), count: kept - digits.count))
                }
            }
            if self.fractionDigits == nil {
                while digits.count > point && digits.last == 0 { digits.removeLast() }
            }

            while point > 1 && digits.first == 0 {
                digits.removeFirst()
                point -= 1
            }
            let width = Int(clamping: padding)
            if point < width {
                digits.insert(contentsOf: repeatElement(UInt8(0), count: width - point), at: 0)
                point = width
            }
            let integer = String(decoding: digits[..<point].map { $0 + 48 }, as: UTF8.self)
            let whole = grouping.map { $0.apply(to: integer) } ?? integer
            let fraction = String(decoding: digits[point...].map { $0 + 48 }, as: UTF8.self)
            return (negative ? "-" : "") + whole + (fraction.isEmpty ? "" : "." + fraction) + suffix
        }
    }

    extension Formatter.Number {
        /// Formats an exact rational from its exact decimal expansion, with no floating point on the way.
        ///
        /// Disfavored so that an integer literal, which both `Double` and `Rational` can express, still
        /// formats as a `Double`; both give the same string for it.
        @_disfavoredOverload
        public func format(_ value: Rational) -> String {
            var magnitude = value.numerator.absolute
            if decimalShift > 0 {
                magnitude *= Integer("1" + String(repeating: "0", count: decimalShift)) ?? .one
            }
            let places: Int
            if let fractionDigits {
                places = fractionDigits + 1
            } else {
                var rest = value.denominator
                var twos = 0
                var fives = 0
                while !rest.isOdd {
                    rest = Self.divide(rest, by: 2).quotient
                    twos += 1
                }
                while true {
                    let division = Self.divide(rest, by: 5)
                    guard division.remainder.isZero else { break }
                    rest = division.quotient
                    fives += 1
                }
                places = rest == .one ? max(twos, fives) : 325
            }
            guard let scale = Integer("1" + String(repeating: "0", count: places)) else {
                preconditionFailure("A power of ten is an integer")
            }
            let division = Self.divide(magnitude * scale, by: value.denominator)
            var digits = division.quotient.description.utf8.map { $0 - 48 }
            if digits.count <= places {
                digits.insert(contentsOf: repeatElement(UInt8(0), count: places + 1 - digits.count), at: 0)
            }
            return assemble(
                digits: digits,
                point: digits.count - places,
                negative: value.numerator.isNegative,
                inexact: !division.remainder.isZero
            )
        }

        private static func divide(_ dividend: Integer, by divisor: Integer) -> (quotient: Integer, remainder: Integer) {
            do {
                return try dividend.quotientAndRemainder(dividingBy: divisor)
            } catch {
                preconditionFailure("The divisor is positive")
            }
        }
    }
#endif
