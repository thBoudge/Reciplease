//
//  ResultSearchTableView.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-14.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit

class ResultSearchTableView: UITableViewController {
    
    var recipeChecked = [Bool]()
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



