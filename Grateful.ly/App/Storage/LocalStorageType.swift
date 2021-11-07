//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2021 Adam Londa. All rights reserved.
//

import Combine
import Foundation

protocol LocalStorageType {
    var storageFull: AnyPublisher<Bool, Never> { get }

    func getCheckIns(for date: Date) -> Result<[DayTime], StorageError>
    func saveCheckIn(_ dayTime: DayTime, for date: Date) -> Result<Void, StorageError>
}
