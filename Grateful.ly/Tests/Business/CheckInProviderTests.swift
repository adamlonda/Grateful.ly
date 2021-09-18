//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2021 Adam Londa. All rights reserved.
//

@testable import Gratefully
import XCTest

class CheckInProviderTests: XCTestCase {
    func test_when_saving_a_dayTime_with_todays_date_then_should_save_the_dayTime_with_todays_date() {
        let sut = checkInProvider
        let todaysDate = Date()
        let allDayTimes = DayTime.allCases

        let checkedFlags: [Bool] = allDayTimes.map {
            sut.save($0, for: todaysDate)
            return sut.wasChecked(on: todaysDate, in: $0)
        }

        XCTAssert(checkedFlags.allSatisfy { $0 })
    }
}

private extension CheckInProviderTests {
    var checkInProvider: CheckInProviderType {
        CheckInProvider()
    }
}
