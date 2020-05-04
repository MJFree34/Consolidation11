//
//  TopIcon.swift
//  Consolidation11
//
//  Created by Matt Free on 5/3/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

/// ImageView representing a larger icon on customization screens
class TopIcon: UIImageView {
    /// Initializes with a frame of 100 by 100 and the specified image
    /// - Parameter imageName: Square image to display
    init(imageName: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        image = UIImage(named: Constants.ButtonNames.background)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
