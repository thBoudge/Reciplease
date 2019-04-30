//
//  YummlyService.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-18.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import Alamofire

class YummlyService {
    
    //MARK: Properties
    private let APP_ID = valueForAPIKey(named:"YummlyAPIKey")
    private let ID = valueForAPIKey(named:"YummlyID")
    private var urlComponent : String = ""
    private var yummlySession: YummlySession
    
    init(yummlySession: YummlySession = YummlySession()) {
        self.yummlySession = yummlySession
        
    }
    
    //MARK:  Methods
    // Method to build Bundle to build URL for getting all recipes
    func updateData(table ingredients: [Ingredient]){
        urlComponent = "\(YummlySession.init().urlStringApi)s?_app_id=\(ID)&_app_key=\(APP_ID)"
        
        for i in 0..<ingredients.count{
            guard let ingredient = ingredients[i].ingredientName else {return}
            urlComponent += "&allowedIngredient[]=\(ingredient.lowercased() )"
        }
        
        print(urlComponent)
    }
    
    // Method to build Bundle to build URL for getting all recipes
    func updateRecipeData(idRecipe: String){
        urlComponent = "\(YummlySession.init().urlStringApi)/\(idRecipe)?_app_id=\(ID)&_app_key=\(APP_ID)"
        
        print(urlComponent)
    }
   
    
    //Method to call and receive response
    func getRecipes(callback: @escaping (Bool, Recipes?) -> Void){
        
        let url = URL(string: urlComponent)!
        print(url)
        yummlySession.request(url: url) { responseData in
            
                //Check if data != nil
                guard let data = responseData.data else {
                    print("no data")
                    callback(false, nil)
                    return
                }
                // control that response status is 200
                guard responseData.response?.statusCode == 200 else {
                    print("Starus different than 200")
                    callback(false, nil)
                    return
                }
                // MARK: - 5 Translation JSON in String
                guard let responseJSON = try? JSONDecoder().decode(Recipes.self, from: data) else {
                    print("pblm resposeJson")
                    callback(false, nil)
                    return
                }
            print(responseJSON)
            callback(true,responseJSON)
            }
            
        }

    //Method to call and receive response
    func getRecipe(callback: @escaping (Bool, CompleteRecipe?) -> Void){
        
        let url = URL(string: urlComponent)!
        print(url)
        yummlySession.request(url: url) { responseData in
            
            //Check if data != nil
            guard let data = responseData.data else {
                print("no data")
                callback(false, nil)
                return
            }
            // control that response status is 200
            guard responseData.response?.statusCode == 200 else {
                print("Starus different than 200")
                callback(false, nil)
                return
            }
            // MARK: - 5 Translation JSON in String
            guard let responseJSON = try? JSONDecoder().decode(CompleteRecipe.self, from: data) else {
                print("pblm resposeJson")
                callback(false, nil)
                return
            }
            print(responseJSON)
            callback(true,responseJSON)
        }
        
    }
}

