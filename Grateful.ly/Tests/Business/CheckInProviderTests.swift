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
    func test_when_saving_a_dayTime_with_todays_date_then_it_should_be_saved_to_local_storage() {
        let todaysDate = Date()
        let allDayTimes = DayTime.allCases

        let checkedFlags: [Bool] = allDayTimes.map {
            let storage = FakeLocalStorage()
            let sut = getCheckInProvider(storage: storage)

            sut.save($0, for: todaysDate)

            return storage.getCheckIns(for: todaysDate)?.contains($0) ?? false
        }

        XCTAssert(checkedFlags.allSatisfy { $0 })
    }

    #warning("TODO: Test more cases 🙏")
}

private extension CheckInProviderTests {
    func getCheckInProvider(storage: LocalStorageType) -> CheckInProviderType {
        CheckInProvider(
            storage: storage
        )
    }
}
