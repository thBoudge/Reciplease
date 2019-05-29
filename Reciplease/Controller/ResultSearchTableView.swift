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
    
    //MARK: - Properties
    private var response : CompleteRecipe?
    private var ingredientsResponse : String = ""
    private var yummlyService = YummlyService()
    
    // Category? var is optional vbcause is going to be nil until we use it
    var allRecipe : Recipes?
    
     //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //link with recipeTableViewCell
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "recipeTableViewCell")
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    //MARK: - Methods
        //Methods to save Recipe Data and add to favorite
    @objc func addToFavorite(sender: UIButton){
        // get IndexPath for Tag Button
        let indexPath = IndexPath(index: sender.tag)
        // get to cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        
        if sender.currentImage == UIImage(named: "favorite-heart-outline-button") {
            sender.setImage(UIImage(named: "favorite-Full-heart-button"), for: .normal)
            addToDataBase(sender: sender, cell: cell)
            
        } else if sender.currentImage == UIImage(named: "favorite-Full-heart-button") {
            sender.setImage(UIImage(named: "favorite-heart-outline-button"), for: .normal)
            guard let name = allRecipe?.matches?[sender.tag].recipeName else {return}
            Recipe.deleteFavoriteRecipe(name: name)
        }
      }
    
    private func addToDataBase(sender: UIButton, cell: RecipeTableViewCell){
        // we recuperate IdReceipe
        if let idRecipe = allRecipe?.matches?[sender.tag].id {
            
            yummlyService.updateRecipeData(idRecipe: idRecipe)
            
            yummlyService.getRecipe { (success, recipe) in
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
    }
    
    
    //Methods to load Recipe Data and to perform segue
    private func openRecipeDescription(index: Int){
        
        if let idRecipe = allRecipe?.matches?[index].id {
            
            yummlyService.updateRecipeData(idRecipe: idRecipe)
            
            yummlyService.getRecipe { (success, recipe) in
                if success != false {
                    guard let recipeToLoad = recipe else {return}
                    self.response = recipeToLoad
                    self.performSegue(withIdentifier: "goToRecipe", sender: self)
                } else{ print("error")
                        return
                }
            }
        }
    }

    
    //Override func prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //We tell for which segue we will work here "AddItemSegue"
        if segue.identifier == "goToRecipe"{
                // we check destination
                if let recipeViewController = segue.destination as? RecipeViewController {
                    recipeViewController.recipe = response
                    // we transfer ingredient list in order to add to Favorite in case
                    recipeViewController.ingredients = ingredientsResponse
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
        cell.recipeButton.tag = indexPath.row
        cell.recipeButton.addTarget(self, action: #selector(addToFavorite(sender:)), for: .touchUpInside)
        return cell
    }
    
    // everytime we select a cell what do we do
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        cell.cellActivityIndicatorView.isHidden = false
        // we get ingredients for cell
        if let ingredientString = cell.ingredientsLabel.text {
            ingredientsResponse = ingredientString
        }
        
        openRecipeDescription(index: indexPath.row)
        cell.cellActivityIndicatorView.isHidden = true
    }
    
    //MARK: TableView management with no data
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Change ingredients or try again"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (allRecipe?.matches!.isEmpty)! ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let translationMovement = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = translationMovement
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
        }
    }
    
}

