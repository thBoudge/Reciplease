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
    @IBOutlet weak var ingredientActivityIndicatorview: UIActivityIndicatorView!
    
    //MARK: - Properties
    private var ingredientArray = [Ingredient]()
    private var response : Recipes?
    private var yummlyService = YummlyService()
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // add delegate on textfiled in order to use htextfieldShourld return keyboard dismiss
        self.ingredientsTextField.delegate = self
        ingredientArray = Ingredient.fetchAll()
    }


    //MARK: - Action Method
    @IBAction func addIngredients(_ sender: UIButton) {
        
        addIngredientToData()
    }
    
    @IBAction func deleteCell(_ sender: UIButton) {
        
        var checked = 0
        for i in ingredientArray {
            if i.checked == true {
                checked += 1
            }
         }
        // value = condition ? valueIftrue : valueIfFalse
        checked == 0 ? Ingredient.deleteRow(checked: false) : Ingredient.deleteRow(checked: true)
        reloadData()
    }
    
    @IBAction func searchReceipe(_ sender: UIButton) {
        showHideTraductorActivityButton(shown: false)
        yummlyService.updateData(table: ingredientArray)
        
        yummlyService.getRecipes { (success, recipe) in
            self.showHideTraductorActivityButton(shown: true)
            if success != false {
            guard let recipeToLoad = recipe else {return}
            self.response = recipeToLoad
            self.performSegue(withIdentifier: "goToRecipeSearchResult", sender: self)
            } else{ print("error")
                return}
        }
    }
    
    //MARK: - Methods
    private func addIngredientToData(){
        
        guard let ingredients = ingredientsTextField.text else {return}
        Ingredient.addIngredient(ingredientName: ingredients)
        ingredientsTextField.text = ""
        reloadData()
        
    }
    
    //Method to show or hide activity indicator
    private func showHideTraductorActivityButton(shown: Bool) {
        ingredientActivityIndicatorview.isHidden = shown
    }
    
    private func reloadData(){
        ingredientArray = Ingredient.fetchAll()
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
        cell.textLabel?.font = UIFont(name:"IndieFlower", size:25)
        
        //Ternary operator
        // value = condition ? valueIftrue : valueIfFalse
        cell.accessoryType = ingredient.checked == true ? .checkmark : .none
        
        return cell
    }
    
    // Everytime we select a cell what do we do
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // add or not a chekmark when row selected
        ingredientArray[indexPath.row].checked = !ingredientArray[indexPath.row].checked
        try? AppDelegate.viewContext.save()
        reloadData()
        
        //we change selection row brilliance t a fast one
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: TableView management with no data
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please add an ingredient "
        label.font = UIFont(name:"IndieFlower", size:25)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ingredientArray.isEmpty ? 200 : 0
    }
}

//MARK: - UITEXTFieldDelegate
extension IngredientSearchViewController: UITextFieldDelegate{

    //Use to avoid tapgesture conflict
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addIngredientToData()
        textField.resignFirstResponder()
        return true
    }
    
}
