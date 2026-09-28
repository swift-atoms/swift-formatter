#if Radix
public import Radix

extension Radix.Formatter {

    @inlinable
    public var prefix: Self {
        .init(
            radix: radix,
            prefix: prefixString,
            showPrefix: true,
            signStrategy: signStrategy,
            minWidth: minWidth
        )
    }

    @inlinable
    public func sign(_ strategy: Sign.Display) -> Self {
        .init(
            radix: radix,
            prefix: prefixString,
            showPrefix: showPrefix,
            signStrategy: strategy,
            minWidth: minWidth
        )
    }

    @inlinable
    public func zeroPadded(width: Int) -> Self {
        .init(
            radix: radix,
            prefix: prefixString,
            showPrefix: showPrefix,
            signStrategy: signStrategy,
            minWidth: width
        )
    }
}
#endif
