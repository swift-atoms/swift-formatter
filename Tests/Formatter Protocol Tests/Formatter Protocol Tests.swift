import Formatter_Protocol
import Testing

private struct DescriptionFormatter: Formatter::Formatter.`Protocol` {
    func format(_ value: Int) -> String { String(value) }
    typealias Input = Int
    typealias Output = String
    typealias Failure = Never
}

@Suite
struct `Formatter Protocol Tests` {
    @Test
    func `formatter transforms its input`() {
        #expect(DescriptionFormatter().format(42) == "42")
    }
}
