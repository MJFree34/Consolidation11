//
//  SmallBackgroundButton.swift
//  Consolidation11
//
//  Created by Matt Free on 5/3/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

/// A button displaying a small background option
class SmallBackgroundButton: UIButton {
    /// Initializes with a standard black outline and a selected blue outline with a specified tag and frame of 150 by 150
    /// - Parameters:
    ///   - imageName: Name of background image
    ///   - tagNumber: Tag number
    init(imageName: String, tagNumber: Int) {
        super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        setImage(UIImage(named: imageName)?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        setImage(UIImage(named: imageName)?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        adjustsImageWhenHighlighted = false
        tag = tagNumber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
