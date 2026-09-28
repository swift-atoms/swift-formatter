#if BitPattern
public import Bit_Pattern

extension Bit.Pattern.Mask {

    @inlinable
    public func formatted(_ format: Bit.Formatter<Carrier>) -> String {
        format.format(self)
    }

    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where
        F: Formatter::Formatter.`Protocol`, F.Input == Bit.Pattern<Carrier>.Mask,
        F.Failure == Never
    {
        format.format(self)
    }
}
#endif
