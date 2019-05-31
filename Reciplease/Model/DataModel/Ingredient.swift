//
//  Ingredient.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-15.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import CoreData

class Ingredient: NSManagedObject {
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Ingredient] {
        let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "ingredientName", ascending: true)]
        guard let ingredients = try? viewContext.fetch(request) else { return [] }
        return ingredients
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        Ingredient.fetchAll(viewContext: viewContext).forEach({ viewContext.delete($0) })
        try? viewContext.save()
    }
    
    static func addIngredient(ingredientName: String, context : NSManagedObjectContext = AppDelegate.viewContext){
        
        let ingredient = ingredientName.replacingOccurrences(of: " ", with: "")
        if ingredient != "" {
            if ingredient.contains(",") == true{
                let array = ingredient.components(separatedBy: ",")
                for i in array {
                    let newIngredient = Ingredient(context: context)
                    newIngredient.ingredientName = i
                    newIngredient.checked = false
                }
            }else {
                let newIngredient = Ingredient(context: context )
                newIngredient.ingredientName = ingredient
                newIngredient.checked = false
            }
            try? context.save()
        }
    }
    
    
    static func deleteRow(checked: Bool, viewContext: NSManagedObjectContext = AppDelegate.viewContext ) {
        let ingredientArray = fetchAll(viewContext: viewContext)
        //////Delete Row\\\\\\
        if checked == true {
            for i in ingredientArray {
                if i.checked == true {
                    //removing our data from our context store
                   viewContext.delete(i)
                }
            }
        } else { //We delete all
            deleteAll(viewContext: viewContext)
        }
        try? viewContext.save()
        
    }
}


