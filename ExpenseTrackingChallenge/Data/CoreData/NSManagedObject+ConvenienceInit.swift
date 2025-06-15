//
//  NSManagedObject+ConvenienceInit.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 15/06/2025.
//

import CoreData

extension NSManagedObject {
    // Override default init to ensure entities are inserted into the correct context:
    // This helps with the multiple warnings showing when running persistence tests
    // https://stackoverflow.com/questions/51851485/multiple-nsentitydescriptions-claim-nsmanagedobject-subclass/
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        guard let entity = NSEntityDescription.entity(
            forEntityName: name,
            in: context
        ) else {
            fatalError("Failed to find entity for \(name)")
        }
        self.init(entity: entity, insertInto: context)
    }
}
