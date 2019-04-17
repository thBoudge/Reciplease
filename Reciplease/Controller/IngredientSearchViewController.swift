//
//  ViewController.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-14.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit

class IngredientSearchViewController: UIViewController {

    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var ingredientsTextField: UITextField!
    var itemArray = [Ingredients]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newIngredient = Ingredients()
        newIngredient.ingredientName = "egg"
        itemArray.append(newIngredient)
        
        let newIngredient2 = Ingredients()
        newIngredient2.ingredientName = "tomato"
        itemArray.append(newIngredient2)
        
        let newIngredient3 = Ingredients()
        newIngredient3.ingredientName = "sugar"
        itemArray.append(newIngredient3)
    }
    


    @IBAction func addIngredients(_ sender: UIButton) {
        
        if ingredientsTextField.text != "" {
            
            let newIngredient = Ingredients()
            newIngredient.ingredientName = ingredientsTextField.text!
            itemArray.append(newIngredient)
            ingredientsTextField.text = ""
            
        }
        ingredientsTableView.reloadData()
    }
    
    
}

extension IngredientSearchViewController: UITableViewDelegate, UITableViewDataSource {

   
    // Number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // What is on the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        
        let ingredient = itemArray[indexPath.row]
        cell.textLabel?.text = ingredient.ingredientName
        
        //Ternary operator
        // value = condition ? valueIftrue : valueIfFalse
        cell.accessoryType = ingredient.checked == true ? .checkmark : .none
        
        return cell
    }
    
    // everytime we select a cell what do we do
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // add or not a chekmark when row selectec
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        
        tableView.reloadData()
        
        
        //we change selection row brilliance t a fast one
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //code xib or storyboard ajout header
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//    }
    
    
}

