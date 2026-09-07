import Formatter
import Testing

@Suite
struct `Format Tests` {
    @Test
    func `closure-backed format transforms input`() {
        let format = Format<Int, String, Never> { String($0) }
        #expect(format.format(12) == "12")
    }
}
