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

    func deleteCheckIns(otherThan date: Date) -> Result<Void, StorageError> {
        Result {
            let checkinsToDelete = try container.getCheckIns(exceptOf: date)
            checkinsToDelete.forEach(
                container.viewContext.delete
            )
            try container.viewContext.save()
        }
        .mapError {
            StorageError.delete(error: $0)
        }
    }

}

// MARK: - Container: Load Stores

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
}

// MARK: - Date Helper Methods

private extension NSPersistentContainer {
    func getDay(from date: Date, by calendar: Calendar = .current) -> Int16 {
        Int16(calendar.component(.day, from: date))
    }

    func getMonth(from date: Date, by calendar: Calendar = .current) -> Int16 {
        Int16(calendar.component(.month, from: date))
    }

    func getYear(from date: Date, by calendar: Calendar = .current) -> Int64 {
        Int64(calendar.component(.year, from: date))
    }
}

// MARK: - Container: Save Checkin

private extension NSPersistentContainer {
    func saveCheckIn(_ dayTime: DayTime, for date: Date) throws {
        let newEntity = CheckInStorageEntity(context: self.viewContext)

        newEntity.day = getDay(from: date)
        newEntity.month = getMonth(from: date)
        newEntity.year = getYear(from: date)

        newEntity.dayTimeCode = dayTime.code

        try self.viewContext.save()
    }
}

// MARK: - Container: Get Checkins

private extension NSPersistentContainer {
    func dayPredicate(format: String, from date: Date) -> NSPredicate {
        NSPredicate(format: format, NSNumber(value: getDay(from: date)))
    }

    func monthPredicate(format: String, from date: Date) -> NSPredicate {
        NSPredicate(format: format, NSNumber(value: getMonth(from: date)))
    }

    func yearPredicate(format: String, from date: Date) -> NSPredicate {
        NSPredicate(format: format, NSNumber(value: getYear(from: date)))
    }

    func getCheckIns(for date: Date) throws -> [CheckInStorageEntity] {
        try getCheckIns(
            with: NSCompoundPredicate(
                andPredicateWithSubpredicates: [
                    dayPredicate(format: "day = %@", from: date),
                    monthPredicate(format: "month = %@", from: date),
                    yearPredicate(format: "year = %@", from: date)
                ]
            )
        )
    }

    func getCheckIns(exceptOf date: Date) throws -> [CheckInStorageEntity] {
        try getCheckIns(
            with: NSCompoundPredicate(
                orPredicateWithSubpredicates: [
                    dayPredicate(format: "NOT (day = %@)", from: date),
                    monthPredicate(format: "NOT (month = %@)", from: date),
                    yearPredicate(format: "NOT (year = %@)", from: date)
                ]
            )
        )
    }

    func getCheckIns(with compoundPredicate: NSCompoundPredicate) throws -> [CheckInStorageEntity] {
        let fetchRequest = CheckInStorageEntity.fetchRequest()
        fetchRequest.predicate = compoundPredicate

        return try self.viewContext.fetch(fetchRequest)
    }
}
