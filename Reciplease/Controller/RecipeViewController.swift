//
//  ReceipeViewController.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-14.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    
    var recipe : CompleteRecipe?
    var Ingredients : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(recipe?.name!)
        guard let rating = recipe?.rating else {return}
        guard let cookTime = recipe?.totalTime else {return}
        guard let recipeName = recipe?.name else {return}
        ratingLabel.text = "\(rating) stars"
        cookTimeLabel.text = "\(cookTime)"
        recipeNameLabel.text = recipeName
        
        guard let image = recipe?.images?[0].hostedLargeURL else {return }

        let url = URL(string: image) //a deballer
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        recipeImageView.image = UIImage(data: data!)
        
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
