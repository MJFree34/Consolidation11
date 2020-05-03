//
//  ColorLabel.swift
//  Consolidation11
//
//  Created by Matt Free on 5/3/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class ColorLabel: UILabel {
    init(color: UIColor, colorText: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        textColor = color
        font = UIFont(name: Constants.FontNames.clickerScript, size: 30)
        textAlignment = .center
        text = colorText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
