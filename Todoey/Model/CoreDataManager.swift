//
//  CoreDataManager.swift
//  Todoey
//
//  Created by Merouane Bellaha on 14/06/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import CoreData

final class CoreDataManager {
    private let context: NSManagedObjectContext?

    init(with context: NSManagedObjectContext) {
        self.context = context
    }

    func saveTasks() {
           do {
            try context?.save()
           } catch {
               print(error.localizedDescription)
           }
       }

    func loadItems<T: NSManagedObject>(with predicate: NSPredicate? = nil, sortBy descriptor: [NSSortDescriptor]? = nil) -> [T] {
        let request = T.fetchRequest() as! NSFetchRequest<T>
        request.predicate = predicate
        request.sortDescriptors = descriptor
        
        var items: [T] = []
        do {
            items = try context?.fetch(request) ?? []
        } catch {
            print(error.localizedDescription)
        }
        return items
    }
}
