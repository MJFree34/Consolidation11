//
//  CardCell.swift
//  Consolidation11
//
//  Created by Matt Free on 4/3/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
