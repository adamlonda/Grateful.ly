//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2021 Adam Londa. All rights reserved.
//

import Foundation

#warning("TODO: Reflect storageFull at this level too 🙏")
protocol CheckInProviderType {
    func save(_ dayTime: DayTime, for date: Date)
    func wasChecked(on date: Date, in dayTime: DayTime) -> Bool
}

struct CheckInProvider<Storage>: CheckInProviderType where Storage: LocalStorageType {
    private let storage: Storage

    init(storage: Storage) {
        self.storage = storage
    }

    func save(_ dayTime: DayTime, for date: Date) {
        #warning("TODO: Handle error states appropriately 🙏")
        _ = storage.saveCheckIn(dayTime, for: date)
    }

    func wasChecked(on date: Date, in dayTime: DayTime) -> Bool {
        #warning("TODO: Handle error states appropriately 🙏")
        let result = storage.getCheckIns(for: date)
        switch result {
        case .success(let dayTimes):
            return dayTimes.contains { $0 == dayTime }
        case .failure:
            return false
        }
    }
}
