//
//  CategoryTest.swift
//  RecipleaseTests
//
//  Created by Thomas Bouges on 2019-04-25.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class CategoryTest: XCTestCase {

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
    private func insertCategory(into managedObjectContext: NSManagedObjectContext) {
        let category = Category(context: managedObjectContext)
        category.categoryName = "Main Course"
    }
    
    //MARK: - Helper Methods
    private func insertOneCategory(into managedObjectContext: NSManagedObjectContext) {
        
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "OneRecipe", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        guard let responseJSON = try? JSONDecoder().decode(CompleteRecipe.self, from: data) else {return}
        Recipe.saveData(recipeResponse: responseJSON, ingredients: "beans", context: mockContainer.viewContext)
        
    }
    
    //MARK: - Unit Tests
    func testInsertManyCategoryInPersistentContainer() {
        for _ in 0 ..< 100 {
            insertCategory(into: mockContainer.newBackgroundContext())
        }
        XCTAssertNoThrow(try mockContainer.newBackgroundContext().save())
    }
    
    func testresearchResultIsreturnArrayOfCategoryCorrectly() {
        
        insertOneCategory(into: mockContainer.newBackgroundContext())
        insertOneCategory(into: mockContainer.newBackgroundContext())
        insertOneCategory(into: mockContainer.newBackgroundContext())
        
        var categoryResearch = Reciplease.Category.researchResultIs(searchText: "Side Dishes", context: mockContainer.newBackgroundContext())
        XCTAssertEqual(categoryResearch[0].categoryName, "Side Dishes")


        let categoryNill = Reciplease.Category.researchResultIs(searchText: "lou", context: mockContainer.newBackgroundContext())

        XCTAssertEqual(categoryNill, [])
        
    }
    
}
