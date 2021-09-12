//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2021 Adam Londa. All rights reserved.
//

@testable import Gratefully
import XCTest

class DayTimeRepositoryTests: XCTestCase {
    func test_when_saving_morning_with_todays_date_then_should_save_morning_with_todays_date() {
        let sut = repository
        let todaysDate = Date()

        sut.save(.morning, for: todaysDate)

        let wasThisMorningSaved = sut.wasChecked(on: todaysDate, in: .morning)
        XCTAssert(wasThisMorningSaved)
    }

    func test_when_saving_evening_with_todays_date_then_should_save_evening_with_todays_date() {
        let sut = repository
        let todaysDate = Date()

        sut.save(.evening, for: todaysDate)

        let wasThisMorningSaved = sut.wasChecked(on: todaysDate, in: .evening)
        XCTAssert(wasThisMorningSaved)
    }
}

private extension DayTimeRepositoryTests {
    var repository: DayTimeRepositoryType {
        DayTimeRepository()
    }
}
