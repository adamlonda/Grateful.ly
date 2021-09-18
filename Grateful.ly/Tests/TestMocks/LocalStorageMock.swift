//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2021 Adam Londa. All rights reserved.
//

import Foundation
@testable import Gratefully

final class LocalStorageMock: LocalStorageType {
    private var checkIns = [Date: [DayTime]]()

    func getCheckIns(for date: Date) -> [DayTime]? {
        checkIns[date]
    }

    func saveCheckIn(_ dayTime: DayTime, for date: Date) {
        checkIns[date] = [dayTime]
    }
}
