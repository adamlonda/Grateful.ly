//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2021 Adam Londa. All rights reserved.
//

@testable import Gratefully
import XCTest

class LocalStorageTests: XCTestCase {
    func test_when_saving_dayTime_with_todays_date_then_it_should_be_saved() {
        let todaysDate = Date()
        let allDayTimes = DayTime.allCases

        allDayTimes.forEach {
            let sut = storage
            _ = sut.saveCheckIn($0, for: todaysDate)
            XCTAssert(sut.getCheckIns(for: todaysDate).contains($0))
        }
    }

    func test_when_saving_second_dayTime_with_todays_date_then_the_second_dayTime_should_be_appended() {
        let todaysDate = Date()
        let allDayTimes = DayTime.allCases

        allDayTimes.forEach { firstDayTime in
            let otherDayTimes = DayTime.allCases.filter {
                $0 != firstDayTime
            }

            otherDayTimes.forEach {
                let sut = storage

                _ = sut.saveCheckIn(firstDayTime, for: todaysDate)
                _ = sut.saveCheckIn($0, for: todaysDate)

                let checkIns = sut.getCheckIns(for: todaysDate)
                XCTAssert(checkIns.contains(firstDayTime) && checkIns.contains($0))
            }
        }
    }

    func test_when_saving_the_same_dayTime_twice_then_it_should_not_be_duplicated() throws {
        let todaysDate = Date()
        let allDayTimes = DayTime.allCases

        try allDayTimes.forEach {
            let sut = storage

            _ = sut.saveCheckIn($0, for: todaysDate)
            _ = sut.saveCheckIn($0, for: todaysDate)

            let checkIns = sut.getCheckIns(for: todaysDate)
            XCTAssertEqual(try checkIns.get().count, 1)
        }
    }

    #warning("TODO: Test for deletion of past days checkins 🙏")
}

// MARK: - System Under Test

private extension LocalStorageTests {
    var storage: LocalStorageType {
        LocalStorage(devNull: true)
    }
}

// MARK: - Convenience

private extension Result where Success == [DayTime] {
    func contains(_ dayTime: DayTime) -> Bool {
        switch self {
        case .success(let dayTimes):
            return dayTimes.contains(dayTime)
        case .failure:
            return false
        }
    }
}
