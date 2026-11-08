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

#if Radix
    public import Radix

    extension Radix.Formatter {

        @inlinable
        public var prefix: Self {
            .init(
                radix: radix,
                prefix: prefixString,
                showPrefix: true,
                signStrategy: signStrategy,
                minWidth: minWidth
            )
        }

        @inlinable
        public func sign(_ strategy: Sign.Display) -> Self {
            .init(
                radix: radix,
                prefix: prefixString,
                showPrefix: showPrefix,
                signStrategy: strategy,
                minWidth: minWidth
            )
        }

        @inlinable
        public func zeroPadded(width: Int) -> Self {
            .init(
                radix: radix,
                prefix: prefixString,
                showPrefix: showPrefix,
                signStrategy: signStrategy,
                minWidth: width
            )
        }
    }
#endif

#if Radix
    public import Radix

    extension Radix.Formatter {

        @inlinable
        public func format<T: Swift::BinaryInteger>(_ value: T) -> String {
            render(value)
        }
    }

    extension Radix.Formatter {

        @usableFromInline
        func render<T: Swift::BinaryInteger>(_ value: T) -> String {
            let base = T.Magnitude(radix.base)
            var magnitude = value.magnitude

            var scalars: [Unicode.Scalar] = []
            if magnitude == 0 {
                scalars.append(radix.digit(for: 0) ?? "0")
            } else {
                while magnitude > 0 {
                    let remainder = Int(magnitude % base)
                    scalars.append(radix.digit(for: remainder) ?? "0")
                    magnitude /= base
                }
                scalars.reverse()
            }

            var result = String(String.UnicodeScalarView(scalars))

            if let minWidth {
                let padding = max(0, minWidth - result.count)
                result = String(repeating: "0", count: padding) + result
            }

            if showPrefix {
                result = prefixString + result
            }

            if value < 0 {
                result = "-" + result
            } else if signStrategy.shouldAlwaysShowSign {
                result = "+" + result
            }

            return result
        }
    }
#endif

#if Radix
    public import Radix

    extension Radix.Formatter {

        public init(signStrategy: Sign.Display = .automatic, minWidth: Int? = nil) {
            self.init(
                radix: .decimal,
                prefix: "",
                showPrefix: false,
                signStrategy: signStrategy,
                minWidth: minWidth
            )
        }
    }
#endif

#if Radix
    public import Radix

    extension Radix.Formatter {

        @inlinable
        public static var decimal: Self {
            .init(radix: .decimal, prefix: "")
        }

        @inlinable
        public static var number: Self { .decimal }

        @inlinable
        public static var base2: Self {
            .init(radix: .binary, prefix: "0b")
        }

        @inlinable
        public static var bits: Self { .base2 }

        @inlinable
        public static var octal: Self {
            .init(radix: .octal, prefix: "0o")
        }

        @inlinable
        public static var hex: Self {
            .init(radix: .hexadecimal, prefix: "0x")
        }
    }
#endif
