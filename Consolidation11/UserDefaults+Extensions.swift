//
//  UserDefaults+Extensions.swift
//  Consolidation11
//
//  Created by Matt Free on 5/23/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import Foundation

extension UserDefaults {
    /// Holds all constant keys
    enum Keys: String, CaseIterable {
        case background = "Background"
        case cardBack = "Back"
        case cardNumber = "NumberOfCards"
        case cardFrontTags = "CardFrontTags"
        case greenBackground = "GreenBackground"
        case pinkBackground = "PinkBackground"
        case redBackground = "RedBackground"
        case blueBackground = "BlueBackground"
    }
    
    /// Resets the standard UserDefaults
    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }
}
