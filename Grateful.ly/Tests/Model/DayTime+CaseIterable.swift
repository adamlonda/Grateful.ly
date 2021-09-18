//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2021 Adam Londa. All rights reserved.
//

@testable import Gratefully

extension DayTime: CaseIterable {
    public static var allCases: [DayTime] {
        [ .morning, .afternoon, .evening, .night ]
    }
}
