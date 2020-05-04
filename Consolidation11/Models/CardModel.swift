//
//  CardModel.swift
//  Consolidation11
//
//  Created by Matt Free on 4/8/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import Foundation


/// Model containing Cards
struct CardModel {
    // MARK: - Properties
    /// Cards in play
    private var cards = [Card]()
    /// The set of cards
    private var cardSet = [Card]()
    /// Total number of cards
    private var totalCards: Int
    /// Index of only card flipped
    private var flippedIndex: IndexPath?
    /// All of the types of card front image names
    private var cardFrontTypes: [String]
    
    /// Getter for card at specified index in cards
    /// - Parameter index: Index card is located
    /// - Returns: Card at specified index
    func card(at index: Int) -> Card {
        return cards[index]
    }
    
    /// Getter for totalCards
    /// - Returns: Total number of cards
    func getTotalCards() -> Int {
        return totalCards
    }
    
    /// Getter for flippedIndex
    /// - Returns: Index of only card flipped
    func getFlippedIndex() -> IndexPath? {
        return flippedIndex
    }
    
    /// Getter for cardFrontTypes
    /// - Returns: All the types of card front image names
    func getCardFrontTypes() -> [String] {
        return cardFrontTypes
    }
    
    /// Setter for flippedIndex
    /// - Parameter index: Index of only card flipped
    mutating func setFlippedIndex(to index: IndexPath) {
        flippedIndex = index
    }
    
    /// Resets flippedIndex to nil
    mutating func resetFlipIndex() {        
        flippedIndex = nil
    }
    
    /// Toggles flipped for card at specified index in cards
    /// - Parameter index: Index of card to toggle
    mutating func toggleFlip(for index: Int) {
        cards[index].isFlipped.toggle()
    }
    
    /// Checks that both cards' frontImageNames are the same and matches them and returns true, otherwise returns false
    /// - Parameters:
    ///   - index1: Index of first card in cards
    ///   - index2: Index of second card in cards
    /// - Returns: If cards match or not
    mutating func matchCards(index1: Int, index2: Int) -> Bool {
        if cards[index1].frontImageName == cards[index2].frontImageName {
            cards[index1].isMatched = true
            cards[index2].isMatched = true
            return true
        }
        return false
    }
    
    /// Checks all cards to see if all are matched
    /// - Returns: All cards are matched or not
    func allMatched() -> Bool {
        for card in cards {
            if !card.isMatched {
                return false
            }
        }
        
        return true
    }
    
    /// Assigns cards to pairs of the cardSet and shuffles
    private mutating func setCards() {
        cards = cardSet + cardSet
        shuffle()
    }
    
    /// Shuffles the cards twice
    private mutating func shuffle() {
        cards.shuffle()
        cards.shuffle()
    }
    
    /// Sets the properties from saved states in UserDefaults and Disk
    init() {
        // getting all the types of card fronts
        guard let cardFrontsURL = Bundle.main.url(forResource: Constants.FileNames.cardFrontsTXT, withExtension: "txt") else {
            fatalError("Could not find \(Constants.FileNames.cardFrontsTXT).txt in app bundle.")
        }
        guard let cardFrontsString = try? String.init(contentsOf: cardFrontsURL) else {
            fatalError("Could not load \(Constants.FileNames.cardFrontsTXT).txt from app bundle.")
        }
        
        cardFrontTypes = cardFrontsString.components(separatedBy: "\n")
        cardFrontTypes.removeLast() // removes blank 33rd name
        
        // setting the total matches
        if UserDefaults.standard.integer(forKey: Constants.UDKeys.cardNumber) != 0 {
            totalCards = UserDefaults.standard.integer(forKey: Constants.UDKeys.cardNumber)
        } else {
            totalCards = 40
        }
        
        getCardsFromDisk()
        
        assert(totalCards == cards.count)
    }
}

// MARK: - Save Cards
extension CardModel {
    /// Saves cardSet to Disk
    private func saveCardsToDisk() {
        // create url
        let url = Bundle.main.url(forResource: Constants.FileNames.currentCardsJSON, withExtension: "json")
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(cardSet)
            try data.write(to: url!)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Sets cardSet from Disk and sets the cards
    private mutating func getCardsFromDisk() {
        // create url
        let url = Bundle.main.url(forResource: Constants.FileNames.currentCardsJSON, withExtension: "json")
        let decoder = JSONDecoder()
        
        do {
            // retrieve data
            let data = try Data(contentsOf: url!)
            let allCards = try decoder.decode([Card].self, from: data)
            
            cardSet = [Card]()
            
            var i = 0
            
            while i < totalCards / 2 {
                cardSet.append(allCards[i])
                i += 1
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        
        // setting the backs to the correct color
        setCardBacks()
        
        // shuffling and setting the deck
        setCards()
    }
}

// MARK: - Edit Cards
extension CardModel {
    /// Sets all card backs in cardSet to the image name in defaults
    mutating func setCardBacks() {
        let backName = UserDefaults.standard.string(forKey: Constants.UDKeys.cardBack) ?? Constants.CardBackNames.blue
        
        for index in 0..<cardSet.count {
            cardSet[index].backImageName = backName
        }
        
        saveCardsToDisk()
    }
    
    /// Clears cardSet and makes new cards using the saved cardFrontTags in defaults and saves to Disk
    mutating func setCardFronts() {
        let cardFrontIndexes = UserDefaults.standard.array(forKey: Constants.UDKeys.cardFrontTags) as! [Int]
        
        cardSet = [Card]()
        
        for index in cardFrontIndexes {
            cardSet.append(Card(frontImageName: cardFrontTypes[index], backImageName: UserDefaults.standard.string(forKey: Constants.UDKeys.cardBack) ?? Constants.CardBackNames.blue, isMatched: false, isFlipped: false))
        }
        
        saveCardsToDisk()
    }
    
    /// Assigns totalCards to defaults' cardNumber
    mutating func updateTotalCards() {
        totalCards = UserDefaults.standard.integer(forKey: Constants.UDKeys.cardNumber)
    }
    
    /// Starts new game with cards from Disk and totalCards from defaults
    mutating func newGame() {
        updateTotalCards()
        getCardsFromDisk()
        
        assert(totalCards == cards.count)
    }
}
