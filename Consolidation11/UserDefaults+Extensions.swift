//
//  UserDefaults+Extensions.swift
//  Consolidation11
//
//  Created by Matt Free on 5/23/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import Foundation

extension UserDefaults {
    /// Holds all common constant keys
    struct Keys {
        static let background = "Background"
        static let cardBack = "Back"
        static let cardNumber = "NumberOfCards"
        static let cardFrontTags = "CardFrontTags"
    }
    
    /// Resets the standard UserDefaults
    static func reset() {
        if let bundleID = Bundle.main.bundleIdentifier {
            self.standard.removePersistentDomain(forName: bundleID)
        } else {
            print("hweld")
        }
    }
}
