//
//  CardModel.swift
//  Consolidation11
//
//  Created by Matt Free on 4/8/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import Foundation

/// Model containing Cards
class CardModel {
    // MARK: - Properties
    /// Cards in play
    private var cards = [Card]()
    /// Index of only card flipped
    var flippedIndex: IndexPath?
    /// Injected UserDefaults
    private let userDefaults: UserDefaults!
    /// Container for cardSet that persists card data
    var cardSetSaver: CardSetSaver!
    
    /// Sets the properties from saved states in UserDefaults and Disk
    init(defaults: UserDefaults) {
        userDefaults = defaults
        
        let totalCards = loadTotalCards()
        
        cardSetSaver = CardSetSaver(totalCards: totalCards, userDefaults: userDefaults)
        
        cardSetSaver.loadCardFrontTypes()
        
        setCardsFromLoadedCards()
    }
    
    /// Getter for card at specified index in cards
    /// - Parameter index: Index card is located
    /// - Returns: Card at specified index
    func card(at index: Int) -> Card {
        return cards[index]
    }
    
    /// Toggles flipped for card at specified index in cards
    /// - Parameter index: Index of card to toggle
    func toggleFlip(for index: Int) {
        cards[index].isFlipped.toggle()
    }
    
    /// Checks that both cards' frontImageNames are the same and matches them and returns true, otherwise returns false
    /// - Parameters:
    ///   - index1: Index of first card in cards
    ///   - index2: Index of second card in cards
    /// - Returns: If cards match or not
    func matchCards(index1: Int, index2: Int) -> Bool {
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
}

// MARK: - Initializing
extension CardModel {
    /// Loads the totalCards from UserDefaults or a default value
    /// - Returns: Total cards value
    private func loadTotalCards() -> Int {
        if userDefaults.integer(forKey: UserDefaults.Keys.cardNumber.rawValue) != 0 {
            return userDefaults.integer(forKey: UserDefaults.Keys.cardNumber.rawValue)
        }
        
        return 32
    }
    
    /// Sets the cards from the loaded cardSet
    private func setCardsFromLoadedCards() {
        cardSetSaver.loadCards()
        setCards()
    }
    
    /// Assigns cards to pairs of the cardSet and shuffles
    private func setCards() {
        cards = cardSetSaver.cardSet + cardSetSaver.cardSet
        shuffle()
    }
    
    /// Shuffles the cards twice
    private func shuffle() {
        cards.shuffle()
        cards.shuffle()
    }
    
    /// Starts new game with cards from Disk and totalCards from defaults
    func newGame() {
        cardSetSaver.fillCardSet()
        setCardsFromLoadedCards()
        
        assert(cardSetSaver.totalCards == cards.count)
    }
}
