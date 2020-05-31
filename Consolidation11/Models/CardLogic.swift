//
//  CardLogic.swift
//  Consolidation11
//
//  Created by Matt Free on 5/30/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import Foundation

struct CardLogic {
    /// The IndexPath for an offscreen-matched cell
    var hiddenCardIndexPath: IndexPath?
    
    init() {
        hiddenCardIndexPath = nil
    }
    
    mutating func cardSelected(cardModel: CardModel, cell2Exists: Bool, selectedIndexPath: IndexPath) -> (Bool, Bool, Bool, Bool, Bool, IndexPath?) {
        var returnTuple: (flipCell1: Bool, flipBackCell1: Bool, flipBackCell2: Bool, removeCell1: Bool, removeCell2: Bool, flippedIndex: IndexPath?)
        
        // Make sure the card is neither flipped nor matched already, if so, do nothing
        if !cardModel.card(at: selectedIndexPath.item).isFlipped && !cardModel.card(at: selectedIndexPath.item).isMatched {
            // Check if another card has been flipped
            if let secondCardIndexPath = cardModel.flippedIndex {
                if cell2Exists {
                    // Match the cards if they match
                    if cardModel.matchCards(index1: selectedIndexPath.item, index2: secondCardIndexPath.item) {
                        returnTuple.removeCell1 = true
                        returnTuple.removeCell2 = true
                    } else {
                        returnTuple.removeCell1 = false
                        returnTuple.removeCell2 = false
                    }
                    
                    // Flip both over
                    returnTuple.flipBackCell2 = true
                } else {
                    // The second cell is offscreen
                    // Match the cards if they match
                    if cardModel.matchCards(index1: selectedIndexPath.item, index2: secondCardIndexPath.item) {
                        returnTuple.removeCell1 = true
                    } else {
                        returnTuple.removeCell1 = false
                    }
                    
                    returnTuple.flipBackCell2 = false
                    returnTuple.removeCell2 = false
                    
                    hiddenCardIndexPath = secondCardIndexPath
                }
                
                returnTuple.flipBackCell1 = true
                
                // No more cards are flipped
                returnTuple.flippedIndex = cardModel.flippedIndex
                cardModel.flippedIndex = nil
                cardModel.toggleFlip(for: selectedIndexPath.item)
                cardModel.toggleFlip(for: secondCardIndexPath.item)
            } else {
                // Only one card is flipped
                cardModel.flippedIndex = selectedIndexPath
                returnTuple.flippedIndex = nil
                
                returnTuple.flipBackCell1 = false
                returnTuple.flipBackCell2 = false
                returnTuple.removeCell1 = false
                returnTuple.removeCell2 = false
            }
            
            // Flip the selected card
            cardModel.toggleFlip(for: selectedIndexPath.item)
            returnTuple.flipCell1 = true
        } else {
            returnTuple = (false, false, false, false, false, nil)
        }
        
        return returnTuple
    }
}
