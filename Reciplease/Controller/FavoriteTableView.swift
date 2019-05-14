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
//    private var  recipe = Recipe.fetchAll()
    private var category = Category.fetchAll()
    private var yummlyService = YummlyService()
    private var response : CompleteRecipe?
    private var tagNumber = 0
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        category = Category.fetchAll()
        tableView.reloadData()
        //      TODO: Register your MessageCell.xib file here:
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "recipeTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        category = Category.fetchAll()
        tableView.reloadData()
    }
    
    @objc func deleteFromFavorite(sender: UIButton){
        
        guard let cell = sender.superview?.superview?.superview as? RecipeTableViewCell else {
            return // or fatalError() or whatever
        }
        let indexPath = tableView.indexPath(for: cell)
        
//        dissapearAnimation(cell: cell)
        print(indexPath!)
        guard let recip = Category.fetchAll()[(indexPath?.section)!].recipes?.allObjects[(indexPath?.row)!] as! Recipe? else {return}
        print(recip)
        guard let name = recip.name else {return}
        Recipe.deleteFavoriteRecipe(name: name)
        category = Category.fetchAll()
        tableView.reloadData()
    }
    
//    private func dissapearAnimation(cell: RecipeTableViewCell){
//
//        // set initial vstate of the cell
//
//
//        UIView.animate(withDuration: 10, delay: 0.1, animations: {
//            cell.layer.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//        })
//
//    }
    
    //MARK: - Methods
    private func openRecipeDescription(section: Int, row: Int){
        
        guard let recipeSelected = category[section].recipes?.allObjects[row] as! Recipe? else {return}
        
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
        guard let numberOfRow = category[section].recipes?.count else {return 0}
        return numberOfRow
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        
        cell.recipe = category[indexPath.section].recipes?.allObjects[indexPath.row] as! Recipe?
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
        print("sectionLabel")
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        print("sectionif")
        return category.isEmpty ? 200 : 0
    }
    
    // everytime we select a cell what do we do
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        openRecipeDescription(section: indexPath.section, row: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let categoryName = category[section].categoryName else {return ""}
        guard let number = category[section].recipes?.allObjects.count else {return ""}
        let numberString = String(number)
        let header = "\(categoryName)            \(numberString)"
        return header
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont(name:"IndieFlower", size:25)
        header.textLabel?.frame = CGRect(x: 5, y: 0, width: 200, height: 35)
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
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
