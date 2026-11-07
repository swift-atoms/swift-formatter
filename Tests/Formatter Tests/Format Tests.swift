import Formatter
import Testing

enum `Format Tests` {}

extension `Format Tests` {
    @Suite
    struct `Closure formatters apply their supplied transformation` {
        @Test
        func `closure-backed format transforms input`() {
            let format = Format<Int, String, Never> { String($0) }
            #expect(format.format(12) == "12")
        }
    }
}
