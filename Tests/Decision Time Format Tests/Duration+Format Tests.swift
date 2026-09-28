#if Time && Number
import Testing
import Formatter

@Suite
struct `Duration Format Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Duration Format Tests`.Unit {
    @Test
    func `automatic units cover subsecond boundaries`() {
        #expect(Duration.nanoseconds(500).formatted(Formatter.Duration(numeric: Formatter.Number())) == "500 ns")
        #expect(Duration.microseconds(500).formatted(Formatter.Duration(numeric: Formatter.Number())) == "500 µs")
        #expect(Duration.milliseconds(500).formatted(Formatter.Duration(numeric: Formatter.Number())) == "500 ms")
        #expect(Duration.milliseconds(1_500).formatted(Formatter.Duration(numeric: Formatter.Number())) == "1.5 s")
    }

    @Test
    func `forced units and precision are honored`() {
        let duration = Duration.milliseconds(1_500)

        #expect(duration.formatted(Formatter.Duration(numeric: Formatter.Number(fractionDigits: 2), unit: .seconds)) == "1.50 s")
        #expect(duration.formatted(Formatter.Duration(numeric: Formatter.Number(), unit: .milliseconds)) == "1500 ms")
        #expect(duration.formatted(Formatter.Duration(numeric: Formatter.Number(), unit: .microseconds, notation: .compactName)) == "1500000µs")
    }

    @Test
    func `floating point construction preserves unit conversions`() {
        let duration = Duration.seconds(1.25)

        #expect(abs(Formatter.Duration(numeric: Formatter.Number(), unit: .seconds).scaledValue(for: duration).value - 1.25) < 1e-12)
        #expect(abs(Formatter.Duration(numeric: Formatter.Number(), unit: .milliseconds).scaledValue(for: duration).value - 1_250) < 1e-9)
        #expect(abs(Formatter.Duration(numeric: Formatter.Number(), unit: .microseconds).scaledValue(for: duration).value - 1_250_000) < 1e-6)
        #expect(abs(Formatter.Duration(numeric: Formatter.Number(), unit: .nanoseconds).scaledValue(for: duration).value - 1_250_000_000) < 1e-3)
    }
}

extension `Duration Format Tests`.`Edge Case` {
    @Test
    func `negative durations select units by magnitude`() {
        #expect(Duration.seconds(-1.5).formatted(Formatter.Duration(numeric: Formatter.Number())) == "-1.5 s")
        #expect(Duration.milliseconds(-500).formatted(Formatter.Duration(numeric: Formatter.Number())) == "-500 ms")
        #expect(Duration.microseconds(-500).formatted(Formatter.Duration(numeric: Formatter.Number())) == "-500 µs")
        #expect(Duration.nanoseconds(-500).formatted(Formatter.Duration(numeric: Formatter.Number())) == "-500 ns")
    }

    @Test
    func `large durations retain explicit unit meaning`() {
        let duration = Duration.seconds(1_000_000_000)

        #expect(duration.formatted(Formatter.Duration(numeric: Formatter.Number(), unit: .seconds)) == "1000000000 s")
        #expect(Formatter.Duration(numeric: Formatter.Number(), unit: .seconds).scaledValue(for: duration).value == 1_000_000_000)
    }
}

extension `Duration Format Tests`.Integration {
    @Test
    func `format style is reusable through the formatter protocol surface`() {
        let format = Formatter.Duration(numeric: Formatter.Number(fractionDigits: 3))

        #expect(format.format(.milliseconds(1_250)) == "1.250 s")
        #expect(Duration.milliseconds(1_250).formatted(format) == "1.250 s")
    }
}
#endif
