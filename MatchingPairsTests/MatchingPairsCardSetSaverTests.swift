//
//  MatchingPairsCardSetSaverTests.swift
//  MatchingPairsTests
//
//  Created by Matt Free on 5/25/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import XCTest
@testable import MatchingPairs

class MatchingPairsCardSetSaverTests: XCTestCase {
    var cardSetSaver: CardSetSaver!
    var defaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: #file)
        defaults.removePersistentDomain(forName: #file)
        
        cardSetSaver = CardSetSaver(totalCards: 32, userDefaults: defaults)
    }

    override func tearDown() {
        cardSetSaver = nil
        defaults = nil
        super.tearDown()
    }
    
    func testLoadsCardFrontTypes() {
        // given
        let cardFrontTypes = ["BiohazardCard", "TargetCard", "CrossCard", "HeartCard", "BasketballCard", "FleurDeLisCard", "TulipCard", "ImperialCard", "RebelCard", "SnowflakeCard", "AtomCard", "AppleCard", "BookCard", "CowboyHatCard", "SunglassesCard", "USFlagCard", "DogCard", "FlowerCard", "PalmCard", "BagelCard", "MountainCard", "PurpleCard", "SunsetCard", "TurtleCard", "CarCard", "MotorcycleCard", "CatCard", "WaterfallCard", "RoadCard", "TempleCard", "StorkCard", "ToiletPaperCard"]
        
        // when
        XCTAssertNil(cardSetSaver.cardFrontTypes)
        cardSetSaver.loadCardFrontTypes()
        
        // then
        XCTAssertEqual(cardFrontTypes, cardSetSaver.cardFrontTypes, "CardSetSaver is not loading cardFrontTypes correctly")
    }
    
    func testLoadsTotalCardsDefault() {
        // given
        let cardModel = CardModel(defaults: defaults)

        // when
        // cardModel initializes cardSetSaver

        // then
        XCTAssertEqual(cardModel.cardSetSaver.totalCards, 32, "CardModel is not initializing cardSetSaver with default totalCard value")
    }

    func testLoadsTotalCardsWithCardNumberInDefaults() {
        // given
        defaults.set(8, forKey: "NumberOfCards")
        defaults.set([0, 1, 2, 3], forKey: "CardFrontTags")
        
        // when
        let cardModel = CardModel(defaults: defaults)

        // then
        XCTAssertEqual(cardModel.cardSetSaver.totalCards, 8, "CardModel is not initialized cardSetSaver with correct totalCards from defaults")
    }

    func testSetsCards() {
        // given
        cardSetSaver.loadCardFrontTypes()
        let cardFrontIndexes = [0, 1, 2, 3]
        let cardBack = "GreenBack"
        let card1 = Card(frontImageName: "BiohazardCard", backImageName: "GreenBack", isMatched: false, isFlipped: false)
        
        // when
        XCTAssertEqual(cardSetSaver.cardSet.count, 0, "CardSet contains cards")
        cardSetSaver.setCards(cardFrontIndexes: cardFrontIndexes, cardBack: cardBack)
        
        // then
        XCTAssertEqual(cardSetSaver.cardSet.count, 4, "CardSet is not the correct length")
        XCTAssertEqual(cardSetSaver.cardSet[0], card1, "CardSet is not loading the correct cards from indexes")
    }
    
    func testLoadsDefaultCards() {
        // given
        cardSetSaver.loadCardFrontTypes()
        let card1 = Card(frontImageName: "BiohazardCard", backImageName: "BlueBack", isMatched: false, isFlipped: false)

        // when
        XCTAssertEqual(cardSetSaver.cardSet.count, 0, "CardSet contains cards")
        cardSetSaver.loadCards()

        // then
        XCTAssertEqual(16, cardSetSaver.cardSet.count, "CardSet is not the correct length")
        XCTAssertEqual(card1, cardSetSaver.cardSet[0], "CardSet is not loading the correct cards")
    }
    
    func testSavesCards() {
        // given
        cardSetSaver.loadCardFrontTypes()
        let cardFrontIndexes = [0, 1, 2, 3, 4, 5, 6, 7]
        let cardBack = "YellowBack"
        let totalCards = 16
        
        // when
        cardSetSaver.saveCards(cardFrontIndexes: cardFrontIndexes, cardBack: cardBack, totalCards: totalCards)
        
        // then
        XCTAssertEqual(cardFrontIndexes, defaults.array(forKey: "CardFrontTags") as? [Int] ?? [])
        XCTAssertEqual(cardBack, defaults.string(forKey: "Back"))
        XCTAssertEqual(totalCards, defaults.integer(forKey: "NumberOfCards"))
        XCTAssertEqual(totalCards, cardSetSaver.totalCards)
    }
}
