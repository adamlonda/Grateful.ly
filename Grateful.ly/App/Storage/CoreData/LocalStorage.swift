//
//	This code is created under the GNU GPL v3 license.
//	If you haven't received license copy with this code, see:
//	https://www.gnu.org/licenses/gpl-3.0.en.html
//
//	Copyright © 2021 Adam Londa. All rights reserved.
//

import Combine
import CoreData
import Foundation

// MARK: - Init & Dependencies

final class LocalStorage {

    private let container: NSPersistentContainer

    private let storageFullSubject = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(devNull: Bool = false) {
        container = NSPersistentContainer(name: "Gratefully")

        if devNull {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores()
            .map { _ in false }
            .catch { _ in Just(true) }
            .sink { [weak self] isStorageFull in
                self?.storageFullSubject.send(isStorageFull)
            }
            .store(in: &cancellables)
    }

}

// MARK: - Protocol Conformance

extension LocalStorage: LocalStorageType {

    var storageFull: AnyPublisher<Bool, Never> {
        storageFullSubject.eraseToAnyPublisher()
    }

    func getCheckIns(for date: Date) -> Result<[DayTime], StorageError> {
        Result {
            try container.getCheckIns(for: date)
                .compactMap { $0.dayTime }
        }
        .mapError {
            StorageError.fetch(error: $0)
        }
    }

    func saveCheckIn(_ dayTime: DayTime, for date: Date) -> Result<Void, StorageError> {
        Result {
            let existingCheckins = try container.getCheckIns(for: date)
            let alreadyExists = existingCheckins.contains {
                $0.dayTime == dayTime
            }

            if alreadyExists == false {
                try container.saveCheckIn(dayTime, for: date)
            }
        }
        .mapError {
            StorageError.save(error: $0)
        }
    }

}

// MARK: - CoreData Handling

private extension NSPersistentContainer {
    func loadPersistentStores() -> AnyPublisher<NSPersistentStoreDescription, NSError> {
        Future<NSPersistentStoreDescription, NSError> { [weak self] promise in
            self?.loadPersistentStores { storeDescription, error in
                if let error = error as NSError? {
                    promise(.failure(error))
                    return
                }
                promise(.success(storeDescription))
            }
        }.eraseToAnyPublisher()
    }

    func saveCheckIn(_ dayTime: DayTime, for date: Date) throws {
        let newEntity = CheckInStorageEntity(context: self.viewContext)
        let calendar = Calendar.current

        newEntity.day = date.getDay(by: calendar)
        newEntity.month = date.getMonth(by: calendar)
        newEntity.year = date.getYear(by: calendar)

        newEntity.dayTimeCode = dayTime.code

        try self.viewContext.save()
    }

    func getCheckIns(for date: Date) throws -> [CheckInStorageEntity] {
        let calendar = Calendar.current

        let day = date.getDay(by: calendar)
        let dayPredicate = NSPredicate(format: "day = %@", NSNumber(value: day))

        let month = date.getMonth(by: calendar)
        let monthPredicate = NSPredicate(format: "month = %@", NSNumber(value: month))

        let year = date.getYear(by: calendar)
        let yearPredicate = NSPredicate(format: "year = %@", NSNumber(value: year))

        let fetchRequest = CheckInStorageEntity.fetchRequest()

        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                dayPredicate,
                monthPredicate,
                yearPredicate
            ]
        )

        return try self.viewContext.fetch(fetchRequest)
    }
}

// MARK: - Data Mapping

private extension CheckInStorageEntity {
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

private extension DayTime {
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

private extension Date {
    func getDay(by calendar: Calendar) -> Int16 {
        Int16(calendar.component(.day, from: self))
    }

    func getMonth(by calendar: Calendar) -> Int16 {
        Int16(calendar.component(.month, from: self))
    }

    func getYear(by calendar: Calendar) -> Int64 {
        Int64(calendar.component(.year, from: self))
    }
}
