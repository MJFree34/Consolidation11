//
//  MatchingPairsUITests.swift
//  MatchingPairsUITests
//
//  Created by Matt Free on 5/30/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import XCTest

class MatchingPairsUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }
    
    func testSmallBackgroundChanges() {
        // given
        app.buttons["BackgroundButton"].tap()
        let smallBackground = app.scrollViews.children(matching: .other).element(boundBy: 1).children(matching: .button).element(boundBy: 1)
        
        // when
        XCTAssertFalse(smallBackground.isSelected)
        smallBackground.tap()
        
        // then
        XCTAssertTrue(smallBackground.isSelected)
    }
    
    func testCardBackChanges() {
        // given
        app.buttons["BackgroundButton"].tap()
        let cardBack = app.scrollViews.children(matching: .other).element(boundBy: 4).children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 1)
        
        // when
        XCTAssertFalse(cardBack.isSelected)
        cardBack.tap()
        
        // then
        XCTAssertTrue(cardBack.isSelected)
    }
    
    func testCardNumberChanges() {
        // given
        app.buttons["CardButton"].tap()
        let number = app.scrollViews.otherElements.buttons["24"]
        
        // when
        XCTAssertFalse(number.isSelected)
        number.tap()
        
        // then
        XCTAssertTrue(number.isSelected)
    }
}
