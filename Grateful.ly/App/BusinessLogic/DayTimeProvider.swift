//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2022 Adam Londa. All rights reserved.
//

protocol DayTimeProviderType {
    var dayTimeNow: DayTime { get }
}

struct DayTimeProvider {
    private let timeChecker: TimeCheckerType

    init(timeChecker: TimeCheckerType) {
        self.timeChecker = timeChecker
    }
}

#warning("TODO: Implement DayTimeProvider ‼️")
extension DayTimeProvider: DayTimeProviderType {
    var dayTimeNow: DayTime {
        fatalError("Implement me 🙏")
    }
}
