#if Conversions
import Formatter
import Text
import Testing

@Suite
struct `Text casing - Upper` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `Lowercase to uppercase`() {
        #expect("hello world".uppercased() == "HELLO WORLD")
    }

    @Test
    func `Already uppercase is unchanged`() {
        #expect("HELLO".uppercased() == "HELLO")
    }

    @Test
    func `Empty string returns empty`() {
        #expect("".uppercased().isEmpty)
    }

    @Test
    func `Mixed case lifts all to upper`() {
        #expect("HeLLo".uppercased() == "HELLO")
    }
}

@Suite
struct `Text casing - Lower` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `Uppercase to lowercase`() {
        #expect("HELLO WORLD".lowercased() == "hello world")
    }

    @Test
    func `Already lowercase is unchanged`() {
        #expect("hello".lowercased() == "hello")
    }

    @Test
    func `Empty string returns empty`() {
        #expect("".lowercased().isEmpty)
    }
}

@Suite
struct `Text casing - Title` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `Basic title case`() {
        #expect(Text.titlecased("hello world") == "Hello World")
    }

    @Test
    func `Already title case is unchanged`() {
        #expect(Text.titlecased("Hello World") == "Hello World")
    }

    @Test
    func `Single word is capitalized`() {
        #expect(Text.titlecased("hello") == "Hello")
    }

    @Test
    func `Empty string returns empty`() {
        #expect(Text.titlecased("").isEmpty)
    }

    @Test
    func `All caps are title-cased`() {
        #expect(Text.titlecased("HELLO WORLD") == "Hello World")
    }
}

@Suite
struct `Text casing - Sentence` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `First letter capitalized, rest lowered`() {
        #expect(Text.sentencecased("hello world") == "Hello world")
    }

    @Test
    func `All caps sentence-cased`() {
        #expect(Text.sentencecased("HELLO WORLD") == "Hello world")
    }

    @Test
    func `Single character`() {
        #expect(Text.sentencecased("h") == "H")
    }

    @Test
    func `Empty string returns empty`() {
        #expect(Text.sentencecased("").isEmpty)
    }
}

@Suite
struct `Text casing - Custom` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `Identity transformation`() {
        let identity = Format<String, String, Never> { $0 }
        #expect("hello".formatted(identity) == "hello")
    }

    @Test
    func `Closure is invoked with input string`() {
        let reverse = Format<String, String, Never> { String($0.reversed()) }
        #expect("abc".formatted(reverse) == "cba")
    }
}

@Suite
struct `StringProtocol.formatted - Substring` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `Substring formats via upper`() {
        let source = "hello world"
        let sub = source[...]
        #expect(sub.uppercased() == "HELLO WORLD")
    }

    @Test
    func `Substring formats via title`() {
        let source = "hello world"
        let sub = source[...]
        #expect(Text.titlecased(sub) == "Hello World")
    }
}

@Suite
struct `Text casing - Formatter.Protocol conformance` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `format() method applies transform`() {
        let upper = Format<String, String, Never> { $0 }
        #expect(upper.format("hello".uppercased()) == "HELLO")
    }

    @Test
    func `Works via generic formatted<F: Formatter.Protocol>`() {

        func applyAny<F: Formatter.`Protocol`>(_ style: F, to string: String) -> F.Output
        where F.Input == String, F.Failure == Never {
            string.formatted(style)
        }
        #expect(applyAny(Format<String, String, Never> { $0 }, to: "HELLO".lowercased()) == "hello")
    }
}

#endif
