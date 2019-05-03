//
//  Category.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-23.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Category] {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "categoryName", ascending: true)]
        guard let categories = try? viewContext.fetch(request) else { return [] }
        return categories
    }
    
    
    static func deleteCategoryWithNoRecipe( context : NSManagedObjectContext = AppDelegate.viewContext ){
        
        for i in Category.fetchAll(viewContext: context){
            
            if i.recipes?.anyObject() == nil {
                context.delete(i)
            }
        }
    }
}
