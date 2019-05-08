//
//  FavoriteTableView.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-14.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit

class FavoriteTableView: UITableViewController {

    //MARK: - Properties
    private var  recipe = Recipe.fetchAll()
    private var yummlyService = YummlyService()
    private var response : CompleteRecipe?
    private var tagNumber = 0
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        recipe = Recipe.fetchAll()
        tableView.reloadData()
        //      TODO: Register your MessageCell.xib file here:
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "recipeTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recipe = Recipe.fetchAll()
        tableView.reloadData()
    }
    
    @objc func deleteFromFavorite(sender: UIButton){
        
        guard let cell = sender.superview?.superview?.superview as? RecipeTableViewCell else {
            return // or fatalError() or whatever
        }
        let indexPath = tableView.indexPath(for: cell)
        print(indexPath!)
        guard let recip = Category.fetchAll()[(indexPath?.section)!].recipes?.allObjects[(indexPath?.row)!] as! Recipe? else {return}
        print(recip)
        guard let name = recip.name else {return}
        Recipe.deleteFavoriteRecipe(name: name)
        recipe = Recipe.fetchAll()
        tableView.reloadData()
    }
    
    //MARK: - Methods
    private func openRecipeDescription(section: Int, row: Int){
        
        guard let recipeSelected = Category.fetchAll()[section].recipes?.allObjects[row] as! Recipe? else {return}
        
        if let idRecipe = recipeSelected.id {
            
            yummlyService.updateRecipeData(idRecipe: idRecipe)
            
            yummlyService.getRecipe{ (success, recipe) in
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
        if segue.identifier == "goToRecipe"{
            // we check destination
            if let recipeViewController = segue.destination as? RecipeViewController {
                recipeViewController.recipe = response
            }
        }
    }
    
}
//MARK: - TableView Delegate and dataRessource
extension FavoriteTableView {
    
    //MARK: TableView appearance
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRow = Category.fetchAll()[section].recipes?.count else {return 0}
        return numberOfRow
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        
        cell.recipe = Category.fetchAll()[indexPath.section].recipes?.allObjects[indexPath.row] as! Recipe?
//        cell.recipeButton.tag = indexPath.row
        
        cell.recipeButton.addTarget(self, action: #selector(deleteFromFavorite(sender:)), for: .touchUpInside)
        cell.recipeButton.setImage(UIImage(named: "favorite-Full-heart-button"), for: .normal)
            
        return cell
    }
    
    //MARK: TableView management with no data
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Go to search and add Favorite recipe "
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return recipe.isEmpty ? 200 : 0
    }
    
    // everytime we select a cell what do we do
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        openRecipeDescription(section: indexPath.section, row: indexPath.row)
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        return Category.fetchAll()[section].categoryName
//    }
//
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.text = Category.fetchAll()[section].categoryName
        label.font = UIFont(name:"IndieFlower", size:25)
        label.textColor = .white
        label.frame = CGRect(x: 5, y: 0, width: 200, height: 35)
        view.addSubview(label)
        return view
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Category.fetchAll().count
    }
    
   
}
