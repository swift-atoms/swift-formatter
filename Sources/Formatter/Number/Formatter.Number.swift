#if Number
extension Formatter {
    public struct Number: Sendable {
        public enum Scale: Sendable {
            case number
            case percent
        }

        public let fractionDigits: Int?
        public let rounding: FloatingPointRoundingRule
        public let scale: Scale

        public init(
            fractionDigits: Int? = nil,
            rounding: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
            scale: Scale = .number
        ) {
            precondition(
                fractionDigits.map { (0...324).contains($0) } ?? true,
                "fractionDigits must be between 0 and 324"
            )
            self.fractionDigits = fractionDigits
            self.rounding = rounding
            self.scale = scale
        }
    }
}

extension Formatter.Number: Formatter.`Protocol` {
    public typealias Input = Double
    public typealias Output = String
    public typealias Failure = Never

    public func format(_ value: Double) -> String {
        let suffix: String
        let decimalShift: Int
        switch scale {
        case .number: suffix = ""; decimalShift = 0
        case .percent: suffix = "%"; decimalShift = 2
        }
        if value.isNaN { return "nan" + suffix }
        let sign = value.sign == .minus ? "-" : ""
        if value.isInfinite { return sign + "inf" + suffix }

        let parts = String(value.magnitude).split(separator: "e", omittingEmptySubsequences: false)
        let exponent = parts.count == 2 ? Int(parts[1])! : 0
        let mantissa = parts[0].split(separator: ".", omittingEmptySubsequences: false)
        var point = mantissa[0].count + exponent + decimalShift
        var digits = parts[0].utf8.filter { $0 != 46 }.map { $0 - 48 }

        if point <= 0 {
            digits.insert(contentsOf: repeatElement(UInt8(0), count: 1 - point), at: 0)
            point = 1
        }
        if point > digits.count {
            digits.append(contentsOf: repeatElement(UInt8(0), count: point - digits.count))
        }

        if let fractionDigits {
            let kept = point + fractionDigits
            if digits.count > kept {
                let discarded = digits[kept...]
                let nonzero = discarded.contains { $0 != 0 }
                let increment: Bool
                switch rounding {
                case .towardZero: increment = false
                case .awayFromZero: increment = nonzero
                case .up: increment = value.sign == .plus && nonzero
                case .down: increment = value.sign == .minus && nonzero
                case .toNearestOrAwayFromZero: increment = digits[kept] >= 5
                case .toNearestOrEven:
                    increment = digits[kept] > 5
                        || (digits[kept] == 5
                            && (discarded.dropFirst().contains { $0 != 0 }
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
        } else {
            while digits.count > point && digits.last == 0 { digits.removeLast() }
        }

        while point > 1 && digits.first == 0 {
            digits.removeFirst()
            point -= 1
        }
        let whole = String(decoding: digits[..<point].map { $0 + 48 }, as: UTF8.self)
        let fraction = String(decoding: digits[point...].map { $0 + 48 }, as: UTF8.self)
        return sign + whole + (fraction.isEmpty ? "" : "." + fraction) + suffix
    }
}
#endif
