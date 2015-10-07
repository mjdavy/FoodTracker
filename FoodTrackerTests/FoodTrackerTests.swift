//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Davy, Martin on 9/28/15.
//  Copyright © 2015 Mandi. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase
{
    
    // Test to confirm that the Meal initializer returns when no name or a negative rating is provided
    func testMealInitialization()
    {
        // success case
        let potentialItem =  Meal(name: "Newest Meal", photo: nil, rating: 5)
        XCTAssertNotNil(potentialItem)
        
        // Failure cases.
        let noName = Meal(name: "", photo: nil, rating: 0)
        XCTAssertNil(noName, "Empty name is invalid")
        
        let badRating = Meal(name: "Really bad rating", photo: nil, rating: -1)
        XCTAssertNil(badRating, "Negative ratings are invalid, be positive")    }
    
    
}
