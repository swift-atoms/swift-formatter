#if Radix
public import Radix

extension Radix.Formatter.Sign {

    public struct Display {
        @usableFromInline
        let _shouldAlwaysShowSign: @Sendable () -> Bool

        @usableFromInline
        init(shouldAlwaysShowSign: @escaping @Sendable () -> Bool) {
            self._shouldAlwaysShowSign = shouldAlwaysShowSign
        }
    }
}

extension Radix.Formatter.Sign.Display: Sendable {}
#endif
