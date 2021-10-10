//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2021 Adam Londa. All rights reserved.
//

import Foundation
@testable import Gratefully

private enum FakeStorageError: Error {
    case missingEntry
    case generalError
}

final class FakeLocalStorage: LocalStorageType {

    let storageFull = false

    private let hasFetchError: Bool
    private let hasSaveError: Bool

    private var checkIns = [Date: [DayTime]]()

    // MARK: - Init

    init(hasFetchError: Bool = false, hasSaveError: Bool = false) {
        self.hasFetchError = hasFetchError
        self.hasSaveError = hasSaveError
    }

    // MARK: - Protocol Conformance

    func getCheckIns(for date: Date) -> Result<[DayTime], StorageError> {
        if hasFetchError {
            return .failure(.fetch(error: FakeStorageError.generalError))
        }

        guard let checkIn = checkIns[date] else {
            return .failure(.fetch(error: FakeStorageError.missingEntry))
        }

        return .success(checkIn)
    }

    func saveCheckIn(_ dayTime: DayTime, for date: Date) -> Result<Void, StorageError> {
        if hasSaveError {
            return .failure(.fetch(error: FakeStorageError.generalError))
        }

        checkIns[date] = [dayTime]
        return .success(())
    }

}

// MARK: - Convenience Method

extension FakeLocalStorage {
    func contains(_ dayTime: DayTime, for date: Date) -> Bool {
        guard let found = checkIns[date] else {
            return false
        }

        return found.contains(dayTime)
    }
}
