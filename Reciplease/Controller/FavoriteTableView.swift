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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard  let category = Categories.fetchAll()[section].categoryName else {fatalError("we found nil whe open category in numberOfrowInSection")}
        var numberOfRowBySection = 0
        for i in recipe {
            guard let categoryName = i.parentCategory?.categoryName else {fatalError("we found nil whe open categoryName in numberOfrowInSection")}
            if categoryName == category {
                numberOfRowBySection += 1
            }
        }
        return numberOfRowBySection
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableViewCell", for: indexPath) as! RecipeTableViewCell

        // transfert a cell pour assigner data
        // in order to get recipes that is an NSObject we create an array from allObjects with type of Recipe
        
//       let cellValue = Categories.fetchAll()[indexPath.section].recipes?[indexPath.row].allObjects as! [Recipe]
        let cellValue = Recipe.fetchAll()[indexPath.row].parentCategory?.categoryName
        let cellCat = Categories.fetchAll()[indexPath.section].categoryName
//        else {fatalError("we found nil when opening cellValue in CellForRowAt")}
        
        if cellValue == cellCat {

            cell.recipe = recipe[indexPath.row]
            cell.recipeButton.tag = indexPath.row
            cell.recipeButton.addTarget(self, action: #selector(openRecipeDescription(sender:)), for: .touchUpInside)

        }else{
            guard let cellVal = Categories.fetchAll()[indexPath.section].recipes?.allObjects as! [Recipe]? else {fatalError("we found nil when opening cellValue in CellForRowAt")}
            
            cell.recipe = cellVal[0]
            cell.recipeButton.tag = indexPath.row
            cell.recipeButton.addTarget(self, action: #selector(openRecipeDescription(sender:)), for: .touchUpInside)
        }
    
//        cell.recipe = cellValue
//
//
//        cell.recipeButton.tag = indexPath.row
//        cell.recipeButton.addTarget(self, action: #selector(openRecipeDescription(sender:)), for: .touchUpInside)

        return cell
    }
    //MARK: create section alphabetic Methods
    //number of section
    override func numberOfSections(in tableView: UITableView) -> Int {
        var categoriesString = ""
        var numberOfSection = 0
        for i in Categories.fetchAll() {
            guard let name = i.categoryName else {fatalError("we found Nil when we open name from Category")}
            if !categoriesString.contains(String(name)){
                categoriesString += "\(name)"
                numberOfSection += 1
            }
        }
        return numberOfSection
    }
    //   declarer des titre de section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let title = Categories.fetchAll()[section].categoryName else {fatalError("nil value when we open categoty name")}
        
        return title
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
