//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2021 Adam Londa. All rights reserved.
//

import Foundation

extension CheckInStorageEntity {
    var dayTime: DayTime? {
        switch self.dayTimeCode {
        case 0:
            return .morning
        case 1:
            return .afternoon
        case 2:
            return .evening
        case 3:
            return .night
        default:
            return nil
        }
    }
}

extension DayTime {
    var code: Int16 {
        switch self {
        case .morning:
            return 0
        case .afternoon:
            return 1
        case .evening:
            return 2
        case .night:
            return 3
        }
    }
}
