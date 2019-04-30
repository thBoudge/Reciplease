//
//  ResultSearchTableView.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-14.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit
import CoreData

class ResultSearchTableView: UITableViewController {
    
    private var recipeChecked = [Bool]()
    private var response : CompleteRecipe?
    private var yummlyService = YummlyService()
    // Category? var is optional vecause is going to be nil until we use it
    var allRecipe : Recipes?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in (allRecipe?.matches)! {
            recipeChecked.append(true)
        }
        
//      TODO: Register your MessageCell.xib file here:
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "recipeTableViewCell")
      }
    
    @IBAction func addToFavorite(_ sender: UIBarButtonItem) {
        
        for i in 0..<recipeChecked.count {
            //We save only 
            if recipeChecked[i] == false {
                
                
                var notAFavorite = true
                
                //////////////// *****************Pas de Fatal Error car le nil nous bloque \\\\\\\\\\
                guard let time = allRecipe?.matches?[i].totalTimeInSeconds else {fatalError("Recipe Time was Nil when optional open")} //
                guard let id = allRecipe?.matches?[i].id else {fatalError("Recipe id was Nil when optional open")}
                guard let name = allRecipe?.matches?[i].recipeName else {fatalError("Recipe name was Nil when optional open")}
                guard let rate = allRecipe?.matches?[i].rating else {fatalError("Recipe rate was Nil when optional open")}
                guard let image90 = allRecipe?.matches?[i].imageUrlsBySize?.the90 else {fatalError("Recipe image90 was Nil when optional open")}
                
                // We check if recipe is already in Favorite to do not add twice
                for i in Recipe.fetchAll() {
                    if i.id == id {
                        notAFavorite = false
                    }
                }
                
                if notAFavorite {
                    saveData(index: i,time: time, id: id, name: name, rate: rate, image90: image90)
                }
             }
            
        }
        tableView.reloadData()
        
    }
    
    private func saveData(index: Int, time : Int, id: String, name: String, rate: Int, image90 : String){
        
        let newCategory = Categories(context: AppDelegate.viewContext)
        if let categoryName = allRecipe?.matches?[index].attributes?.course?[0]  {
            newCategory.categoryName = categoryName
        } else {
            newCategory.categoryName = "All purpose"
        }
        
        
        let newRecipe = Recipe(context: AppDelegate.viewContext)
        newRecipe.parentCategory = newCategory
//        var image360 : String {
//            return image90.dropLast(4) + "360"
//        }
        newRecipe.cookTime = Int16(time)
        newRecipe.id = id
        newRecipe.name = name
        newRecipe.rate = Int16(rate)
        newRecipe.imageURL = image90
        
        
        /////inverse recette dans category faux/////
//        newCategory.addToRecipes(newRecipe)
        
        ///// method NSCoder \\\\\
        //we save context on CoreDatabase (persistant container)
        do {
            try AppDelegate.viewContext.save()
        }catch{
            print("Error saving context \(error)")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = allRecipe?.matches!.count else {return 0}
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        
        // transfert a cell pour assigner data 
        cell.match = allRecipe?.matches?[indexPath.row]
        
        //Ternary operator
        // value = condition ? valueIftrue : valueIfFalse
        cell.validateImageView.isHidden = recipeChecked[indexPath.row] == true ? true : false
        
        // We check if recipe is already in Favorite to do not add twice
        for i in Recipe.fetchAll() {
            guard let id = allRecipe?.matches?[indexPath.row].id else {fatalError("we had a nil when we open id")}
            if i.id == id {
                cell.validateImageView.image = #imageLiteral(resourceName: "favorite-heart-outline-button")
                cell.validateImageView.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
        }
        
        cell.recipeButton.tag = indexPath.row
        cell.recipeButton.addTarget(self, action: #selector(openRecipeDescription(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    // everytime we select a cell what do we do
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        recipeChecked[indexPath.row] = !recipeChecked[indexPath.row]
        
        
        tableView.reloadData()
       
        
    }
    
    @objc func openRecipeDescription(sender: UIButton){
        
        let tag = sender.tag
        //to know where the user tap
        ///////A EFFACER\\\\\\\\
        if let idRecipe = allRecipe?.matches?[tag].id {
            
            yummlyService.updateRecipeData(idRecipe: idRecipe)
            
            yummlyService.getRecipe { (success, recipe) in
                print(success.description)
                if success != false {
                    guard let recipeToLoad = recipe else {return}
                    self.response = recipeToLoad
                    
                    self.performSegue(withIdentifier: "goToRecipe", sender: self)
                } else{ print("error")
                    return}
            }
        }
        
    }

    
    //Override func prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //We tel for wich segue we will work here "AddItemSegue"

            if segue.identifier == "goToRecipe"{
                // we check destination
                if let recipeViewController = segue.destination as? RecipeViewController {
                    recipeViewController.recipe = response
                    
                }
        }
    }
    
}



