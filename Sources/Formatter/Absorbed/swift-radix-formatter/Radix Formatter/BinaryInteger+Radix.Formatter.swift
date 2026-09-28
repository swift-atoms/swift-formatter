#if Radix
public import Radix

extension Swift.BinaryInteger {

    @inlinable
    public func formatted(_ format: Radix.Formatter) -> String {
        format.format(self)
    }

    @inlinable
    public func formatted<F: Formatter::Formatter.`Protocol`>(
        _ format: F
    ) throws(F.Failure) -> F.Output
    where F.Input == Self {
        try format.format(self)
    }
}
#endif
