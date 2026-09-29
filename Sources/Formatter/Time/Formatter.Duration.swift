#if Time
extension Formatter {
    public struct Duration<Numeric: Formatter.`Protocol`>
    where Numeric.Input == Double, Numeric.Output == String {
        public enum Unit: Sendable, Equatable {
            case auto, nanoseconds, microseconds, milliseconds, seconds

            public var symbol: String {
                switch self {
                case .auto: ""
                case .nanoseconds: "ns"
                case .microseconds: "µs"
                case .milliseconds: "ms"
                case .seconds: "s"
                }
            }
        }

        public enum Notation: Sendable, Equatable {
            case spaced, compactName

            public var separator: String {
                switch self {
                case .spaced: " "
                case .compactName: ""
                }
            }
        }

        public let numeric: Numeric
        public let unit: Unit
        public let notation: Notation

        public init(
            numeric: Numeric,
            unit: Unit = .auto,
            notation: Notation = .spaced
        ) {
            self.numeric = numeric
            self.unit = unit
            self.notation = notation
        }

        public func scaledValue(for duration: Swift.Duration) -> (value: Double, unit: Unit) {
            let components = duration.components
            let seconds = Double(components.seconds) + Double(components.attoseconds) / 1e18
            let selected: Unit
            if unit == .auto {
                let magnitude = abs(seconds)
                if magnitude < 0.000001 { selected = .nanoseconds }
                else if magnitude < 0.001 { selected = .microseconds }
                else if magnitude < 1 { selected = .milliseconds }
                else { selected = .seconds }
            } else {
                selected = unit
            }

            let value: Double
            switch selected {
            case .auto, .seconds: value = seconds
            case .milliseconds:
                value = Double(components.seconds) * 1e3 + Double(components.attoseconds) / 1e15
            case .microseconds:
                value = Double(components.seconds) * 1e6 + Double(components.attoseconds) / 1e12
            case .nanoseconds:
                value = Double(components.seconds) * 1e9 + Double(components.attoseconds) / 1e9
            }
            return (value, selected)
        }
    }
}

extension Formatter.Duration: Sendable where Numeric: Sendable {}

extension Formatter.Duration: Formatter.`Protocol` {
    public typealias Input = Swift.Duration
    public typealias Output = String
    public typealias Failure = Numeric.Failure

    public func format(_ duration: Swift.Duration) throws(Numeric.Failure) -> String {
        let selected = scaledValue(for: duration)
        return try numeric.format(selected.value) + notation.separator + selected.unit.symbol
    }
}

extension Swift.Duration {
    public func formatted<F>(_ formatter: F) throws(F.Failure) -> F.Output
    where F: Formatter.`Protocol`, F.Input == Swift.Duration {
        try formatter.format(self)
    }
}
#endif
