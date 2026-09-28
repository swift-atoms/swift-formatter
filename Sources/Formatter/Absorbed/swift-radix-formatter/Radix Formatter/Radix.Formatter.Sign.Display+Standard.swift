#if Radix
public import Radix

extension Radix.Formatter.Sign.Display {

    @usableFromInline
    var shouldAlwaysShowSign: Bool {
        _shouldAlwaysShowSign()
    }
}

extension Radix.Formatter.Sign.Display {

    @inlinable
    public static var automatic: Self {
        .init { false }
    }

    @inlinable
    public static var always: Self {
        .init { true }
    }
}
#endif
