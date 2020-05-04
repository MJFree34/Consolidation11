//
//  CardOptionButton.swift
//  Consolidation11
//
//  Created by Matt Free on 5/3/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

/// Button displaying a card back option
class CardOptionButton: UIButton {
    /// Initializes the image with a normal black border and selected blue border with a specified tag and frame of 69 by 100
    /// - Parameters:
    ///   - imageName: Card back image name
    ///   - tagNumber: Tag number
    init(imageName: String, tagNumber: Int) {
        super.init(frame: CGRect(x: 0, y: 0, width: 69, height: 100))
        setImage(UIImage(named: imageName)?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        setImage(UIImage(named: imageName)?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        adjustsImageWhenHighlighted = false
        tag = tagNumber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
