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
