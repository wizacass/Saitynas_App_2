import XCTest
@testable import Saitynas_App_2

class TimeFormatterTests: XCTestCase {

    override func setUp() { }

    override func tearDown() { }

    private func getTimeFormatter() -> TimeFormatter {
        return TimeFormatter()
    }

    func testTime() {
        let cases: [(Int, String)] = [
            (1,     "1 s"),
            (30,    "30 s"),
            (60,    "1 min"),
            (330,   "6 mins"),
            (3600,  "1 h 0 mins"),
            (3600,  "1 h 0 mins"),
            (36600, "10 h 10 mins"),
            (90060, "25 h 1 min"),
        ]

        cases.forEach {
            assertTime(seconds: $0, expectedString: $1)
        }
    }

    private func assertTime(seconds: Int, expectedString: String) {
        let dataFormatter = getTimeFormatter()

        XCTAssertEqual(dataFormatter.formatTime(seconds: seconds), expectedString, "Seconds: \(seconds)")
    }
}
