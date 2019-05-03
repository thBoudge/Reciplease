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

    //MARK: Method to save Persitent Data of Recipe
    static func saveData(recipeResponse: CompleteRecipe?, ingredients: String, context : NSManagedObjectContext = AppDelegate.viewContext){
        
       let newRecipe = Recipe(context: context)
        
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
        guard let url = URL(string: imageURL) else {return} //a deballer
        let data = try? Data(contentsOf: url) as Data?//make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
    
        newRecipe.image = data
        
        // Category add or not
        let newCategory = Category(context: context)
        var dataDoesNotExist = true
        let categoryName : String = recipeResponse?.attributes?.course?[0] ?? "All purpose"
        print(categoryName)
        
        
        for i in Category.fetchAll(viewContext: context) {
            if i.categoryName == categoryName {
                dataDoesNotExist = false
            }
        }
        if dataDoesNotExist == true {
            newCategory.categoryName = categoryName
            // we link recipe to a category
            newRecipe.parentCategory = newCategory
        }else {
            // we link recipe to a category
            newRecipe.parentCategory?.categoryName = categoryName
        }
      
        ///// method NSCoder \\\\\
        //we save context on CoreDatabase (persistant container)
        do {
            try context.save()
//                AppDelegate.viewContext.save()
        }catch{
            print("Error saving context \(error)")
        }
    }
    
    
    //MARK: Method to delete value at index
    static func deleteFavoriteRecipe(name: String,context : NSManagedObjectContext = AppDelegate.viewContext, recipe : [Recipe] = Recipe.fetchAll()){
        var index = 0
        for i in 0 ..< recipe.count{
            if recipe[i].name == name{
                index = i
            }
        }
        context.delete(recipe[index])
        Category.deleteCategoryWithNoRecipe(context: context)
        try? context.save()
    }
    
    //Methods to change button image if favorite or not
    static func isAFavorite(id: String , recipe : [Recipe] = Recipe.fetchAll()) ->String{
        
        for i in 0 ..< recipe.count {
            guard let idData = Recipe.fetchAll()[i].id else {return "favorite-heart-outline-button"}
            if id == idData {
                return "favorite-Full-heart-button"
            }
        }
        return "favorite-heart-outline-button"
    }
    
    
    
}
