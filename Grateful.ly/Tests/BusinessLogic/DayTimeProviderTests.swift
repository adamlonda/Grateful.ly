//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2022 Adam Londa. All rights reserved.
//

import Foundation
import XCTest

class DayTimeProviderTests: XCTestCase {
    func test_whenTimeCheckerGives4To12_thenShoudReturnMorning() {
        let date = Date.mock(hour: 8)
        XCTFail("Implement me ‼️")
    }

    func test_whenTimeCheckerGives12To18_thenShouldReturnAfternoon() {
        XCTFail("Implement me ‼️")
    }

    func test_whenTimeCheckerGives18To24_thenShouldReturnEvening() {
        XCTFail("Implement me ‼️")
    }

    func test_whenTimeCheckerGives24To4_thenShouldReturnNight() {
        XCTFail("Implement me ‼️")
    }
}

private extension Date {
    static func mock(hour: Int) -> Date? {
        let calendar = Calendar.current
        let now = Date.now
        let dateComponents = DateComponents(
            calendar: calendar,
            era: calendar.component(.era, from: now),
            year: calendar.component(.year, from: now),
            month: calendar.component(.month, from: now),
            day: calendar.component(.day, from: now),
            hour: hour,
            minute: calendar.component(.minute, from: now),
            second: calendar.component(.second, from: now),
            nanosecond: calendar.component(.nanosecond, from: now),
            weekday: calendar.component(.weekday, from: now),
            weekdayOrdinal: calendar.component(.weekdayOrdinal, from: now),
            quarter: calendar.component(.quarter, from: now),
            weekOfMonth: calendar.component(.weekOfMonth, from: now),
            weekOfYear: calendar.component(.weekOfYear, from: now),
            yearForWeekOfYear: calendar.component(.yearForWeekOfYear, from: now)
        )
        return calendar.date(from: dateComponents)
    }
}
