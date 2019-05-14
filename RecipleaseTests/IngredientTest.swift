//
//  IngredientsTest.swift
//  RecipleaseTests
//
//  Created by Thomas Bouges on 2019-04-18.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease


class IngredientTest: XCTestCase {

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
    func insertIngredient(into managedObjectContext: NSManagedObjectContext) {
        Ingredient.addIngredient(ingredientName: "chocolate", context: managedObjectContext)
    }
    
    //MARK: - Unit Tests
    func testInsertManyIngredientInPersistentContainer() {
        for _ in 0 ..< 100 {
            insertIngredient(into: mockContainer.newBackgroundContext())
        }
        XCTAssertNoThrow(try mockContainer.newBackgroundContext().save())
    }
    
    func testDeleteAllIngredientIfNoOneCheckedInPersistentContainer() {
        insertIngredient(into: mockContainer.viewContext)
        Ingredient.deleteRow(checked: false, viewContext: mockContainer.viewContext)
        XCTAssertEqual(Ingredient.fetchAll(viewContext: mockContainer.viewContext), [])
    }
    
    func testDeleteCheckedIngredientInPersistentContainer() {
        insertIngredient(into: mockContainer.viewContext)
        Ingredient.fetchAll(viewContext: mockContainer.viewContext)[0].checked = true
        Ingredient.deleteRow(checked: true, viewContext: mockContainer.viewContext)
        XCTAssertEqual(Ingredient.fetchAll(viewContext: mockContainer.viewContext), [])
    }
    
    
    func testInsertManyIngredientAtOnceInPersistentContainer() {
        Ingredient.addIngredient(ingredientName: "chocolate ,cacao , garlic, fish", context: mockContainer.viewContext)
        XCTAssertEqual(Ingredient.fetchAll(viewContext: mockContainer.viewContext)[0].ingredientName!, "cacao")
        XCTAssertEqual(Ingredient.fetchAll(viewContext: mockContainer.viewContext)[1].ingredientName!, "chocolate")
        XCTAssertEqual(Ingredient.fetchAll(viewContext: mockContainer.viewContext)[2].ingredientName!, "fish")
        XCTAssertEqual(Ingredient.fetchAll(viewContext: mockContainer.viewContext)[3].ingredientName!, "garlic")
    }
    
}
