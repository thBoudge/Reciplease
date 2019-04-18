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
    var ingredientArray = [Ingredients]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientArray = Ingredients.fetchAll()
        
//        let newIngredient = Ingredients()
//        newIngredient.ingredientName = "egg"
//        itemArray.append(newIngredient)
//
//        let newIngredient2 = Ingredients()
//        newIngredient2.ingredientName = "tomato"
//        itemArray.append(newIngredient2)
//
//        let newIngredient3 = Ingredients()
//        newIngredient3.ingredientName = "sugar"
//        itemArray.append(newIngredient3)
    }
    


    @IBAction func addIngredients(_ sender: UIButton) {
        
        if ingredientsTextField.text != "" {
            
            let newIngredient = Ingredients(context: AppDelegate.viewContext)
            newIngredient.ingredientName = ingredientsTextField.text!
            newIngredient.checked = false
            ingredientArray.append(newIngredient)
            ingredientsTextField.text = ""
            
        }
        
        try? AppDelegate.viewContext.save()
        self.ingredientArray = Ingredients.fetchAll()
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
    }
    
    
    
    private func deleteRow(checked: Bool ) {
        //////Delete Row\\\\\\
        if checked == true {
            for i in ingredientArray {
                    if i.checked == true {
                        //removing our data from our context store
                        AppDelegate.viewContext.delete(i)
                    }
            }
        } else {
            for i in 0..<ingredientArray.count{
                    //removing our data from our context store
                    AppDelegate.viewContext.delete(ingredientArray[i])
            }
        }
        try? AppDelegate.viewContext.save()
        self.ingredientArray = Ingredients.fetchAll()
        ingredientsTableView.reloadData()
      }
}

extension IngredientSearchViewController: UITableViewDelegate, UITableViewDataSource {

   
    // Number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientArray.count
    }
    
    // What is on the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        
        let ingredient = ingredientArray[indexPath.row]
        cell.textLabel?.text = ingredient.ingredientName
        
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
        self.ingredientArray = Ingredients.fetchAll()
        tableView.reloadData()
        
        
        //we change selection row brilliance t a fast one
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //code xib or storyboard ajout header
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//    }
    
    
}

