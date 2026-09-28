#if Radix
public import Radix

extension Radix {

    public struct Formatter {

        @usableFromInline
        let radix: Radix

        @usableFromInline
        let prefixString: String

        @usableFromInline
        let showPrefix: Bool

        public let signStrategy: Sign.Display

        public let minWidth: Int?

        @usableFromInline
        init(
            radix: Radix,
            prefix: String,
            showPrefix: Bool = false,
            signStrategy: Sign.Display = .automatic,
            minWidth: Int? = nil
        ) {
            self.radix = radix
            self.prefixString = prefix
            self.showPrefix = showPrefix
            self.signStrategy = signStrategy
            self.minWidth = minWidth
        }
    }
}

extension Radix.Formatter: Sendable {}
#endif
