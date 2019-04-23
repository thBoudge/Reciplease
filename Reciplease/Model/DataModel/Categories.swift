//
//  Categories.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-23.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import CoreData

class Categories: NSManagedObject {
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Categories] {
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "categoryName", ascending: true)]
        guard let categories = try? viewContext.fetch(request) else { return [] }
        return categories
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        Categories.fetchAll(viewContext: viewContext).forEach({ viewContext.delete($0) })
        try? viewContext.save()
    }
}
