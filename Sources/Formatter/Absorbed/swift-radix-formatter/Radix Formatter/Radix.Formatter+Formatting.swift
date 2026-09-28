#if Radix
public import Radix

extension Radix.Formatter {

    @inlinable
    public func format<T: Swift.BinaryInteger>(_ value: T) -> String {
        render(value)
    }
}

extension Radix.Formatter {

    @usableFromInline
    func render<T: Swift.BinaryInteger>(_ value: T) -> String {
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
