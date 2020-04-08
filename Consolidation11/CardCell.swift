//
//  CardCell.swift
//  Consolidation11
//
//  Created by Matt Free on 4/3/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    private var card: Card!
    
    var cardBackImage: UIImageView = {
        let image = UIImage(named: "BlueBack")! // sample image
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var cardFrontImage: UIImageView = {
        let image = UIImage(named: "AppleCard")! // sample back
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
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
    }
    
    func flip() {
        UIView.transition(from: cardBackImage, to: cardFrontImage, duration: 0.2, options: [.transitionFlipFromLeft, .showHideTransitionViews])
    }
    
    func flipBack() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            UIView.transition(from: self!.cardFrontImage, to: self!.cardBackImage, duration: 0.2, options: [.transitionFlipFromRight, .showHideTransitionViews])
        }
    }
    
    func setCard(_ card: Card) {
        self.card = card
    }
    
    func setBackImage() {
        cardBackImage.image = UIImage(named: card.backImageName)
    }
    
    func setFrontImage() {
        cardFrontImage.image = UIImage(named: card.frontImageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
