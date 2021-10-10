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

        let checkedFlags: [Bool] = allDayTimes.map {
            let sut = storage
            _ = sut.saveCheckIn($0, for: todaysDate)

            return sut.getCheckIns(for: todaysDate)
                .contains($0)
        }

        XCTAssert(checkedFlags.allSatisfy { $0 })
    }

    func test_when_saving_second_dayTime_with_todays_date_then_the_second_dayTime_should_be_appended() {
        let todaysDate = Date()
        let allDayTimes = DayTime.allCases

        let checkedFlagsMatrix: [Bool] = allDayTimes.map { firstDayTime in
            let otherDayTimes = DayTime.allCases.filter {
                $0 != firstDayTime
            }

            let checkFlags: [Bool] = otherDayTimes.map {
                let sut = storage

                _ = sut.saveCheckIn(firstDayTime, for: todaysDate)
                _ = sut.saveCheckIn($0, for: todaysDate)

                let checkIns = sut.getCheckIns(for: todaysDate)

                return checkIns.contains(firstDayTime)
                    && checkIns.contains($0)
            }

            return checkFlags.allSatisfy { $0 }
        }

        XCTAssert(checkedFlagsMatrix.allSatisfy { $0 })
    }

    #warning("TODO: Test for non-duplication of records 💡")
    #warning("TODO: Test for deletion of past days checkins 🙏")
}

private extension LocalStorageTests {
    var storage: LocalStorage {
        LocalStorage(devNull: true)
    }
}
