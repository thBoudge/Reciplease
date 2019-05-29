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
    
    static func categoryExist(name: String, context: NSManagedObjectContext) ->Category {
        let newCategory = Category(context: context)
        for i in Category.fetchAll(viewContext: context) {
            if i.categoryName == name {
                return i
            }
        }
        newCategory.categoryName = name
        return newCategory
    }
    
    static func researchResultIs (searchText : String, context : NSManagedObjectContext = AppDelegate.viewContext) -> [Category] {
        
        var categoryArray = [Category(context: context)]
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        //nsPredicate
        //title CONTAINS %@ is a query langage from objective C
        let predicate = NSPredicate(format: "categoryName CONTAINS[cd] %@", searchText)
        request.predicate = predicate
        // we want to sort response
        request.sortDescriptors = [NSSortDescriptor(key: "categoryName", ascending: true)]
        
        do {
            categoryArray = try context.fetch(request)
        } catch  {
            print("Error fetching data from context \(error)")
        }
        
        return categoryArray
    }
    
    
}
