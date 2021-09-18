//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2021 Adam Londa. All rights reserved.
//

import Foundation

protocol CheckInProviderType {
    func save(_ dayTime: DayTime, for date: Date)
    func wasChecked(on date: Date, in dayTime: DayTime) -> Bool
}

struct CheckInProvider: CheckInProviderType {
    private let storage: LocalStorageType

    init(storage: LocalStorageType) {
        self.storage = storage
    }

    func save(_ dayTime: DayTime, for date: Date) {
        storage.saveCheckIn(dayTime, for: date)
    }

    func wasChecked(on date: Date, in dayTime: DayTime) -> Bool {
        storage.getCheckIns(for: date)!
            .contains { $0 == dayTime }
    }
}
