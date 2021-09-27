//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2021 Adam Londa. All rights reserved.
//

import Foundation
@testable import Gratefully

final class FakeLocalStorage: LocalStorageType {

    let storageFull = false

    private var checkIns = [Date: [DayTime]]()

    func getCheckIns(for date: Date) -> Result<[DayTime], StorageError> {
        guard let checkIn = checkIns[date] else {
            return .failure(.fetchError(message: ""))
        }
        return .success(checkIn)
    }

    func saveCheckIn(_ dayTime: DayTime, for date: Date) -> Result<Void, StorageError> {
        checkIns[date] = [dayTime]
        return .success(())
    }

}
