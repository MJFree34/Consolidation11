//
//  BackButton.swift
//  Consolidation11
//
//  Created by Matt Free on 5/3/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

/// Button to go back to GameViewController
class BackButton: UIButton {
    /// Initializes a standard frame of 44 by 44 and the arrow image
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        
        setImage(UIImage(named: Constants.ButtonNames.arrow), for: .normal)
        showsTouchWhenHighlighted = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
