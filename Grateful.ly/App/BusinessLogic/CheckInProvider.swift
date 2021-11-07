//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2021 Adam Londa. All rights reserved.
//

import Combine
import Foundation

// MARK: - Protocol

protocol CheckInProviderType {

    var storageFull: AnyPublisher<Bool, Never> { get }

    func save(_ dayTime: DayTime, for date: Date) -> Result<Void, ServiceError>
    func wasChecked(on date: Date, in dayTime: DayTime) -> Result<Bool, ServiceError>

}

// MARK: - Init & Dependencies

final class CheckInProvider {
    private let storage: LocalStorageType

    init(storage: LocalStorageType) {
        self.storage = storage
    }
}

// MARK: - Protocol Conformance

extension CheckInProvider: CheckInProviderType {

    var storageFull: AnyPublisher<Bool, Never> {
        storage.storageFull
    }

    func save(_ dayTime: DayTime, for date: Date) -> Result<Void, ServiceError> {
        storage.saveCheckIn(dayTime, for: date)
            .mapError { ServiceError.storage(error: $0) }
    }

    func wasChecked(on date: Date, in dayTime: DayTime) -> Result<Bool, ServiceError> {
        storage.getCheckIns(for: date)
            .map { $0.contains { $0 == dayTime } }
            .mapError { ServiceError.storage(error: $0) }
    }

}
