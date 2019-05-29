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
    var favoriteRecipe : Recipe?
    var categoryName : String = ""
    var ingredients : String = ""
    var favorite = [Int]()
    var ingredientListString = ""
    var ingredientTableView : Array = [String]()
    var urlRecipe : String = ""
    var idFavoriteRecipe : String = ""
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewValueToView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFavoriteImage()
    }
    
    @IBAction func goToFullRecipe(_ sender: Any) {
        if let url = URL(string: urlRecipe) {
            UIApplication.shared.open(url)
        }
    }
    
    //Methods to add or delete Favorite Recipe
    @objc func addOrDeleteFavorite(){
        
        if favoriteImage.image == UIImage(named: "favorite-heart-outline-button") {
            saveData()
        } else if favoriteImage.image == UIImage(named: "favorite-Full-heart-button") {
            deleteData()
        }
    }
    
    private func saveData(){
        if !favorite.isEmpty {
            let newRecipe = Recipe(context: AppDelegate.viewContext)
            newRecipe.cookTime = cookTimeLabel.text
            newRecipe.id = idFavoriteRecipe
            guard let img = recipeImageView?.image else {return}
            newRecipe.image = img.pngData() as Data?
            newRecipe.ingredientCellLabel = ingredients
            newRecipe.ingredientsCompletRecipe = ingredientListString
            newRecipe.name = recipeNameLabel.text
            newRecipe.rate = ratingLabel.text
            newRecipe.recipe_url = urlRecipe
            
            newRecipe.parentCategory?.categoryName = categoryName
            try? AppDelegate.viewContext.save()
           
        }else {
        Recipe.saveData(recipeResponse: recipe, ingredients: ingredients)
        }
        
        favoriteImage.image = UIImage(named:"favorite-Full-heart-button")
    }
    
    private func deleteData(){
        if !favorite.isEmpty {
            guard let name = favoriteRecipe?.name else {return}
            Recipe.deleteFavoriteRecipe(name: name)
        }else {
            guard let name = recipe?.name else {return}
            Recipe.deleteFavoriteRecipe(name: name)
        }
        favoriteImage.image = UIImage(named:"favorite-heart-outline-button")
    }
    
    private func addNewValueToView(){
        
        if !favorite.isEmpty {
            let section = favorite[0]
            let row = favorite[1]
            // keep category in case we delete and save again in favory
            guard let favoriteCategoryName = Category.fetchAll()[section].categoryName else {return}
            categoryName = favoriteCategoryName
            // save all recipe in global
            guard let favoriteRecipeData = Category.fetchAll()[section].recipes?.allObjects[row] as! Recipe? else {return}
            self.favoriteRecipe = favoriteRecipeData
            guard let ingredientsLabel = favoriteRecipe?.ingredientCellLabel else {return}
            ingredients = ingredientsLabel
            guard let idRecipe = favoriteRecipe?.id else {return}
            idFavoriteRecipe = idRecipe
            
        }
        
        getRatingCookTimeName()
        getMainImage()
        getFavoriteImage()
        getUrlDirection()
        getListOfIngredients()
    }
    
    private func getFavoriteImage(){
        //full or normal heart image on Button
        if !favorite.isEmpty {
            guard let id = favoriteRecipe?.id else {return }
            loadFavoriteImage(id: id)
        }else {
            //full or normal heart image on Button
            guard let id = recipe?.id else {return }
            loadFavoriteImage(id: id)
        }
        addTapGestureToHeartButton()
    }
    
    private func getRatingCookTimeName (){
    
        if !favorite.isEmpty {
            guard let rating = favoriteRecipe?.rate else {return}
            guard let cookTime = favoriteRecipe?.cookTime else {return}
            guard let recipeName = favoriteRecipe?.name else {return}
            addRatingCookTimeName(rating: rating, cookTime: cookTime, recipeName: recipeName)
        }else {
            guard let rating = recipe?.rating else {return}
            guard let cookTime = recipe?.totalTime else {return}
            guard let recipeName = recipe?.name else {return}
            addRatingCookTimeName(rating: String(rating), cookTime: cookTime, recipeName: recipeName)
        }
    }
    
    private func addRatingCookTimeName(rating:String,cookTime:String,recipeName:String){
        ratingLabel.text = "\(rating) stars"
        cookTimeLabel.text = "\(cookTime)"
        recipeNameLabel.text = recipeName
    }
    
    private func getMainImage (){
        
        if !favorite.isEmpty {
            guard let imageData = favoriteRecipe?.image as Data?  else {return }
            recipeImageView.image =  UIImage(data: imageData)
        }else {
            guard let image = recipe?.images?[0].hostedLargeURL else {return }
            let urlImage = URL(string: image) 
            guard let urlImagedata = urlImage else {return}
            guard let data = try? Data(contentsOf: urlImagedata) else {return}
            recipeImageView.image = UIImage(data: data)
        }
    }
    
    private func getListOfIngredients (){
        
        if !favorite.isEmpty {
            guard let ingredientRecipeData = favoriteRecipe?.ingredientsCompletRecipe  else {return }
            ingredientListString = ingredientRecipeData
            ingredientTableView = ingredientRecipeData.components(separatedBy: ",")
        }else {
            guard let ingredientRecipeURL = recipe?.ingredientLines else {return}
            ingredientTableView = ingredientRecipeURL
            
        }
    }
    
    private func getUrlDirection (){
        
        if !favorite.isEmpty {
            guard let urlDirection = favoriteRecipe?.recipe_url else {return}
            urlRecipe = urlDirection
        }else {
            guard let urlDirection = recipe?.source?.sourceRecipeURL else {return}
            urlRecipe = urlDirection
        }
    }
   
    private func addTapGestureToHeartButton(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addOrDeleteFavorite))
        recipeImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func loadFavoriteImage(id: String){
        
        let isAFavorite = Recipe.isAFavorite(id: id)
        if !isAFavorite {
            favoriteImage.image = UIImage(named: "favorite-heart-outline-button")
        } else {
            favoriteImage.image = UIImage(named: "favorite-Full-heart-button")
        }
    }
    
}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // Number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientTableView.count
    }
    
    // What is on the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeIngredientCell", for: indexPath)

        //Change to automatic number of line in order cell is size of text
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "- \(ingredientTableView[indexPath.row])"
        cell.textLabel?.font = UIFont(name:"IndieFlower", size:22)
        cell.textLabel?.textColor = .white
        return cell
    }
    
}
