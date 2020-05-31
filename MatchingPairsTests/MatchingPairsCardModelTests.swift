//
//  MatchingPairsCardModelTests.swift
//  MatchingPairsTests
//
//  Created by Matt Free on 5/29/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import XCTest
@testable import MatchingPairs

class MatchingPairsCardModelTests: XCTestCase {
    var cardModel: CardModel!
    var defaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        defaults = UserDefaults.makeClearedInstance()
        defaults.removePersistentDomain(forName: #file)
        
        cardModel = CardModel(defaults: defaults, shouldShuffle: false)
    }

    override func tearDown() {
        cardModel = nil
        defaults = nil
        super.tearDown()
    }
    
    func testTogglesFlip() {
        // given
        // all cards not flipped
        
        // when
        XCTAssertFalse(cardModel.card(at: 0).isFlipped)
        cardModel.toggleFlip(for: 0)
        
        // then
        XCTAssertTrue(cardModel.card(at: 0).isFlipped)
    }
    
    func testDoesNotMatchCardsWhenNotMatch() {
        // given
        let index1 = 0
        let index2 = index1 + 1
        
        // when
        XCTAssertFalse(cardModel.allMatched())
        let matched = cardModel.matchCards(index1: index1, index2: index2)
        
        // then
        XCTAssertFalse(matched)
        XCTAssertFalse(cardModel.card(at: index1).isMatched)
        XCTAssertFalse(cardModel.card(at: index2).isMatched)
    }
    
    func testMatchesCardsWhenMatch() {
        // given
        let index1 = 0
        let index2 = index1 + 16
        
        // when
        XCTAssertFalse(cardModel.allMatched())
        let matched = cardModel.matchCards(index1: index1, index2: index2)
        
        // then
        XCTAssertTrue(matched)
        XCTAssertTrue(cardModel.card(at: index1).isMatched)
        XCTAssertTrue(cardModel.card(at: index2).isMatched)
    }
    
    func testAllNotMatched() {
        // when
        // cards not matched
        
        // given
        let matched = cardModel.allMatched()
        
        // then
        XCTAssertFalse(matched)
    }
    
    func testAllMatched() {
        // given
        // all cards are matched
        for i in 0..<16 {
            _ = cardModel.matchCards(index1: i, index2: i + 16)
        }
        
        // when
        let matched = cardModel.allMatched()
        
        // then
        XCTAssertTrue(matched)
    }
    
    func testSetsCardsFromLoadedCardsAndShuffles() {
        // given
        let card1 = Card(frontImageName: "AppleCard", backImageName: "BlueBack", isMatched: false, isFlipped: false)
        
        // when
        // cardModel initializes and setsCards
        XCTAssertEqual(32, cardModel.cardSetSaver.totalCards)
        var sortedCards = [Card]()
        for i in 0..<32 {
            sortedCards.append(cardModel.card(at: i))
        }
        sortedCards.sort { (card1, card2) -> Bool in
            return card1.frontImageName < card2.frontImageName
        }
        
        // then
        XCTAssertEqual(card1, sortedCards[0])
        XCTAssertNotEqual(card1, cardModel.card(at: 0))
    }
}
