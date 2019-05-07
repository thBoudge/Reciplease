//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-19.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var recipeQuoteLabel: UILabel!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var recipeButton: UIButton!
    
//    let resultSearchTableView = ResultSearchTableView()
    
    
    var match : Match? {
        didSet {
            recipeNameLabel.text = match?.recipeName
            guard let time = match?.totalTimeInSeconds  else {return }
            cookTimeLabel.text = "\(time / 60) minutes"
            guard let rating = match?.rating  else {return }
            recipeQuoteLabel.text = "\(rating) Stars"
            guard let image90 = match?.imageUrlsBySize?.the90  else {return }
            //full or normal heart image on Button
            guard let id = match?.id  else {return }
            let imageButton = Recipe.isAFavorite(id: id)
            recipeButton.setImage(UIImage(named: imageButton), for: .normal)
            //Change Image Resolution to 360 pixel
            //Computed Variable
            var image360 : String {
                return image90.dropLast(4) + "360"
            }
            
           let url = URL(string: String(image360)) //a deballer
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            recipeImageView.image = UIImage(data: data!)
            
            guard let ingredientsList = match?.ingredients else {return }
            
            var ingredients = ""
            for i in 0..<ingredientsList.count   {
                guard let ingredient = match?.ingredients?[i] else {return}
        
                ingredients += "\(ingredient), "
            }
            ingredientsLabel.text = "\(ingredients)"
        }
        
    }
    
    var recipe : Recipe? {
        didSet {
            recipeNameLabel.text = recipe?.name
            guard let timeString = recipe?.cookTime else {return }
            cookTimeLabel.text = "\(timeString)"
            guard let rating = recipe?.rate else {return }
            recipeQuoteLabel.text = "\(rating) Stars"
            guard let imageData = recipe?.image as Data?  else {return }
            recipeImageView.image =  UIImage(data: imageData)
            guard let ingredients = recipe?.ingredientCellLabel else {return}
            ingredientsLabel.text = ingredients
        }
        
    }
    
   
   
    
}
