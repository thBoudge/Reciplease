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
    // refactorisé par func
    static func saveData(recipeResponse: CompleteRecipe? , ingredients: String, context : NSManagedObjectContext = AppDelegate.viewContext){
        
       let newRecipe = Recipe(context: context)
        
        newRecipe.cookTime = recipeResponse?.totalTime
        newRecipe.id = recipeResponse?.id
        newRecipe.name = recipeResponse?.name
        guard let rate = recipeResponse?.rating else {return}
        newRecipe.rate = String(rate)
        newRecipe.recipe_url = recipeResponse?.source?.sourceRecipeURL
        //add ingredient for cellLabel in favorite table View
        newRecipe.ingredientCellLabel = ingredients
        //add all complete recipe ingredients in one string separate with ,
        guard let ingredientsDetail = recipeResponse?.ingredientLines else {return}
        newRecipe.ingredientsCompletRecipe = ingredientsString(ingredientsDetail: ingredientsDetail)
        
        // We save ImageUrl in Binary Data
        guard let imageURL = recipeResponse?.images?[0].hostedLargeURL else {return}
        newRecipe.image = changeImageUrlInData(urlString: imageURL)
        
        let categoryName : String = recipeResponse?.attributes?.course?[0] ?? "All purpose"
        // CategoryExist check if data exist or not and add it or not and return Object
        newRecipe.parentCategory = Category.categoryExist(name: categoryName, context: context)
        try? context.save()

    }
    
//    static func saveData(recipeResponse: Recipe?, categoryName : String , ingredients: String, context : NSManagedObjectContext = AppDelegate.viewContext){
//        
////        var newRecipe = Recipe(context: context)
////        newRecipe = recipeResponse!
////
////
//        // CategoryExist check if data exist or not and add it or not and return Object
//        recipeResponse?.parentCategory = Category.categoryExist(name: categoryName, context: context)
//        try? context.save()
//        
//    }
    
    
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
    static func isAFavorite(id: String , context : NSManagedObjectContext = AppDelegate.viewContext) ->Bool{
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        //we filter data with id
        request.predicate = NSPredicate(format: "id = %@", id)
        guard let recipeEntites = try? context.fetch(request) else {return false}
        if recipeEntites.isEmpty{
            return false
        }
        
        return true
    }
    
    //Method to change [String] in String
    private static func ingredientsString(ingredientsDetail : [String])->String{
        var ingredientList = ""
        for i in 0 ..< ingredientsDetail.count {
            ingredientList += ingredientsDetail[i]
            if i != ingredientsDetail.count - 1 {
                ingredientList += ","
            }
        }
        return ingredientList
    }

    //Method to change [String] in String
    private static func changeImageUrlInData(urlString: String)->Data?{
        guard let url = URL(string: urlString) else {return nil}
        let data = try? Data(contentsOf: url) as Data?
        return data
    }
}
