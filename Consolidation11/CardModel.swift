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
    private var totalCards: Int
    private var flippedIndex: IndexPath?
    
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
    
    mutating func shuffle() {
        cards.shuffle()
        cards.shuffle()
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
        if UserDefaults.standard.integer(forKey: "NumberOfCards") != 0 {
            totalCards = UserDefaults.standard.integer(forKey: "NumberOfCards")
        } else {
            totalCards = 0
        }
        
        assert(totalCards == count)
        
        // shuffling deck
        shuffle()
    }
}
