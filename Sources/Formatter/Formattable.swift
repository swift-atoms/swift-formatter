public protocol Formattable {

    associatedtype Formatter: Formatter::Formatter.`Protocol`

    static var formatter: Formatter { get }
}

extension Formattable where Formatter.Input == Self {

    @inlinable
    public func formatted() throws(Formatter.Failure) -> Formatter.Output {
        try Self.formatter.format(self)
    }
}
