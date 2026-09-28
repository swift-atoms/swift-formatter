#if Radix
public import Radix

extension Radix.Formatter {

    @inlinable
    public static var decimal: Self {
        .init(radix: .decimal, prefix: "")
    }

    @inlinable
    public static var number: Self { .decimal }

    @inlinable
    public static var base2: Self {
        .init(radix: .binary, prefix: "0b")
    }

    @inlinable
    public static var bits: Self { .base2 }

    @inlinable
    public static var octal: Self {
        .init(radix: .octal, prefix: "0o")
    }

    @inlinable
    public static var hex: Self {
        .init(radix: .hexadecimal, prefix: "0x")
    }
}
#endif
