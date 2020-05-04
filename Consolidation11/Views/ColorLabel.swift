//
//  ColorLabel.swift
//  Consolidation11
//
//  Created by Matt Free on 5/3/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

/// A label to describe the background colors
class ColorLabel: UILabel {
    /// Initializes with a standard frame, ClickerScript font, and center text alignment with customizable text color and text
    /// - Parameters:
    ///   - color: The color of the text
    ///   - colorText: The text describing a color
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
