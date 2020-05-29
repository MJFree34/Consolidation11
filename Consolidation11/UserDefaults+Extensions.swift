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
    
    /// Makes a cleared UserDefaults for a testing class
    static func makeClearedInstance(for fileName: StaticString = #file) -> UserDefaults {
        let className = "\(fileName)".split(separator: ".")[0]
        let suiteName = "com.mattfree.consolidation11.\(className)"

        let defaults = self.init(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
}
