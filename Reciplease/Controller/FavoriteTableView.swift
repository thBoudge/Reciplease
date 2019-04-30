//
//  FavoriteTableView.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-14.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit

class FavoriteTableView: UITableViewController {

    
    private var  recipe = Recipe.fetchAll()
    private var yummlyService = YummlyService()
    private var response : CompleteRecipe?
    
    override func viewDidLoad() {
        recipe = Recipe.fetchAll()

        tableView.reloadData()
        
        //      TODO: Register your MessageCell.xib file here:
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "recipeTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recipe = Recipe.fetchAll()
        
        tableView.reloadData()
    }
    
   

    @objc func openRecipeDescription(sender: UIButton){

        let tag = sender.tag
        //to know where the user tap
        ///////A EFFACER\\\\\\\\
        if let idRecipe = recipe[tag].id {

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

extension FavoriteTableView {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return recipe.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        
            cell.recipe = recipe[indexPath.row]
            cell.recipeButton.tag = indexPath.row
            cell.recipeButton.addTarget(self, action: #selector(openRecipeDescription(sender:)), for: .touchUpInside)
            
        return cell
    }
    
    
}
