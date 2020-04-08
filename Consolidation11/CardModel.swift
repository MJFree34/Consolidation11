//
//  CardModel.swift
//  Consolidation11
//
//  Created by Matt Free on 4/8/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import Foundation

struct CardModel {
    private var cards = [Card]()
    private var cardSet = [Card]()
    private var totalMatches: Int
    
    var count: Int {
        return cards.count
    }
    
    func card(at index: Int) -> Card {
        return cards[index]
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    func matchedCardsIndexes() -> [Int] {
        var indexes = [Int]()
        
        for (index, card) in cards.enumerated() {
            if card.isMatched {
                indexes.append(index)
            }
        }
        
        return indexes
    }
    
    init() {
        // getting cards from UserDefaults
        var cardData: Data
        
        if let savedCards = UserDefaults.standard.data(forKey: "CurrentCards") {
            cardData = savedCards
        } else {
            guard let path = Bundle.main.url(forResource: "initial-cards", withExtension: "json") else { fatalError("Could not find initial cards") }
            cardData = try! Data(contentsOf: path)
        }
        
        let decoder = JSONDecoder()
        cards = (try? decoder.decode([Card].self, from: cardData)) ?? [Card]()
        cardSet = cards
        
        cards += cards // makes it so that there are pairs
        
        // setting the total matches
        if UserDefaults.standard.integer(forKey: "TotalMatches") != 0 {
            totalMatches = UserDefaults.standard.integer(forKey: "TotalMatches")
        } else {
            totalMatches = 16
        }
        
        assert(totalMatches * 2 == count)
        
        // shuffling deck
        shuffle()
    }
}
