#if Binary
public import Binary


extension Swift.Collection where Element == Byte {

    @inlinable
    public func formatted(_ format: Binary.Formatter<Self>) -> String {
        format.format(self)
    }

    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where F: Formatter::Formatter.`Protocol`, F.Input == Self, F.Failure == Never {
        format.format(self)
    }
}
#endif
