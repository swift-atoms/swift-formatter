#if Number
    import Formatter
    import Rational
    import Testing

    enum `Formatter.Number Tests` {}

    extension `Formatter.Number Tests` {
        @Suite
        struct Grouping {
            typealias Number = Formatter.Number

            static let thousands = Number.Grouping(separator: ",", size: 3)

            @Test
            func `One size groups every three digits and two sizes group as the Indian convention does`() {
                #expect(Number(grouping: Self.thousands).format(1_234_567) == "1,234,567")
                #expect(Number(grouping: .init(separator: ",", primary: 3, secondary: 2)).format(1_234_567) == "12,34,567")
                #expect(Number(grouping: .init(separator: ",", primary: 3, secondary: 2)).format(123_456_789) == "12,34,56,789")
                #expect(Number(grouping: .init(separator: "\u{202F}", size: 3)).format(1_234_567) == "1\u{202F}234\u{202F}567")
                #expect(Number(grouping: .init(separator: "'", size: 4)).format(123_456_789) == "1'2345'6789")
            }

            @Test
            func `A separator comes only between two groups`() {
                let number = Number(grouping: Self.thousands)
                #expect(number.format(0) == "0")
                #expect(number.format(999) == "999")
                #expect(number.format(1_000) == "1,000")
                #expect(number.format(100_000) == "100,000")
                #expect(number.format(1_000_000) == "1,000,000")
                #expect(number.format(-999) == "-999")
                #expect(number.format(-1_000) == "-1,000")
                #expect(number.format(-1_234_567) == "-1,234,567")
                #expect(number.format(-0.0) == "-0")
            }

            @Test
            func `A group size of 1 separates every digit`() {
                #expect(Number(grouping: .init(separator: ",", size: 1)).format(1_234) == "1,2,3,4")
                #expect(Number(grouping: .init(separator: ",", size: 1)).format(7) == "7")
                #expect(Number(grouping: .init(separator: ",", primary: 1, secondary: 3)).format(12_345) == "1,234,5")
            }

            @Test
            func `Fraction digits are never grouped, and rounding into a new group groups it`() {
                #expect(Number(fractionDigits: 2, grouping: Self.thousands).format(1_234_567.891) == "1,234,567.89")
                #expect(Number(grouping: Self.thousands).format(0.123456) == "0.123456")
                #expect(Number(fractionDigits: 2, grouping: Self.thousands).format(999.996) == "1,000.00")
                #expect(Number(fractionDigits: 0, grouping: Self.thousands).format(-999.5) == "-1,000")
                #expect(Number(scale: .percent, grouping: Self.thousands).format(12.345) == "1,234.5%")
            }

            @Test
            func `NaN and infinities are not grouped`() {
                let number = Number(padding: 4, grouping: Self.thousands)
                #expect(number.format(.nan) == "nan")
                #expect(number.format(.infinity) == "inf")
                #expect(number.format(-.infinity) == "-inf")
            }

            @Test(arguments: [0, 1, 12, 999, 1_000, 1_234_567.25, -98_765.4321, 0.000_123, 1e21, 123_456_789_012_345_680])
            func `Removing the separators gives the ungrouped output, which reads back as the value`(value: Double) {
                let grouped = Number(grouping: .init(separator: "_", primary: 3, secondary: 2)).format(value)
                let plain = Number().format(value)
                #expect(grouped.replacing("_", with: "") == plain)
                #expect(Double(plain) == value)
            }
        }
    }

    extension `Formatter.Number Tests` {
        @Suite
        struct Padding {
            typealias Number = Formatter.Number

            @Test
            func `Pads the integer digits with leading zeros and never truncates`() {
                #expect(Number(padding: 4).format(660) == "0660")
                #expect(Number(padding: 4).format(1_234) == "1234")
                #expect(Number(padding: 4).format(12_345) == "12345")
                #expect(Number(padding: 3).format(0) == "000")
                #expect(Number(padding: 1).format(0.5) == "0.5")
                #expect(Number(padding: 2).format(0.5) == "00.5")
            }

            @Test
            func `The sign goes in front of the zeros`() {
                #expect(Number(padding: 3).format(-5) == "-005")
                #expect(Number(padding: 3).format(-0.25) == "-000.25")
            }

            @Test
            func `Padding counts digits after rounding and before the percent shift is undone`() {
                #expect(Number(fractionDigits: 1, padding: 2).format(9.96) == "10.0")
                #expect(Number(fractionDigits: 1, padding: 3).format(9.96) == "010.0")
                #expect(Number(fractionDigits: 2, padding: 2).format(3.14159) == "03.14")
                #expect(Number(scale: .percent, padding: 3).format(0.05) == "005%")
            }

            @Test
            func `Padding zeros are grouped like any other digit`() {
                let grouping = Number.Grouping(separator: ",", size: 3)
                #expect(Number(padding: 4, grouping: grouping).format(660) == "0,660")
                #expect(Number(padding: 7, grouping: grouping).format(-42) == "-0,000,042")
                #expect(Number(padding: 3, grouping: grouping).format(42) == "042")
            }
        }
    }
    extension `Formatter.Number Tests` {
        @Suite
        struct `Exact rationals` {
            typealias Number = Formatter.Number

            static func fraction(_ numerator: Int, _ denominator: Int) throws -> Rational {
                try Rational(numerator: numerator, denominator: denominator)
            }

            @Test
            func `Rounds the exact value at the fraction digits, half away from zero by default`() throws {
                let number = Number(fractionDigits: 2)
                #expect(number.format(try Self.fraction(247, 20)) == "12.35")
                #expect(number.format(try Self.fraction(1_001, 30_000)) == "0.03")
                #expect(number.format(try Self.fraction(1, 200)) == "0.01")
                #expect(number.format(try Self.fraction(-1, 200)) == "-0.01")
                #expect(number.format(try Self.fraction(-3, 2)) == "-1.50")
                #expect(number.format(Rational.zero) == "0.00")
                #expect(number.format(try Self.fraction(249_999, 250)) == "1000.00")
            }

            @Test
            func `Without fraction digits a terminating decimal is written in full`() throws {
                #expect(Number().format(try Self.fraction(1, 8)) == "0.125")
                #expect(Number().format(try Self.fraction(-7, 2)) == "-3.5")
                #expect(Number().format(Rational(12)) == "12")
                let tiny = try Rational.one.divided(by: try Rational(2).raised(to: 400))
                let written = Number().format(tiny)
                #expect(written.count == 402)
                #expect(written.hasPrefix("0.000"))
                #expect(written.hasSuffix("5"))
            }

            @Test
            func `Without fraction digits a non-terminating decimal is rounded at 324 digits`() throws {
                #expect(Number().format(try Self.fraction(1, 3)) == "0." + String(repeating: "3", count: 324))
                #expect(Number().format(try Self.fraction(-2, 3)) == "-0." + String(repeating: "6", count: 323) + "7")
                let vanishing = try Self.fraction(1, 3).divided(by: try Rational(10).raised(to: 330))
                #expect(Number().format(vanishing) == "0")
            }

            @Test(arguments: [
                (FloatingPointRoundingRule.toNearestOrAwayFromZero, "0.63", "-0.63", "0.67", "0.63"),
                (.toNearestOrEven, "0.62", "-0.62", "0.67", "0.63"),
                (.towardZero, "0.62", "-0.62", "0.66", "0.62"),
                (.awayFromZero, "0.63", "-0.63", "0.67", "0.63"),
                (.up, "0.63", "-0.62", "0.67", "0.63"),
                (.down, "0.62", "-0.63", "0.66", "0.62"),
            ])
            func `Each rounding rule on a tie and off a tie`(
                rounding: FloatingPointRoundingRule,
                tie: String,
                negativeTie: String,
                twoThirds: String,
                aboveTie: String
            ) throws {
                let number = Number(fractionDigits: 2, rounding: rounding)
                #expect(number.format(try Self.fraction(5, 8)) == tie)
                #expect(number.format(try Self.fraction(-5, 8)) == negativeTie)
                #expect(number.format(try Self.fraction(2, 3)) == twoThirds)
                #expect(number.format(try Self.fraction(5, 8) + (try Self.fraction(1, 3_000_000))) == aboveTie)
            }

            @Test
            func `Percent shifts the exact value two places`() throws {
                #expect(Number(scale: .percent).format(try Self.fraction(1, 8)) == "12.5%")
                #expect(Number(fractionDigits: 1, scale: .percent).format(try Self.fraction(1, 3)) == "33.3%")
                #expect(Number(fractionDigits: 0, scale: .percent).format(try Self.fraction(-1, 200)) == "-1%")
            }

            @Test
            func `Pads and groups a rational like a double`() throws {
                let thousands = Number.Grouping(separator: ",", size: 3)
                #expect(Number(fractionDigits: 2, padding: 3).format(Rational.half) == "000.50")
                #expect(Number(padding: 2).format(try Self.fraction(-1, 4)) == "-00.25")
                #expect(Number(fractionDigits: 1, grouping: thousands).format(try Self.fraction(1_234_567, 2)) == "617,283.5")
                #expect(Number(fractionDigits: 2, grouping: thousands).format(try Self.fraction(249_999, 250)) == "1,000.00")
                #expect(Number(padding: 7, grouping: thousands).format(Rational(-42)) == "-0,000,042")
            }

            static let formatters: [Number] = [
                Number(),
                Number(fractionDigits: 0),
                Number(fractionDigits: 1),
                Number(fractionDigits: 2, rounding: .toNearestOrEven),
                Number(fractionDigits: 2, rounding: .towardZero),
                Number(fractionDigits: 2, rounding: .up),
                Number(fractionDigits: 2, rounding: .down),
                Number(fractionDigits: 6),
                Number(scale: .percent),
                Number(fractionDigits: 1, scale: .percent, padding: 4, grouping: .init(separator: ",", size: 3)),
            ]

            @Test(arguments: [0, 0.5, -0.375, 0.125, 3, -2.75, 1_024.0625, 1_234_567.5, 0.005_859_375])
            func `A double with few digits formats as its exact rational does`(value: Double) throws {
                let exact = try Rational(exactly: value)
                for number in Self.formatters {
                    #expect(number.format(exact) == number.format(value))
                }
            }
        }
    }
#endif
