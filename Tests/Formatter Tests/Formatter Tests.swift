import Formatter
import Testing

enum `Formatter Tests` {}

extension `Formatter Tests` {
    @Suite
    struct `The Formatter namespace has zero size` {
        @Test
        func `formatter namespace is empty`() {
            #expect(MemoryLayout<Formatter::Formatter>.size == 0)
        }
    }
}
