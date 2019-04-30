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
    
//    private var recipeChecked = [Bool]()
    private var response : CompleteRecipe?
    private var ingredientsResponse : String = ""
    private var yummlyService = YummlyService()
    
    // Category? var is optional vecause is going to be nil until we use it
    var allRecipe : Recipes?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for _ in (allRecipe?.matches)! {
//            recipeChecked.append(true)
//        }
        
//      TODO: Register your MessageCell.xib file here:
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "recipeTableViewCell")
      }
    
    @IBAction func addToFavorite(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func addToFavorite(sender: UIButton){
        print("in")
        // get IndexPath for Tag Button
        let indexPath = IndexPath(index: sender.tag)
        // get to cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        
        if sender.currentImage == UIImage(named: "favorite-heart-outline-button") {
            
            sender.setImage(UIImage(named: "favorite-Full-heart-button"), for: .normal)
            
            print("insave")
            
            // we recuperate IdReceipe
            if let idRecipe = allRecipe?.matches?[sender.tag].id {
                
                yummlyService.updateRecipeData(idRecipe: idRecipe)
                
                yummlyService.getRecipe { (success, recipe) in
                    print(success.description)
                    if success != false {
                        // we get ingredients for cell
                        if let ingredientString = cell.ingredientsLabel.text {
                            self.ingredientsResponse = ingredientString
                        }
                        // We save data
                        Recipe.saveData(recipeResponse: recipe, ingredients: self.ingredientsResponse)
                        
                    } else { print("error")
                        return}
                }
            }
            
        } else if sender.currentImage == UIImage(named: "favorite-Full-heart-button") {
            print("indelete")
            sender.setImage(UIImage(named: "favorite-heart-outline-button"), for: .normal)
            guard let name = allRecipe?.matches?[sender.tag].recipeName else {return}
            print()
            print(indexPath)
            print(sender.tag)
            print(name)
            Recipe.deleteFavoriteRecipe(name: name)
        }
        
        tableView.reloadData()
        
    }
    
    //Methods to load Recipe Data and to perform segue
    private func openRecipeDescription(index: Int){
        
        
        //to know where the user tap
        ///////A EFFACER\\\\\\\\
        if let idRecipe = allRecipe?.matches?[index].id {
            
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
                    recipeViewController.Ingredients = ingredientsResponse
                    
                    print(ingredientsResponse)
                }
        }
    }
    
}


//MARK: - TableView Override
extension ResultSearchTableView {
    
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
//        cell.validateImageView.isHidden = recipeChecked[indexPath.row] == true ? true : false
        
        
        
        cell.recipeButton.tag = indexPath.row
        cell.recipeButton.addTarget(self, action: #selector(addToFavorite(sender:)), for: .touchUpInside)
        // We check if recipe is already in Favorite to do not add twice
        for i in Recipe.fetchAll() {
            guard let id = allRecipe?.matches?[indexPath.row].id else {fatalError("we had a nil when we open id")}
            if i.id == id {
                cell.recipeButton.setImage(UIImage(named: "favorite-Full-heart-button"), for: .normal)
            }
        }
        return cell
    }
    
    // everytime we select a cell what do we do
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        // we get ingredients for cell
        if let ingredientString = cell.ingredientsLabel.text {
            ingredientsResponse = ingredientString
        }
        openRecipeDescription(index: indexPath.row)
        
        
    }
    
}

