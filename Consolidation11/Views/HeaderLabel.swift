//
//  HeaderLabel.swift
//  Consolidation11
//
//  Created by Matt Free on 5/3/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

/// Label for each header of customization
class HeaderLabel: UILabel {
    /// Initializes based on standard frame, textColor, Courgette font, and center textAlignment and specified title
    /// - Parameter title: Text to display in the header
    init(title: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        textColor = .white
        font = UIFont(name: Constants.FontNames.courgette, size: 36)
        textAlignment = .center
        text = title
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
