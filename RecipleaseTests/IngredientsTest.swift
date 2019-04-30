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


class IngredientsTest: XCTestCase {

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
        let ingredient = Ingredient(context: managedObjectContext)
        ingredient.ingredientName = "chocolate"
        ingredient.checked = true
    }
    
    //MARK: - Unit Tests
    func testInsertManyIngredientInPersistentContainer() {
        for _ in 0 ..< 100 {
            insertIngredient(into: mockContainer.newBackgroundContext())
        }
        XCTAssertNoThrow(try mockContainer.newBackgroundContext().save())
    }
    
    func testDeleteAllIngredientInPersistentContainer() {
        insertIngredient(into: mockContainer.viewContext)
        try? mockContainer.viewContext.save()
        Ingredient.deleteAll(viewContext: mockContainer.viewContext)
        XCTAssertEqual(Ingredient.fetchAll(viewContext: mockContainer.viewContext), [])
    }
    
}
