//
//  CoreDataController.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 13/06/2025.
//

import CoreData

protocol PersistenceController {
    var viewContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }
}

final class CoreDataController: PersistenceController {
    static let shared = CoreDataController()

    let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    var backgroundContext: NSManagedObjectContext {
        container.newBackgroundContext()
    }

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "receipt")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data load error: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
