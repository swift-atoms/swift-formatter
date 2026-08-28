import Formatter
import Testing

@Suite
struct `Formatter Tests` {
    @Test
    func `formatter namespace is empty`() {
        #expect(MemoryLayout<Formatter::Formatter>.size == 0)
    }
}
