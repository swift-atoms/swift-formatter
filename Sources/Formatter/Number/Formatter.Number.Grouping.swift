#if Number
    extension Formatter.Number {

        /// How the integer digits of a number are split into groups, counted from the decimal point leftwards.
        ///
        /// The group next to the decimal point has `primary` digits and every group further left has
        /// `secondary` digits, so one size covers 1,234,567 and two cover 12,34,567. Groups are joined
        /// with `separator`; a number with at most `primary` integer digits has none.
        public struct Grouping: Sendable, Hashable {

            /// The text put between two groups.
            public let separator: String

            /// The number of digits in the group next to the decimal point.
            public let primary: Int

            /// The number of digits in every group further from the decimal point.
            public let secondary: Int

            /// Groups of `primary` digits next to the decimal point and `secondary` digits beyond it, both at least 1.
            public init(separator: String, primary: Int, secondary: Int) {
                precondition(primary > 0 && secondary > 0, "group sizes must be positive")
                self.separator = separator
                self.primary = primary
                self.secondary = secondary
            }
        }
    }

    extension Formatter.Number.Grouping {

        /// Groups of `size` digits throughout, `size` at least 1.
        public init(separator: String, size: Int) {
            self.init(separator: separator, primary: size, secondary: size)
        }

        /// The integer digits `digits` with this grouping's separators put between the groups.
        func apply(to digits: String) -> String {
            var groups: [Substring] = []
            var end = digits.endIndex
            var size = primary
            while digits.distance(from: digits.startIndex, to: end) > size {
                let start = digits.index(end, offsetBy: -size)
                groups.append(digits[start..<end])
                end = start
                size = secondary
            }
            groups.append(digits[digits.startIndex..<end])
            return groups.reversed().joined(separator: separator)
        }
    }
#endif
