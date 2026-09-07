import Formatter
import Testing

@Suite
struct `The Formatter namespace has zero size` {
    @Test
    func `formatter namespace is empty`() {
        #expect(MemoryLayout<Formatter::Formatter>.size == 0)
    }
}
