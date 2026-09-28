#if Tagged
public import Tagged

extension Tagged::Tagged where Tag: ~Copyable & ~Escapable, Underlying: BinaryFloatingPoint {

    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where
        F: Formatter::Formatter.`Protocol`, F.Input: BinaryFloatingPoint, F.Failure == Never
    {
        format.format(F.Input(underlying))
    }
}
#endif
