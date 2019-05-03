//
//  ViewController.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-14.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit

class IngredientSearchViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    //MARK: - Properties
    private var ingredientArray = [Ingredient]()
    private var response : Recipes?
    private var yummlyService = YummlyService()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientArray = Ingredient.fetchAll()
        
    }
    

    //MARK: - Action Method
    @IBAction func addIngredients(_ sender: UIButton) {
        
        guard let ingredients = ingredientsTextField.text else {fatalError("we found Nil when opening ingredientsTextField.text")}
        
        Ingredient.addIngredient(ingredientName: ingredients)
           
        ingredientsTextField.text = ""
        try? AppDelegate.viewContext.save()
        self.ingredientArray = Ingredient.fetchAll()
        ingredientsTableView.reloadData()
       
    }
    
    
    @IBAction func deleteCell(_ sender: UIButton) {
        
        var checked = 0
        for i in ingredientArray {
            if i.checked == true {
                checked += 1
            }
         }
        
        if checked == 0 {
            deleteRow(checked: false)
        } else {
            deleteRow(checked: true)
        }
        
    }
    
    
    @IBAction func searchReceipe(_ sender: UIButton) {
        
        yummlyService.updateData(table: ingredientArray)
        
        yummlyService.getRecipes { (success, recipe) in
            if success != false {
            guard let recipeToLoad = recipe else {return}
            self.response = recipeToLoad
            self.performSegue(withIdentifier: "goToRecipeSearchResult", sender: self)
            } else{ print("error")
                return}
        }
    }
    
    
    //MARK: - Methods
    
    private func deleteRow(checked: Bool ) {
        //////Delete Row\\\\\\
        if checked == true {
            for i in ingredientArray {
                    if i.checked == true {
                        //removing our data from our context store
                        AppDelegate.viewContext.delete(i)
                    }
            }
        } else { //We delete all
            Ingredient.deleteAll()
        }
        try? AppDelegate.viewContext.save()
        self.ingredientArray = Ingredient.fetchAll()
        ingredientsTableView.reloadData()
      }
    
    //prepare segue before to perfomr it
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ResultSearchTableView
        //we inform where we send data in other viewController
            destinationVC.allRecipe = response
    }
    
}

//MARK: - TableView delegate and Datasource methods
extension IngredientSearchViewController: UITableViewDelegate, UITableViewDataSource {

   
    // Number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return ingredientArray.count
    }
    
    // What is on the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        
        let ingredient = ingredientArray[indexPath.row]
        cell.textLabel?.text = "-  \(ingredient.ingredientName!)"
        cell.textLabel?.textColor = .white
        
        //Ternary operator
        // value = condition ? valueIftrue : valueIfFalse
        cell.accessoryType = ingredient.checked == true ? .checkmark : .none
        
        return cell
    }
    
    // everytime we select a cell what do we do
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // add or not a chekmark when row selectec
        ingredientArray[indexPath.row].checked = !ingredientArray[indexPath.row].checked
        
        try? AppDelegate.viewContext.save()
        self.ingredientArray = Ingredient.fetchAll()
        tableView.reloadData()
        
        //we change selection row brilliance t a fast one
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: TableView management with no data
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please add an ingredient "
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ingredientArray.isEmpty ? 200 : 0
    }
}

