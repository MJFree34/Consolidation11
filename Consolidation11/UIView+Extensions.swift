//
//  UIView+Extensions.swift
//  Consolidation11
//
//  Created by Matt Free on 5/30/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

extension UIView {
    func pinToBounds() {
        leadingAnchor.constraint(equalTo: superview!.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview!.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview!.bottomAnchor).isActive = true
        topAnchor.constraint(equalTo: superview!.topAnchor).isActive = true
    }
}
