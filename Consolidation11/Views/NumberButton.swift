//
//  NumberButton.swift
//  Consolidation11
//
//  Created by Matt Free on 5/3/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

/// The standard number option button
class NumberButton: UIButton {
    /// Initialized with standard normal title color, Kranky font, center textAlignment, and 50-by-50 frame
    /// - Parameters:
    ///   - color: Color of text when selected
    ///   - numberText: The number being displayed
    init(color: UIColor, numberText: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        setTitleColor(.white, for: .normal)
        setTitleColor(color, for: .selected)
        titleLabel?.font = UIFont(name: Constants.FontNames.kranky, size: 30)
        titleLabel?.textAlignment = .center
        setTitle(numberText, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
