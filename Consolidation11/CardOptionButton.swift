//
//  CardOptionButton.swift
//  Consolidation11
//
//  Created by Matt Free on 5/3/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class CardOptionButton: UIButton {
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
