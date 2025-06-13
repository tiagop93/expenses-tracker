//
//  MockCoreDataController.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 13/06/2025.
//

import CoreData

final class MockCoreDataController: PersistenceController {
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "receipt")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { _, _ in }
    }

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    var backgroundContext: NSManagedObjectContext {
        container.newBackgroundContext()
    }
}
