//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2022 Adam Londa. All rights reserved.
//

import Foundation

extension Date {
    var dayBefore: Date? {
        Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
}
