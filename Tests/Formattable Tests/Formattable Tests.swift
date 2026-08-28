import Formattable
import Testing

private struct Value: Formattable {
    let rawValue: Int
    static let formatter = ValueFormatter()
}

private struct ValueFormatter: Formatter::Formatter.`Protocol` {
    func format(_ value: Value) -> Int { value.rawValue }
    typealias Input = Value
    typealias Output = Int
    typealias Failure = Never
}

@Suite
struct `Formattable Tests` {
    @Test
    func `value uses its canonical formatter`() {
        #expect(Value(rawValue: 7).formatted() == 7)
    }
}
