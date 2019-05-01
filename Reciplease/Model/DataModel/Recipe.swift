//
//  Recipe.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-25.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import CoreData

class Recipe: NSManagedObject {
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Recipe] {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        guard let recipe = try? viewContext.fetch(request) else { return [] }
        return recipe
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        Recipe.fetchAll(viewContext: viewContext).forEach({ viewContext.delete($0) })
        try? viewContext.save()
    }
    
    //MARK: Method to save Persitent Data of Recipe
    static func saveData(recipeResponse: CompleteRecipe?, ingredients: String){
        
        let newCategory = Category(context: AppDelegate.viewContext)
        if let categoryName = recipeResponse?.attributes?.course?[0] {
            newCategory.categoryName = categoryName
        } else {
            newCategory.categoryName = "All purpose"
        }
        
        
        let newRecipe = Recipe(context: AppDelegate.viewContext)
        
        newRecipe.cookTime = recipeResponse?.totalTime
        newRecipe.id = recipeResponse?.id
        newRecipe.name = recipeResponse?.name
        guard let rate = recipeResponse?.rating else {return}
        newRecipe.rate = String(rate)
        newRecipe.recipe_url = recipeResponse?.source?.sourceRecipeURL
        //add ingredient for cellLabel in favorite table View
        newRecipe.ingredientCellLabel = ingredients
        //add all complete recipe ingredients inone string sparate with ,
        guard let ingredientsDetail = recipeResponse?.ingredientLines else {return}
        var ingredientList = ""
        for i in 0 ..< ingredientsDetail.count {
            ingredientList += ingredientsDetail[i]
            if i != ingredientsDetail.count - 1 {
                ingredientList += ","
            }
        }
        newRecipe.ingredientsCompletRecipe = ingredientList
        
        // We save Image in Binary Data
        guard let imageURL = recipeResponse?.images?[0].hostedLargeURL else {return}
        print(imageURL)
        guard let url = URL(string: imageURL) else {return} //a deballer
        print(url)
        let data = try? Data(contentsOf: url)//make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        print(data!)
    
        newRecipe.image = data
        
        // we link recipe to a category
        newRecipe.parentCategory = newCategory

        
        ///// method NSCoder \\\\\
        //we save context on CoreDatabase (persistant container)
        do {
            try AppDelegate.viewContext.save()
        }catch{
            print("Error saving context \(error)")
        }
    }
    
    
    //MARK: Method to delete value at index
     static func deleteFavoriteRecipe(name: String){
        
        var recipe = Recipe.fetchAll()
        var index = 0
        print(recipe.count)
        for i in 0 ..< recipe.count{
            print(i)
            
            if recipe[i].name == name{
                index = i
            }
        }
        AppDelegate.viewContext.delete(recipe[index])
        ///// method NSCoder \\\\\
        //we save context on CoreDatabase (persistant container)
        do {
            try AppDelegate.viewContext.save()
        }catch{
            print("Error saving context \(error)")
        }
    }
    
    //Methods to change button image if favorite or not
    static func isAFavorite(id: String) ->String{
        
        for i in 0 ..< Recipe.fetchAll().count {
            guard let idData = Recipe.fetchAll()[i].id else {return "favorite-heart-outline-button"}
            if id == idData {
                return "favorite-Full-heart-button"
            }
        }
        return "favorite-heart-outline-button"
    }
    
    
    
}
