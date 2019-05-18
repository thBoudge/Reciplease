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
    
    //MARK: - Unit Tests
    func testInsertManyCategoryInPersistentContainer() {
        for _ in 0 ..< 100 {
            insertCategory(into: mockContainer.newBackgroundContext())
        }
        XCTAssertNoThrow(try mockContainer.newBackgroundContext().save())
    }
    
    func testresearchResultIsreturnArrayOfCategoryCorrectly() {

        let category = Category(context: mockContainer.newBackgroundContext())
        category.categoryName = "Main Course"
        do {
            try mockContainer.newBackgroundContext().save()
        } catch  {
            print("catch context .save")
        }
        
        
        var categoryResearch = Category.researchResultIs(searchText: "Main Course", context: mockContainer.newBackgroundContext())

//        XCTAssertEqual(categoryResearch[0].categoryName, "Main Course")
        
//        category = Reciplease.Category.researchResultIs(searchText: "lou", context: mockContainer.newBackgroundContext())
//
//        XCTAssertEqual(category, [])
        
    }
    
}
