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

    // MARK: save

    func test_when_save_is_called_with_a_dayTime_and_todays_date_then_it_should_be_saved_to_local_storage() {
        let todaysDate = Date()
        let allDayTimes = DayTime.allCases

        for dayTime in allDayTimes {
            let storage = FakeLocalStorage()
            let sut = getCheckInProvider(storage: storage)

            let saveResult = sut.save(dayTime, for: todaysDate)

            let saveSuccessful: Result<Bool, Never> = saveResult
                .map { _ in storage.contains(dayTime, for: todaysDate) }
                .flatMapError { _ in .success(false) }

            XCTAssert(try saveSuccessful.get())
        }
    }

    func test_when_save_is_called_and_error_occurs_on_local_storage_then_storage_error_should_be_signaled() {
        let sut = getCheckInProvider(
            storage: FakeLocalStorage(
                hasSaveError: true
            )
        )

        let saveResult = sut.save(.night, for: Date())

        let errorOnSave: Result<Bool, Never> = saveResult
            .map { _ in false }
            .flatMapError { .success($0.isStorageError) }

        XCTAssert(try errorOnSave.get())
    }

    // MARK: - wasChecked

    func test_when_wasChecked_is_called_with_existing_record_then_should_return_true() {
        let date = Date()
        let allDayTimes = DayTime.allCases

        for dayTime in allDayTimes {
            let storage = FakeLocalStorage()
            _ = storage.saveCheckIn(dayTime, for: date)

            let sut = getCheckInProvider(storage: storage)
            let result = sut.wasChecked(on: date, in: dayTime)

            let resultedTrue: Result<Bool, Never> = result
                .flatMapError { _ in .success(false) }

            XCTAssert(try resultedTrue.get())
        }
    }

    func test_when_wasChecked_is_called_with_non_existing_record_then_should_return_false() {
        let date = Date()
        let allDayTimes = DayTime.allCases

        for dayTimeNotSaved in allDayTimes {
            let storage = FakeLocalStorage()
            let otherDayTimes = DayTime.allCases.filter {
                $0 != dayTimeNotSaved
            }

            for dayTimeSaved in otherDayTimes {
                _ = storage.saveCheckIn(dayTimeSaved, for: date)
            }

            let sut = getCheckInProvider(storage: storage)
            let result = sut.wasChecked(on: date, in: dayTimeNotSaved)

            let resultedFalse: Result<Bool, Never> = result
                .map { !$0 }
                .flatMapError { _ in .success(false) }

            XCTAssert(try resultedFalse.get())
        }
    }

    func test_when_wasChecked_is_called_and_error_occurs_on_local_storage_then_storage_error_should_be_signaled() {
        let sut = getCheckInProvider(
            storage: FakeLocalStorage(
                hasFetchError: true
            )
        )

        let wasCheckedResult = sut.wasChecked(on: Date(), in: .night)

        let errorOnLoad: Result<Bool, Never> = wasCheckedResult
            .map { _ in false }
            .flatMapError { .success($0.isStorageError) }

        XCTAssert(try errorOnLoad.get())
    }

}

// MARK: - System Under Test

private extension CheckInProviderTests {
    func getCheckInProvider<Storage: LocalStorageType>(
        storage: Storage
    ) -> CheckInProviderType {
        CheckInProvider(
            storage: storage
        )
    }
}

// MARK: - Convenience

private extension ServiceError {
    var isStorageError: Bool {
        switch self {
        case .storage:
            return true
        }
    }
}
