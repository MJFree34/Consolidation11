//
//  CardCell.swift
//  Consolidation11
//
//  Created by Matt Free on 4/3/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

/// A cell to contain a Card and flip it or hide it accordingly
class CardCell: UICollectionViewCell {
    /// ImageView to contain the Card's back image
    var cardBackImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// ImageView to contain the Card's front image
    var cardFrontImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addViews()
    }
    
    /// Adds the imageViews to fill the entire cell with the frontImage hidden
    func addViews() {
        contentView.addSubview(cardFrontImage)
        contentView.addSubview(cardBackImage)
        
        NSLayoutConstraint.activate([
            cardBackImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardBackImage.topAnchor.constraint(equalTo: topAnchor),
            cardBackImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardBackImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            cardFrontImage.leadingAnchor.constraint(equalTo: cardBackImage.leadingAnchor),
            cardFrontImage.topAnchor.constraint(equalTo: cardBackImage.topAnchor),
            cardFrontImage.trailingAnchor.constraint(equalTo: cardBackImage.trailingAnchor),
            cardFrontImage.bottomAnchor.constraint(equalTo: cardBackImage.bottomAnchor)
        ])
        
        cardFrontImage.alpha = 0
    }
    
    /// Flips the cell from back to front
    func flip() {
        cardFrontImage.alpha = 1
        UIView.transition(from: cardBackImage, to: cardFrontImage, duration: 0.2, options: [.transitionFlipFromLeft, .showHideTransitionViews])
    }
    
    /// Flips the cell from front to back
    func flipBack() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            UIView.transition(from: self!.cardFrontImage, to: self!.cardBackImage, duration: 0.2, options: [.transitionFlipFromRight, .showHideTransitionViews])
        }
    }
    
    /// Flips the cell from front to back in 0.01 seconds
    func flipBackImmediately() {
        UIView.transition(from: cardFrontImage, to: cardBackImage, duration: 0.01, options: [.transitionFlipFromRight, .showHideTransitionViews])
    }
    
    /// Hides the cell completely
    func remove() {
        cardBackImage.alpha = 0
        
        UIView.animate(withDuration: 0.2, delay: 0.5, options: .curveEaseOut, animations: { [weak self] in
            self?.cardFrontImage.alpha = 0
        })
    }
    
    /// Sets the cell's front and back images and displays one or the other based on the matched value as always flipped with the back on top
    /// - Parameter card: Card from the CardModel that specifies the image names and if the Card is matched or not
    func setCell(with card: Card) {
        cardBackImage.image = UIImage(named: card.backImageName)?.imageWithBorder(width: 2, radius: 5, color: .black)
        cardFrontImage.image = UIImage(named: card.frontImageName)?.imageWithBorder(width: 2, radius: 5, color: .black)
        
        if card.isMatched {
            cardBackImage.alpha = 0
        } else {
            cardBackImage.alpha = 1
        }
        
        cardFrontImage.alpha = 0
        
        flipBackImmediately()
    }
}
