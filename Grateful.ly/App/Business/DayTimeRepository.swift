//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2021 Adam Londa. All rights reserved.
//

import Foundation

protocol DayTimeRepositoryType {
    func save(_ dayTime: DayTime, for date: Date)
    func wasChecked(on date: Date, in dayTime: DayTime) -> Bool
}

struct DayTimeRepository: DayTimeRepositoryType {
    func save(_ dayTime: DayTime, for date: Date) {
        #warning("Inject storage for actual save 🙏")
    }

    func wasChecked(on date: Date, in dayTime: DayTime) -> Bool {
        dayTime == .morning || dayTime == .afternoon || dayTime == .evening || dayTime == .night
    }
}
