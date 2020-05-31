//
//  MatchingPairsCardLogicTests.swift
//  MatchingPairsTests
//
//  Created by Matt Free on 5/30/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import XCTest
@testable import MatchingPairs

class MatchingPairsCardLogicTests: XCTestCase {
    var cardLogic: CardLogic!
    var cardModel: CardModel!
    var defaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        defaults = UserDefaults.makeClearedInstance()
        defaults.removePersistentDomain(forName: #file)
        
        cardModel = CardModel(defaults: defaults, shouldShuffle: false)
        
        cardLogic = CardLogic()
    }

    override func tearDown() {
        cardModel = nil
        defaults = nil
        cardLogic = nil
        super.tearDown()
    }
    
    func testSelectingFlippedCardDoesNothing() {
        // given
        let flippedIndexPath = IndexPath(item: 0, section: 0)
        cardModel.toggleFlip(for: flippedIndexPath.item)
        
        // when
        XCTAssertTrue(cardModel.card(at: flippedIndexPath.item).isFlipped)
        let returnTuple = cardLogic.cardSelected(cardModel: cardModel, cell2Exists: false, selectedIndexPath: flippedIndexPath)
        
        // then
        XCTAssertFalse(returnTuple.0)
        XCTAssertFalse(returnTuple.1)
        XCTAssertFalse(returnTuple.2)
        XCTAssertFalse(returnTuple.3)
        XCTAssertFalse(returnTuple.4)
        XCTAssertNil(returnTuple.5)
    }
    
    func testSelectingMatchedCardDoesNothing() {
        // given
        let flippedIndexPath = IndexPath(item: 0, section: 0)
        let secondIndex = flippedIndexPath.item + 16
        _ = cardModel.matchCards(index1: flippedIndexPath.item, index2: secondIndex)
        
        // when
        XCTAssertTrue(cardModel.card(at: flippedIndexPath.item).isMatched)
        let returnTuple = cardLogic.cardSelected(cardModel: cardModel, cell2Exists: false, selectedIndexPath: flippedIndexPath)
        
        // then
        XCTAssertFalse(returnTuple.0)
        XCTAssertFalse(returnTuple.1)
        XCTAssertFalse(returnTuple.2)
        XCTAssertFalse(returnTuple.3)
        XCTAssertFalse(returnTuple.4)
        XCTAssertNil(returnTuple.5)
    }
    
    func testOneFlippedCardOnlyFlips() {
        // given
        let flippedIndexPath = IndexPath(item: 0, section: 0)
        
        // when
        XCTAssertFalse(cardModel.card(at: flippedIndexPath.item).isFlipped)
        let returnTuple = cardLogic.cardSelected(cardModel: cardModel, cell2Exists: false, selectedIndexPath: flippedIndexPath)
        
        // then
        XCTAssertTrue(cardModel.card(at: flippedIndexPath.item).isFlipped)
        XCTAssertTrue(returnTuple.0)
        XCTAssertFalse(returnTuple.1)
        XCTAssertFalse(returnTuple.2)
        XCTAssertFalse(returnTuple.3)
        XCTAssertFalse(returnTuple.4)
        XCTAssertNil(returnTuple.5)
        XCTAssertEqual(flippedIndexPath, cardModel.flippedIndex)
    }
    
    func testSecondCardFlippedAndExistsAndDoesMatch() {
        // given
        let firstFlippedIndexPath = IndexPath(item: 0, section: 0)
        let secondIndexPath = IndexPath(item: firstFlippedIndexPath.item + 16, section: 0)
        cardModel.toggleFlip(for: firstFlippedIndexPath.item)
        cardModel.flippedIndex = firstFlippedIndexPath
        
        // when
        XCTAssertTrue(cardModel.card(at: firstFlippedIndexPath.item).isFlipped)
        let returnTuple = cardLogic.cardSelected(cardModel: cardModel, cell2Exists: true, selectedIndexPath: secondIndexPath)
        
        // then
        XCTAssertFalse(cardModel.card(at: firstFlippedIndexPath.item).isFlipped)
        XCTAssertFalse(cardModel.card(at: secondIndexPath.item).isFlipped)
        XCTAssertTrue(cardModel.card(at: firstFlippedIndexPath.item).isMatched)
        XCTAssertTrue(cardModel.card(at: secondIndexPath.item).isMatched)
        XCTAssertTrue(returnTuple.0)
        XCTAssertTrue(returnTuple.1)
        XCTAssertTrue(returnTuple.2)
        XCTAssertTrue(returnTuple.3)
        XCTAssertTrue(returnTuple.4)
        XCTAssertEqual(returnTuple.5, firstFlippedIndexPath)
    }
    
    func testSecondCardFlippedAndExistsAndDoesNotMatch() {
        // given
        let firstFlippedIndexPath = IndexPath(item: 0, section: 0)
        let secondIndexPath = IndexPath(item: 1, section: 0)
        cardModel.toggleFlip(for: firstFlippedIndexPath.item)
        cardModel.flippedIndex = firstFlippedIndexPath
        
        // when
        XCTAssertTrue(cardModel.card(at: firstFlippedIndexPath.item).isFlipped)
        let returnTuple = cardLogic.cardSelected(cardModel: cardModel, cell2Exists: true, selectedIndexPath: secondIndexPath)
        
        // then
        XCTAssertFalse(cardModel.card(at: firstFlippedIndexPath.item).isFlipped)
        XCTAssertFalse(cardModel.card(at: secondIndexPath.item).isFlipped)
        XCTAssertFalse(cardModel.card(at: firstFlippedIndexPath.item).isMatched)
        XCTAssertFalse(cardModel.card(at: secondIndexPath.item).isMatched)
        XCTAssertTrue(returnTuple.0)
        XCTAssertTrue(returnTuple.1)
        XCTAssertTrue(returnTuple.2)
        XCTAssertFalse(returnTuple.3)
        XCTAssertFalse(returnTuple.4)
        XCTAssertEqual(returnTuple.5, firstFlippedIndexPath)
    }
    
    func testSecondCardFlippedAndDoesNotExistAndDoesMatch() {
        // given
        let firstFlippedIndexPath = IndexPath(item: 0, section: 0)
        let secondIndexPath = IndexPath(item: firstFlippedIndexPath.item + 16, section: 0)
        cardModel.toggleFlip(for: firstFlippedIndexPath.item)
        cardModel.flippedIndex = firstFlippedIndexPath
        
        // when
        XCTAssertTrue(cardModel.card(at: firstFlippedIndexPath.item).isFlipped)
        let returnTuple = cardLogic.cardSelected(cardModel: cardModel, cell2Exists: false, selectedIndexPath: secondIndexPath)
        
        // then
        XCTAssertFalse(cardModel.card(at: firstFlippedIndexPath.item).isFlipped)
        XCTAssertFalse(cardModel.card(at: secondIndexPath.item).isFlipped)
        XCTAssertTrue(cardModel.card(at: firstFlippedIndexPath.item).isMatched)
        XCTAssertTrue(cardModel.card(at: secondIndexPath.item).isMatched)
        XCTAssertTrue(returnTuple.0)
        XCTAssertTrue(returnTuple.1)
        XCTAssertFalse(returnTuple.2)
        XCTAssertTrue(returnTuple.3)
        XCTAssertFalse(returnTuple.4)
        XCTAssertEqual(returnTuple.5, firstFlippedIndexPath)
    }
    
    func testSecondCardFlippedAndDoesNotExistAndDoesNotMatch() {
        // given
        let firstFlippedIndexPath = IndexPath(item: 0, section: 0)
        let secondIndexPath = IndexPath(item: 1, section: 0)
        cardModel.toggleFlip(for: firstFlippedIndexPath.item)
        cardModel.flippedIndex = firstFlippedIndexPath
        
        // when
        XCTAssertTrue(cardModel.card(at: firstFlippedIndexPath.item).isFlipped)
        let returnTuple = cardLogic.cardSelected(cardModel: cardModel, cell2Exists: false, selectedIndexPath: secondIndexPath)
        
        // then
        XCTAssertFalse(cardModel.card(at: firstFlippedIndexPath.item).isFlipped)
        XCTAssertFalse(cardModel.card(at: secondIndexPath.item).isFlipped)
        XCTAssertFalse(cardModel.card(at: firstFlippedIndexPath.item).isMatched)
        XCTAssertFalse(cardModel.card(at: secondIndexPath.item).isMatched)
        XCTAssertTrue(returnTuple.0)
        XCTAssertTrue(returnTuple.1)
        XCTAssertFalse(returnTuple.2)
        XCTAssertFalse(returnTuple.3)
        XCTAssertFalse(returnTuple.4)
        XCTAssertEqual(returnTuple.5, firstFlippedIndexPath)
    }
}
