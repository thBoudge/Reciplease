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
    var category = Category.fetchAll()
    private var idRecipe = [Int]() // send Section and row of cell in oreder to open one Recipe
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadDataCategory()
        //      TODO: Register your MessageCell.xib file here:
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "recipeTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadDataCategory()
        searchBar.barTintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    
    @objc func deleteFromFavorite(sender: UIButton){
        
        guard let cell = sender.superview?.superview?.superview as? RecipeTableViewCell else { return}
        let indexPath = tableView.indexPath(for: cell)
        guard let recip = Category.fetchAll()[(indexPath?.section)!].recipes?.allObjects[(indexPath?.row)!] as! Recipe? else {return}
        guard let name = recip.name else {return}
        Recipe.deleteFavoriteRecipe(name: name)
        reloadDataCategory()
    }
   
    
    //MARK: - Methods
    private func reloadDataCategory(){
        category = Category.fetchAll()
        tableView.reloadData()
    }
    
    private func openRecipeDescription(section: Int, row: Int){
        idRecipe.removeAll()
        idRecipe.append(section)
        idRecipe.append(row)
        self.performSegue(withIdentifier: "goToFavoriteRecipe", sender: self)
    }

    //Override func prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFavoriteRecipe"{
            // we check destination
            if let recipeViewController = segue.destination as? RecipeViewController {
                recipeViewController.favorite = idRecipe
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

//MARK: - Extension SearchBARDelegate
extension FavoriteTableView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchString = searchBar.text else {return}
        category = Category.researchResultIs(searchText: searchString)
        
        tableView.reloadData()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    // How app's is going to react if we change text in research bar or if have ""
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            reloadDataCategory()
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
        }
    }
        
}
