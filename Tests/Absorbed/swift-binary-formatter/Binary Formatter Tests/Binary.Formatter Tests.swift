#if Binary
import Testing

@testable import Formatter

@Suite
struct `Binary.Formatter - Continuous hex` {

    @Suite struct Unit {

        @Test
        func `Four-byte stream renders deadbeef`() {
            let data: [Byte] = [Byte(bitPattern: 0xDE), Byte(bitPattern: 0xAD), Byte(bitPattern: 0xBE), Byte(bitPattern: 0xEF)]
            #expect(data.formatted(.hex) == "deadbeef")
        }

        @Test
        func `Empty stream renders empty string`() {
            let data: [Byte] = []
            #expect(data.formatted(.hex).isEmpty)
        }

        @Test
        func `Single byte renders two glyphs`() {
            #expect(([Byte(bitPattern: 0x0A)] as [Byte]).formatted(.hex) == "0a")
        }

        @Test
        func `Each byte contributes two glyphs`() {
            let data: [Byte] = [Byte(bitPattern: 0x00), Byte(bitPattern: 0x01), Byte(bitPattern: 0xFF)]
            #expect(data.formatted(.hex) == "0001ff")
            #expect(data.formatted(.hex).count == data.count * 2)
        }

        @Test
        func `Slice is a valid byte stream`() {
            let data: [Byte] = [Byte(bitPattern: 0xDE), Byte(bitPattern: 0xAD), Byte(bitPattern: 0xBE), Byte(bitPattern: 0xEF)]
            #expect(data[1...2].formatted(.hex) == "adbe")
        }
    }

    @Suite struct `Edge Case` {}

    @Suite struct Integration {}
}

@Suite
struct `Binary.Formatter - Spaced hex` {

    @Suite struct Unit {

        @Test
        func `Four-byte stream renders spaced groups`() {
            let data: [Byte] = [Byte(bitPattern: 0xDE), Byte(bitPattern: 0xAD), Byte(bitPattern: 0xBE), Byte(bitPattern: 0xEF)]
            #expect(data.formatted(.spaced) == "de ad be ef")
        }

        @Test
        func `Single byte carries no trailing separator`() {
            #expect(([Byte(bitPattern: 0xFF)] as [Byte]).formatted(.spaced) == "ff")
        }

        @Test
        func `Custom separator is honoured`() {
            let data: [Byte] = [Byte(bitPattern: 0xDE), Byte(bitPattern: 0xAD)]
            #expect(data.formatted(Binary.Formatter(separator: ":")) == "de:ad")
        }
    }

    @Suite struct `Edge Case` {}

    @Suite struct Integration {}
}

@Suite
struct `Binary.Formatter - Radix composition` {

    @Suite struct Unit {

        @Test
        func `Decimal byte format flows through`() {
            let data: [Byte] = [Byte(bitPattern: 0), Byte(bitPattern: 10), Byte(bitPattern: 255)]
            let format = Binary.Formatter<[Byte]>(
                byte: Byte.Formatter(radix: .decimal),
                separator: " "
            )
            #expect(data.formatted(format) == "000 010 255")
        }

        @Test
        func `Binary byte format flows through`() {
            let data: [Byte] = [Byte(bitPattern: 0b0000_0001), Byte(bitPattern: 0b1010_0000)]
            let format = Binary.Formatter<[Byte]>(byte: Byte.Formatter(radix: .binary))
            #expect(data.formatted(format) == "0000000110100000")
        }
    }

    @Suite struct `Edge Case` {}

    @Suite struct Integration {}
}

@Suite
struct `Binary.Formatter - Formatter.Protocol conformance` {

    @Suite struct Unit {

        @Test
        func `format() method renders directly`() {
            let data: [Byte] = [Byte(bitPattern: 0xDE), Byte(bitPattern: 0xAD), Byte(bitPattern: 0xBE), Byte(bitPattern: 0xEF)]
            #expect(Binary.Formatter<[Byte]>.hex.format(data) == "deadbeef")
        }

        @Test
        func `Works via the generic formatted overload`() {
            let data: [Byte] = [Byte(bitPattern: 0x0A), Byte(bitPattern: 0x0B)]
            #expect(data.formatted(Binary.Formatter<[Byte]>.spaced) == "0a 0b")
        }
    }

    @Suite struct `Edge Case` {}

    @Suite struct Integration {}
}
#endif
