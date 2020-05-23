//
//  UIStackViewExtension.swift
//  Consolidation11
//
//  Created by Matt Free on 5/3/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

extension UIStackView {
    /// Initializes a stackView that has center alignment and customizable arrangedSubviews, spacing, axis, and tamic
    /// - Parameters:
    ///   - arrangedSubviews: Views to arrange
    ///   - spacing: Point spacing between subviews
    ///   - axis: Horizontal or vertical
    ///   - tamic: Defines translatesAutoresizingMaskIntoConstraints
    convenience init(arrangedSubviews: [UIView], spacing: CGFloat, axis: NSLayoutConstraint.Axis, tamic: Bool) {
        self.init(arrangedSubviews: arrangedSubviews)
        alignment = .center
        self.spacing = spacing
        self.axis = axis
        translatesAutoresizingMaskIntoConstraints = tamic
    }
}
