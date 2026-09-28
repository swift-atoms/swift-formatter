#if Radix
public import Radix

extension Radix.Formatter: Formatter::Formatter.`Protocol` {

    public typealias Input = Int

    public typealias Output = String

    public typealias Failure = Never

    @inlinable
    public func format(_ value: Int) -> String {
        render(value)
    }
}
#endif
