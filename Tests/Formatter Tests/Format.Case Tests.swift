#if Conversions
import Formatter
import Testing

@Suite
struct `Generic Formatter.Protocol overloads` {
    private struct Suffix: Formatter.`Protocol` {
        typealias Input = String
        typealias Output = String
        typealias Failure = Never

        func format(_ value: String) -> String {
            value + "!"
        }
    }

    private struct DoubleInteger: Formatter.`Protocol` {
        typealias Input = Int
        typealias Output = Int
        typealias Failure = Never

        func format(_ value: Int) -> Int {
            value * 2
        }
    }

    private struct DescribeInteger: Formatter.`Protocol` {
        typealias Input = Int
        typealias Output = String
        typealias Failure = Never

        func format(_ value: Int) -> String {
            String(value)
        }
    }

    private struct DoubleFloatingPoint: Formatter.`Protocol` {
        typealias Input = Double
        typealias Output = Double
        typealias Failure = Never

        func format(_ value: Double) -> Double {
            value * 2
        }
    }

    @Test
    func `StringProtocol accepts a non-Format formatter`() {
        let source = "hello"[...]

        #expect(source.formatted(Suffix()) == "hello!")
    }

    @Test
    func `BinaryInteger accepts an exact-input formatter`() {
        #expect(21.formatted(DoubleInteger()) == 42)
    }

    @Test
    func `BinaryInteger converts to the formatter input`() {
        #expect(UInt8(42).formatted(DescribeInteger()) == "42")
    }

    @Test
    func `BinaryFloatingPoint accepts an exact-input formatter`() {
        #expect(2.5.formatted(DoubleFloatingPoint()) == 5)
    }

    @Test
    func `BinaryFloatingPoint converts to the formatter input`() {
        #expect(Float(1.25).formatted(DoubleFloatingPoint()) == 2.5)
    }
}
#endif
