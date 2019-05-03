//
//  CategoriesTest.swift
//  RecipleaseTests
//
//  Created by Thomas Bouges on 2019-04-25.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class CategoriesTest: XCTestCase {

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
    
//    func testDeleteAllCategoryInPersistentContainer() {
//        insertCategory(into: mockContainer.viewContext)
//        try? mockContainer.viewContext.save()
//        Category.deleteAll(viewContext: mockContainer.viewContext)
//        XCTAssertEqual(Category.fetchAll(viewContext: mockContainer.viewContext), [])
//    }
    
    
}
