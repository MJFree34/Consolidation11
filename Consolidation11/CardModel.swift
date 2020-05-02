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
    
    var count: Int {
        return cards.count
    }
    
    func card(at index: Int) -> Card {
        return cards[index]
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
        guard let cardFrontsURL = Bundle.main.url(forResource: "card-fronts", withExtension: "txt") else {
            fatalError("Could not find card-fronts.txt in app bundle.")
        }
        guard let cardFrontsString = try? String.init(contentsOf: cardFrontsURL) else {
            fatalError("Could not load card-fronts.txt from app bundle.")
        }
        
        cardFrontTypes = cardFrontsString.components(separatedBy: "\n")
        
        // setting the total matches
        if UserDefaults.standard.integer(forKey: "NumberOfCards") != 0 {
            totalCards = UserDefaults.standard.integer(forKey: "NumberOfCards")
        } else {
            totalCards = 40
        }
        
        getCardsFromDisk()
        
        assert(totalCards == count)
    }
}

// MARK: - Save Cards
extension CardModel {
    private func saveCardsToDisk() {
        // create url
        let url = Bundle.main.url(forResource: "current-cards", withExtension: "json")
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
        let url = Bundle.main.url(forResource: "current-cards", withExtension: "json")
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
        // shuffling and setting the deck
        setCards()
    }
}

// MARK: - Edit Cards
extension CardModel {
    mutating func setCardBacks(to backName: String) {
        for index in 0..<cardSet.count {
            cardSet[index].backImageName = backName
        }
        
        saveCardsToDisk()
    }
    
    mutating func setCardFronts() {
        let cardFrontIndexes = UserDefaults.standard.array(forKey: "CardFrontTags") as! [Int]
        
        cardSet = [Card]()
        
        for index in cardFrontIndexes {
            cardSet.append(Card(frontImageName: cardFrontTypes[index], backImageName: UserDefaults.standard.string(forKey: "Back") ?? "BlueBack", isMatched: false, isFlipped: false))
        }
        
        saveCardsToDisk()
    }
    
    mutating func saveTotalCards() {
        totalCards = UserDefaults.standard.integer(forKey: "Number of Cards")
    }
}
