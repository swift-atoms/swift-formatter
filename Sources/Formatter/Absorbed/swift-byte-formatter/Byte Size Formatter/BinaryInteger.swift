#if Byte
    extension BinaryInteger {

        @inlinable
        public func formatted(_ format: Byte.Size.Formatter<Self>) -> String {
            format.format(self)
        }

    }
#endif

#if Conversions
    extension BinaryInteger {

        @inlinable
        public func formatted<F>(_ format: F) -> F.Output
        where Self == F.Input, F: Formatter.`Protocol`, F.Failure == Never {
            format.format(self)
        }

        @inlinable
        public func formatted<F>(_ format: F) -> F.Output
        where F: Formatter.`Protocol`, F.Input: Swift::BinaryInteger, F.Failure == Never {
            format.format(F.Input(self))
        }
    }
#endif
