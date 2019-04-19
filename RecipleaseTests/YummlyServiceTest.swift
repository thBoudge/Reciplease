//
//  YummlyServiceTest.swift
//  RecipleaseTests
//
//  Created by Thomas Bouges on 2019-04-19.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import XCTest
@testable import Reciplease

class YummlyServiceTest: XCTestCase {

    func testGetRecipeShouldPostFailedCallback() {
        let fakeResponse = FakeResponse(response: nil, data: nil, error: FakeResponseData.networkError)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        var ingredient = Ingredients.fetchAll()
        ingredient[0].ingredientName = "chocolate"
        ingredient[0].checked = true
        yummlyService.updateData(table: ingredient)
        
        yummlyService.getRecipes { success, recipe in
            XCTAssertFalse(success)
            XCTAssertNil(recipe)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeShouldPostFailedCallbackIfNoData() {
        let fakeResponse = FakeResponse(response: nil, data: FakeResponseData.incorrectData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        var ingredient = Ingredients.fetchAll()
        ingredient[0].ingredientName = "chocolate"
        ingredient[0].checked = true
        yummlyService.updateData(table: ingredient)
        
        yummlyService.getRecipes { success, recipe in
            XCTAssertFalse(success)
            XCTAssertNil(recipe)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeRateShouldPostFailedCallbackIfIncorrectResponse() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        var ingredient = Ingredients.fetchAll()
        ingredient[0].ingredientName = "chocolate"
        ingredient[0].checked = true
        yummlyService.updateData(table: ingredient)
        
        yummlyService.getRecipes { success, recipe in
            XCTAssertFalse(success)
            XCTAssertNil(recipe)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    
    func testGetRecipeShouldPostFailedCallbackIfResponseCorrectAndNilData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: nil, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        var ingredient = Ingredients.fetchAll()
        ingredient[0].ingredientName = "chocolate"
        ingredient[0].checked = true
        yummlyService.updateData(table: ingredient)
        
        yummlyService.getRecipes { success, recipe in
            XCTAssertFalse(success)
            XCTAssertNil(recipe)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeShouldPostFailedCallbackIfIncorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        var ingredient = Ingredients.fetchAll()
        ingredient[0].ingredientName = "chocolate"
        ingredient[0].checked = true
        yummlyService.updateData(table: ingredient)
        
        yummlyService.getRecipes { success, recipe in
            XCTAssertFalse(success)
            XCTAssertNil(recipe)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        var ingredient = Ingredients.fetchAll()
        ingredient[0].ingredientName = "chocolate"
        ingredient[0].checked = true
        yummlyService.updateData(table: ingredient)
        
        yummlyService.getRecipes { success, recipe in
            XCTAssertTrue(success)
            XCTAssertNotNil(recipe)
            let recipeName = recipe?.matches?[0].recipeName
            XCTAssertEqual(recipeName, "Simple Skillet Green Beans")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
