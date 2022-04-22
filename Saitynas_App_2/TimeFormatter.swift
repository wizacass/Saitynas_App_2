import Foundation

class TimeFormatter {
    func formatTime(seconds: Int?) -> String {
        guard let seconds = seconds else { return "0 s" }
        if seconds == 0 { return "0 s" }

        let power = getPower(seconds, 60)
        switch power {
        case 0:
            return "\(seconds) s"
        case 1:
            return formatWithMaxMinutes(seconds)
        default:
            return formatWithMaxHours(seconds)
        }
    }

    private func getPower(_ value: Int, _ basePower: Int) -> Int {
        return value == 0 ? 0 : Int(floor(logC(Double(value), Double(basePower))))
    }

    private func logC(_ val: Double, _ base: Double) -> Double {
        return log(val) / log(base)
    }

    private func formatWithMaxHours(_ value: Int) -> String {
        let hours = value / 3600
        let minutes = (value % 3600) / 60
        let minString = pluralizeMinutes(minutes)

        return "\(hours) h \(minutes) \(minString)"
    }

    private func formatWithMaxMinutes(_ value: Int) -> String {
        let minutes = Int(round(Double(value) / 60.0))
        let minString = pluralizeMinutes(minutes)

        return "\(minutes) \(minString)"
    }

    private func pluralizeMinutes(_ minutes: Int) -> String {
        return minutes == 1 ? "min" : "mins"
    }
}
