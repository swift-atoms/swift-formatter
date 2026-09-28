#if BitPattern
public import Bit_Pattern

extension Bit {

    public struct Formatter<Carrier>: Sendable
    where Carrier: FixedWidthInteger & UnsignedInteger {

        @usableFromInline
        let order: Bit.Order

        @usableFromInline
        let group: Int?

        @usableFromInline
        let separator: String

        @inlinable
        public init(order: Bit.Order = .msb, group: Int? = nil, separator: String = " ") {
            precondition(group.map { $0 > 0 } ?? true, "group size must be positive")
            self.order = order
            self.group = group
            self.separator = separator
        }
    }
}

extension Bit.Formatter: Formatter::Formatter.`Protocol` {}

extension Bit.Formatter {

    public typealias Output = String

    public typealias Failure = Never

    @inlinable
    public func format(_ value: Bit.Pattern<Carrier>.Mask) -> String {
        let width = Carrier.bitWidth
        let bits = value.underlying

        var output = ""
        output.reserveCapacity(width + (group.map { width / $0 } ?? 0))

        (0..<width).forEach { step in
            if let group, step != 0, step.isMultiple(of: group) {
                output += separator
            }

            let position: Int
            switch order {
            case .msb: position = width - 1 - step
            case .lsb: position = step
            }

            output.append((bits >> position) & 1 == 1 ? "1" : "0")
        }

        return output
    }
}

extension Bit.Formatter {

    @inlinable
    public static var base2: Self { Self(order: .msb) }

    @inlinable
    public static func base2(order: Bit.Order) -> Self { Self(order: order) }

    @inlinable
    public func grouped(by size: Int, separator: String = " ") -> Self {
        Self(order: order, group: size, separator: separator)
    }
}
#endif
