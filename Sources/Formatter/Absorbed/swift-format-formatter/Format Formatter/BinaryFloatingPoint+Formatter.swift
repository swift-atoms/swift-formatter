#if Conversions
extension BinaryFloatingPoint {

    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where Self == F.Input, F: Formatter.`Protocol`, F.Failure == Never {
        format.format(self)
    }

    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where F: Formatter.`Protocol`, F.Input: Swift.BinaryFloatingPoint, F.Failure == Never {
        format.format(F.Input(self))
    }
}
#endif
