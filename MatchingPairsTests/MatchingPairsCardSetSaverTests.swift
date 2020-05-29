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
        defaults = UserDefaults.makeClearedInstance()
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
    
    func testSavesCardBackAndCardFrontIndexes() {
        // given
        cardSetSaver.loadCardFrontTypes()
        let cardFrontIndexes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        let cardBack = "YellowBack"
        
        // when
        cardSetSaver.saveCardFrontIndexes(cardFrontIndexes)
        cardSetSaver.saveCardBack(cardBack)
        
        // then
        XCTAssertEqual(cardBack, defaults.string(forKey: "Back"), "CardBack is not loaded to defaults correctly")
        XCTAssertEqual(cardFrontIndexes, defaults.array(forKey: "CardFrontTags") as! [Int], "CardFrontTags is not loaded to defaults correctly")
    }
    
    func testSavesTotalCards() {
        // given
        let totalCards = 16
        
        // when
        cardSetSaver.saveTotalCards(totalCards)
        
        // then
        XCTAssertEqual(totalCards, defaults.integer(forKey: "NumberOfCards"), "TotalCards is not loaded to defaults correctly")
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
    
    func testLoadsCustomCardsWithDefaultCardBack() {
        // given
        cardSetSaver.loadCardFrontTypes()
        let card1 = Card(frontImageName: "DogCard", backImageName: "BlueBack", isMatched: false, isFlipped: false)
        let card16 = Card(frontImageName: "ToiletPaperCard", backImageName: "BlueBack", isMatched: false, isFlipped: false)
        let customCardFrontIndexes = [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
        
        // when
        XCTAssertEqual(cardSetSaver.cardSet.count, 0, "CardSet contains cards")
        defaults.set(customCardFrontIndexes, forKey: "CardFrontTags")
        cardSetSaver.loadCards()
        
        // then
        XCTAssertEqual(cardSetSaver.cardSet.count, cardSetSaver.totalCards / 2, "CardSet is not proper length")
        XCTAssertEqual(card1, cardSetSaver.cardSet[0], "CardSet is not loading the correct cards")
        XCTAssertEqual(card16, cardSetSaver.cardSet[15], "CardSet is not loading the correct cards")
    }
    
    func testLoadsCustomCardsWithCustomCardBack() {
        // given
        cardSetSaver.loadCardFrontTypes()
        let cardBack = "YellowBack"
        let card1 = Card(frontImageName: "DogCard", backImageName: cardBack, isMatched: false, isFlipped: false)
        let card16 = Card(frontImageName: "ToiletPaperCard", backImageName: cardBack, isMatched: false, isFlipped: false)
        let customCardFrontIndexes = [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
        
        // when
        XCTAssertEqual(cardSetSaver.cardSet.count, 0, "CardSet contains cards")
        defaults.set(customCardFrontIndexes, forKey: "CardFrontTags")
        defaults.set(cardBack, forKey: "Back")
        cardSetSaver.loadCards()
        
        // then
        XCTAssertEqual(cardSetSaver.cardSet.count, cardSetSaver.totalCards / 2, "CardSet is not proper length")
        XCTAssertEqual(card1, cardSetSaver.cardSet[0], "CardSet is not loading the correct cards")
        XCTAssertEqual(card16, cardSetSaver.cardSet[15], "CardSet is not loading the correct cards")
    }
    
    func testFillsCardSetFromFilledSet() {
        // given
        cardSetSaver.loadCardFrontTypes()
        let card1 = Card(frontImageName: "HeartCard", backImageName: "BlueBack", isMatched: false, isFlipped: false)
        let selectedCardIndexes = [3, 4, 5, 6, 7, 8, 9, 10]
        let totalCards = 16
        cardSetSaver.saveCardFrontIndexes(selectedCardIndexes)
        cardSetSaver.saveTotalCards(totalCards)
        
        // when
        cardSetSaver.fillCardSet()
        
        // then
        XCTAssertEqual(cardSetSaver.cardSet[0], card1)
        XCTAssertEqual(cardSetSaver.cardSet.count, totalCards / 2)
        XCTAssertEqual(selectedCardIndexes, defaults.array(forKey: "CardFrontTags") as! [Int])
    }
    
    func testFillsCardSetFromUnderFilledSet() {
        // given
        cardSetSaver.loadCardFrontTypes()
        let card1 = Card(frontImageName: "BiohazardCard", backImageName: "BlueBack", isMatched: false, isFlipped: false)
        let selectedCardIndexes = [3, 4, 5, 6, 7, 8]
        let filledSelectedCardIndexes = [0, 1, 3, 4, 5, 6, 7, 8]
        let totalCards = 16
        cardSetSaver.saveCardFrontIndexes(selectedCardIndexes)
        cardSetSaver.saveTotalCards(totalCards)
        
        // when
        cardSetSaver.fillCardSet()
        
        // then
        XCTAssertEqual(cardSetSaver.cardSet[6], card1)
        XCTAssertEqual(cardSetSaver.cardSet.count, totalCards / 2)
        XCTAssertEqual(filledSelectedCardIndexes, (defaults.array(forKey: "CardFrontTags") as! [Int]).sorted())
    }
    
    func testFillsCardSetFromOverFilledSet() {
        // given
        cardSetSaver.loadCardFrontTypes()
        let card1 = Card(frontImageName: "FleurDeLisCard", backImageName: "BlueBack", isMatched: false, isFlipped: false)
        let selectedCardIndexes = [3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        let filledSelectedCardIndexes = [5, 6, 7, 8, 9, 10, 11, 12]
        let totalCards = 16
        cardSetSaver.saveCardFrontIndexes(selectedCardIndexes)
        cardSetSaver.saveTotalCards(totalCards)
        
        // when
        cardSetSaver.fillCardSet()
        
        // then
        XCTAssertEqual(cardSetSaver.cardSet[0], card1)
        XCTAssertEqual(cardSetSaver.cardSet.count, totalCards / 2)
        XCTAssertEqual(filledSelectedCardIndexes, defaults.array(forKey: "CardFrontTags") as! [Int])
    }
}
