//
//  Card.swift
//  Consolidation11
//
//  Created by Matt Free on 4/4/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

struct Card: Codable {
    var frontImageName: String
    var backImageName: String
    var isMatched: Bool {
        return false
    }
    var isFlipped: Bool {
        return false
    }
}
