#if Conversions
extension StringProtocol {

    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where F: Formatter.`Protocol`, F.Input == String, F.Failure == Never {
        format.format(String(self))
    }
}
#endif
