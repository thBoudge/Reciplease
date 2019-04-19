//
//  Ingredient.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-15.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import CoreData

class Ingredients: NSManagedObject {
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Ingredients] {
        let request: NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "ingredientName", ascending: true)]
        guard let ingredients = try? viewContext.fetch(request) else { return [] }
        return ingredients
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        Ingredients.fetchAll(viewContext: viewContext).forEach({ viewContext.delete($0) })
        try? viewContext.save()
    }
}


