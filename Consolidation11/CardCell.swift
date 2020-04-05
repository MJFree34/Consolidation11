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
        return imageView
    }()
    
    var cardFrontImage: UIImageView = {
        let image = UIImage(named: "AppleCard")! // sample back
        let imageView = UIImageView(image: image)
        imageView.isHidden = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    func addViews() {
        contentView.addSubview(cardBackImage)
        contentView.addSubview(cardFrontImage)
        
        NSLayoutConstraint.activate([
            cardBackImage.leftAnchor.constraint(equalTo: leftAnchor),
            cardBackImage.topAnchor.constraint(equalTo: topAnchor),
            cardBackImage.rightAnchor.constraint(equalTo: rightAnchor),
            cardBackImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            cardFrontImage.leftAnchor.constraint(equalTo: leftAnchor),
            cardFrontImage.topAnchor.constraint(equalTo: topAnchor),
            cardFrontImage.rightAnchor.constraint(equalTo: rightAnchor),
            cardFrontImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
