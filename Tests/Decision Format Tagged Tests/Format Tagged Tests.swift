#if Tagged && Number
import Formatter
import Tagged
import Testing

@Suite
struct `Format Tagged Tests` {
    private enum Measurement {}

    @Test
    func `Number format delegates to the tagged floating point`() {
        let value = Tagged<Measurement, Double>(_unchecked: 12.5)

        #expect(value.formatted(Formatter.Number()) == "12.5")
    }

    @Test
    func `Precision and rounding remain available`() {
        let value = Tagged<Measurement, Double>(_unchecked: 12.375)
        let rounded = Tagged<Measurement, Double>(_unchecked: 2.6)

        #expect(value.formatted(Formatter.Number(fractionDigits: 2)) == "12.38")
        #expect(rounded.formatted(Formatter.Number(fractionDigits: 0)) == "3")
    }

    @Test
    func `Percent format scales the underlying value`() {
        let value = Tagged<Measurement, Double>(_unchecked: 0.125)

        #expect(value.formatted(Formatter.Number(fractionDigits: 1, scale: .percent)) == "12.5%")
    }
}
#endif
