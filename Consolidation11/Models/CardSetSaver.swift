//
//  CardSetSaver.swift
//  Consolidation11
//
//  Created by Matt Free on 5/24/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import Foundation

/// Model for persisting and resetting the cardSet
struct CardSetSaver {
    /// The set of cards
    private(set) var cardSet = [Card]()
    /// All of the types of card front image names
    private(set) var cardFrontTypes: [String]!
    /// Total number of cards
    private(set) var totalCards: Int
    /// Injected UserDefaults
    private let userDefaults: UserDefaults!
    
    /// Initializes the saver
    /// - Parameters:
    ///   - totalCards: Selected total number of cards
    ///   - userDefaults: Injected UserDefaults
    init(totalCards: Int, userDefaults: UserDefaults) {
        self.totalCards = totalCards
        self.userDefaults = userDefaults
    }
    
    /// Loads the cardFrontTypes from the Bundle
    mutating func loadCardFrontTypes() {
        guard let cardFrontsURL = Bundle.main.url(forResource: Constants.FileNames.cardFrontsTXT, withExtension: "txt") else {
            fatalError("Cannot find \(Constants.FileNames.cardFrontsTXT)")
        }
        
        let cardFrontsString: String
        do {
            cardFrontsString = try String.init(contentsOf: cardFrontsURL)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        var cardFronts = cardFrontsString.components(separatedBy: "\n")
        cardFronts.removeLast() // removes blank 33rd name
        
        cardFrontTypes = cardFronts
    }
    
    /// Saves cardFrontIndexes in UserDefaults and resets the cardSet
    /// - Parameter cardFrontIndexes: Indexes of the CardFronts selected
    mutating func saveCardFrontIndexes(_ cardFrontIndexes: [Int]) {
        userDefaults.set(cardFrontIndexes, forKey: UserDefaults.Keys.cardFrontTags.rawValue)
        setCards(cardFrontIndexes: cardFrontIndexes, cardBack: userDefaults.string(forKey: UserDefaults.Keys.cardBack.rawValue) ?? Constants.CardBackNames.blue)
    }
    
    /// Saves cardBack in UserDefaults and saves cardFrontIndexes from UserDefaults
    /// - Parameter cardBack: Selected cardBack
    mutating func saveCardBack(_ cardBack: String) {
        userDefaults.set(cardBack, forKey: UserDefaults.Keys.cardBack.rawValue)
        saveCardFrontIndexes(userDefaults.array(forKey: UserDefaults.Keys.cardFrontTags.rawValue) as! [Int])
    }
    
    /// Saves totalCards in UserDefaults and sets the stored totalCards to that value
    /// - Parameter totalCards: Selected totalCards
    mutating func saveTotalCards(_ totalCards: Int) {
        userDefaults.set(totalCards, forKey: UserDefaults.Keys.cardNumber.rawValue)
        self.totalCards = totalCards
    }
    
    /// Loads cardSet with standard state or customized state
    mutating func loadCards() {
        if let cardFrontTags = userDefaults.array(forKey: UserDefaults.Keys.cardFrontTags.rawValue) as? [Int] {
            let cardBack = userDefaults.string(forKey: UserDefaults.Keys.cardBack.rawValue) ?? Constants.CardBackNames.blue
            setCards(cardFrontIndexes: cardFrontTags, cardBack: cardBack)
        } else {
            let cardFrontTags = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
            let cardBack = userDefaults.string(forKey: UserDefaults.Keys.cardBack.rawValue) ?? Constants.CardBackNames.blue
            saveCardFrontIndexes(cardFrontTags)
            saveCardBack(cardBack)
        }
        
        if userDefaults.integer(forKey: UserDefaults.Keys.cardNumber.rawValue) != 0 {
            totalCards = userDefaults.integer(forKey: UserDefaults.Keys.cardNumber.rawValue)
        } else {
            saveTotalCards(32)
        }
    }
    
    /// Fills the cardSet
    /// - Parameters:
    ///   - cardFrontIndexes: Indexes of the selected cardFronts
    ///   - cardBack: Selected card back
    mutating func setCards(cardFrontIndexes: [Int], cardBack: String) {
        cardSet = [Card]()
        
        for index in cardFrontIndexes {
            cardSet.append(Card(frontImageName: cardFrontTypes[index], backImageName: cardBack, isMatched: false, isFlipped: false))
        }
    }
    
    /// Curtails or adds to the card front choices depending on how many the user chose as well as saving that to the cardModel and the selectedCardTags to the defaults
    mutating func fillCardSet() {
        var selectedCardIndexes = userDefaults.array(forKey: UserDefaults.Keys.cardFrontTags.rawValue) as! [Int]
        
        if selectedCardIndexes.count < totalCards / 2 {
            // fills space up to amount of cards necessary in tags
            while selectedCardIndexes.count < totalCards / 2 || selectedCardIndexes.isEmpty {
                var i = 0
                while selectedCardIndexes.contains(i) {
                    i += 1
                }
                selectedCardIndexes.append(i)
            }
        } else {
            while selectedCardIndexes.count > totalCards / 2 {
                selectedCardIndexes.removeFirst()
            }
        }
        
        saveCardFrontIndexes(selectedCardIndexes)
    }
}
