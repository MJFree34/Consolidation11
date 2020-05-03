//
//  CardModel.swift
//  Consolidation11
//
//  Created by Matt Free on 4/8/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import Foundation

struct CardModel {
    // MARK: - Properties
    private var cards = [Card]()
    private var cardSet = [Card]()
    private var totalCards: Int
    private var flippedIndex: IndexPath?
    private let cardFrontTypes: [String]
    
    func card(at index: Int) -> Card {
        return cards[index]
    }
    
    func getTotalCards() -> Int {
        return totalCards
    }
    
    func getFlippedIndex() -> IndexPath? {
        return flippedIndex
    }
    
    mutating func setFlippedIndex(to index: IndexPath) {
        flippedIndex = index
    }
    
    mutating func resetFlipIndex() {        
        flippedIndex = nil
    }
    
    mutating func toggleFlip(for index: Int) {
        cards[index].isFlipped.toggle()
    }
    
    mutating func matchCards(index1: Int, index2: Int) -> Bool {
        if cards[index1].frontImageName == cards[index2].frontImageName {
            cards[index1].isMatched = true
            cards[index2].isMatched = true
            return true
        }
        return false
    }
    
    private mutating func setCards() {
        // makes pairs
        cards = cardSet + cardSet
        shuffle()
    }
    
    private mutating func shuffle() {
        cards.shuffle()
        cards.shuffle()
    }
    
    init() {
        // getting all the types of card fronts
        guard let cardFrontsURL = Bundle.main.url(forResource: Constants.FileNames.cardFrontsTXT, withExtension: "txt") else {
            fatalError("Could not find \(Constants.FileNames.cardFrontsTXT).txt in app bundle.")
        }
        guard let cardFrontsString = try? String.init(contentsOf: cardFrontsURL) else {
            fatalError("Could not load \(Constants.FileNames.cardFrontsTXT).txt from app bundle.")
        }
        
        cardFrontTypes = cardFrontsString.components(separatedBy: "\n")
        
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
    mutating func setCardBacks() {
        let backName = UserDefaults.standard.string(forKey: Constants.UDKeys.cardBack) ?? Constants.CardBackNames.blue
        
        for index in 0..<cardSet.count {
            cardSet[index].backImageName = backName
        }
        
        saveCardsToDisk()
    }
    
    mutating func setCardFronts() {
        let cardFrontIndexes = UserDefaults.standard.array(forKey: Constants.UDKeys.cardFrontTags) as! [Int]
        
        cardSet = [Card]()
        
        for index in cardFrontIndexes {
            cardSet.append(Card(frontImageName: cardFrontTypes[index], backImageName: UserDefaults.standard.string(forKey: Constants.UDKeys.cardBack) ?? Constants.CardBackNames.blue, isMatched: false, isFlipped: false))
        }
        
        saveCardsToDisk()
    }
    
    mutating func saveTotalCards() {
        totalCards = UserDefaults.standard.integer(forKey: Constants.UDKeys.cardNumber)
    }
}
