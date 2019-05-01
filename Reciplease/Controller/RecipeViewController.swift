//
//  ReceipeViewController.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-14.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    //MARK: - Properties
    var recipe : CompleteRecipe?
    var Ingredients : String = ""
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let rating = recipe?.rating else {return}
        guard let cookTime = recipe?.totalTime else {return}
        guard let recipeName = recipe?.name else {return}
        ratingLabel.text = "\(rating) stars"
        cookTimeLabel.text = "\(cookTime)"
        recipeNameLabel.text = recipeName
        
        //full or normal heart image on Button
        guard let id = recipe?.id else {return }
        let imagename = Recipe.isAFavorite(id: id)
        favoriteImage.image = UIImage(named: imagename)
        
        guard let image = recipe?.images?[0].hostedLargeURL else {return }

        let url = URL(string: image) //a deballer
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        recipeImageView.image = UIImage(data: data!)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addOrDeleteFavorite))
        recipeImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //full or normal heart image on Button
        guard let id = recipe?.id else {return }
        let imagename = Recipe.isAFavorite(id: id)
        favoriteImage.image = UIImage(named: imagename)
    }
    
    @IBAction func goToFullRecipe(_ sender: Any) {
        
        guard let url = recipe?.source?.sourceRecipeURL else {return}
        
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    //Methods to add or delete Favorite Recipe
    @objc func addOrDeleteFavorite(){
        
        if favoriteImage.image == UIImage(named: "favorite-heart-outline-button") {
            
            Recipe.saveData(recipeResponse: recipe, ingredients: self.Ingredients)
            
            favoriteImage.image = UIImage(named:"favorite-Full-heart-button")
        } else if favoriteImage.image == UIImage(named: "favorite-Full-heart-button") {
            
            guard let name = recipe?.name else {return}
            Recipe.deleteFavoriteRecipe(name: name)
            favoriteImage.image = UIImage(named:"favorite-heart-outline-button")
        }
    }
   
}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // Number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRow = recipe?.ingredientLines?.count else {return 0}
        return numberOfRow
    }
    
    // What is on the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeIngredientCell", for: indexPath)
        
        guard let ingredient = recipe?.ingredientLines?[indexPath.row] else {return cell}
        //Change to automatic number of line in order cell is size of text
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = ingredient

        return cell
    }
    
    
    
    
}
