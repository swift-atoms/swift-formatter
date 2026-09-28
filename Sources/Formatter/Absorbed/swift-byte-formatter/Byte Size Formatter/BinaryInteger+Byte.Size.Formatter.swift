#if Byte
extension BinaryInteger {

    @inlinable
    public func formatted(_ format: Byte.Size.Formatter<Self>) -> String {
        format.format(self)
    }

}
#endif
