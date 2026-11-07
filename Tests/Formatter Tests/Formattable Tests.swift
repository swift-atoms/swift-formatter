import Formatter
import Testing

private struct Value: Formattable {
    let rawValue: Int
}

extension Value {
    static let formatter = ValueFormatter()
}

private struct ValueFormatter: Formatter::Formatter.`Protocol` {}

extension ValueFormatter {
    func format(_ value: Value) -> Int { value.rawValue }
    typealias Input = Value
    typealias Output = Int
    typealias Failure = Never
}

enum `Formattable Tests` {}

extension `Formattable Tests` {
    @Suite
    struct `Formattable values use their canonical formatter` {
        @Test
        func `value uses its canonical formatter`() {
            #expect(Value(rawValue: 7).formatted() == 7)
        }
    }
}
