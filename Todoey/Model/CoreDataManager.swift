//
//  CoreDataManager.swift
//  Todoey
//
//  Created by Merouane Bellaha on 14/06/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import CoreData

class CoreDataManager {
    let context: NSManagedObjectContext?

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

    func loadItems<T: NSManagedObject>() -> [T] {
        let request: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        do {
            return try (context?.fetch(request) ?? [])
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
}
