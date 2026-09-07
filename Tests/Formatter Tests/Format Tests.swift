import Formatter
import Testing

@Suite
struct `Closure formatters apply their supplied transformation` {
    @Test
    func `closure-backed format transforms input`() {
        let format = Format<Int, String, Never> { String($0) }
        #expect(format.format(12) == "12")
    }
}
