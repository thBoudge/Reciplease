//
//  RecipeTest.swift
//  RecipleaseTests
//
//  Created by Thomas Bouges on 2019-05-03.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class RecipeTest: XCTestCase {

   //MARK: - Properties
        lazy var mockContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "DataModel")
            container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
            container.loadPersistentStores(completionHandler: { (description, error) in
                XCTAssertNil(error)
            })
            return container
        }()
        
        //MARK: - Helper Methods
        private func insertRecipe(into managedObjectContext: NSManagedObjectContext) {
            
            let bundle = Bundle(for: FakeResponseData.self)
            let url = bundle.url(forResource: "OneRecipe", withExtension: "json")
            let data = try! Data(contentsOf: url!)
            guard let responseJSON = try? JSONDecoder().decode(CompleteRecipe.self, from: data) else {return}
            Recipe.saveData(recipeResponse: responseJSON, ingredients: "beans", context: mockContainer.viewContext)

        }
        
        //MARK: - Unit Tests
        func testInsertManyRecipeInPersistentContainer() {
            for _ in 0 ..< 100 {
                insertRecipe(into: mockContainer.newBackgroundContext())
            }
            XCTAssertNoThrow(try mockContainer.newBackgroundContext().save())
        }
        
//        func testDeleteAllRecipeInPersistentContainer() {
//            insertRecipe(into: mockContainer.viewContext)
//            Recipe.deleteAll(viewContext: mockContainer.viewContext)
//            XCTAssertEqual(Recipe.fetchAll(viewContext: mockContainer.viewContext), [])
//        }
    
        func testDeleteOneRecipeInPersistentContainer() {
            insertRecipe(into: mockContainer.viewContext)
            Recipe.deleteFavoriteRecipe(name: "Simple Skillet Green Beans", context: mockContainer.viewContext, recipe: Recipe.fetchAll(viewContext: mockContainer.viewContext))
            XCTAssertEqual(Recipe.fetchAll(viewContext: mockContainer.viewContext), [])
        }
    
    
    func testIsRecipeAFavoriteAndInPersistentContainer() {
        XCTAssertEqual(Recipe.isAFavorite(id: "Simple-Skillet-Green-Beans-2352743", recipe: Recipe.fetchAll(viewContext: mockContainer.viewContext)), "favorite-heart-outline-button")
        
        insertRecipe(into: mockContainer.viewContext)
        
        XCTAssertEqual(Recipe.isAFavorite(id: "Simple-Skillet-Green-Beans-2352743", recipe: Recipe.fetchAll(viewContext: mockContainer.viewContext)), "favorite-heart-outline-button")
//        Recipe.deleteFavoriteRecipe(name: "Simple Skillet Green Beans", context: mockContainer.viewContext, recipe: Recipe.fetchAll(viewContext: mockContainer.viewContext))
//        XCTAssertEqual(Recipe.isAFavorite(id: "Simple-Skillet-Green-Beans-2352743", recipe: Recipe.fetchAll(viewContext: mockContainer.viewContext)), "favorite-heart-outline-button")
    }
    
}
