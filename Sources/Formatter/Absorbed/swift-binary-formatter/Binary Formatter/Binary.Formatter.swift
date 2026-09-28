#if Binary
public import Binary


extension Binary {

    public struct Formatter<Bytes: Swift.Collection>: Sendable, Formatter::Formatter
            .`Protocol`
    where Bytes.Element == Byte {

        @usableFromInline
        let byte: Byte.Formatter

        @usableFromInline
        let separator: String

        @inlinable
        public init(byte: Byte.Formatter = .hexadecimal, separator: String = "") {
            self.byte = byte
            self.separator = separator
        }
    }
}

extension Binary.Formatter {

    public typealias Input = Bytes

    public typealias Output = String

    public typealias Failure = Never

    @inlinable
    public func format(_ value: Bytes) -> String {
        var output = ""
        output.reserveCapacity(value.count * 2)
        var first = true
        for element in value {
            if !first {
                output += separator
            }
            output += byte.format(element)
            first = false
        }
        return output
    }
}

extension Binary.Formatter {

    @inlinable
    public static var hex: Self {
        Self(byte: .hexadecimal, separator: "")
    }

    @inlinable
    public static var spaced: Self {
        Self(byte: .hexadecimal, separator: " ")
    }
}
#endif
