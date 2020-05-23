//
//  UIImageExtension.swift
//  Consolidation11
//
//  Created by Matt Free on 4/11/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

extension UIImage {
    /// Creates an image with a border
    /// - Parameters:
    ///   - width: The width of the border
    ///   - radius: Corner radius of the border
    ///   - color: Color of the border
    /// - Returns: Image with border
    func imageWithBorder(width: CGFloat, radius: CGFloat, color: UIColor) -> UIImage? {
        let newSize = CGSize(width: size.width + width, height: size.height + width)
        
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: newSize))
        imageView.contentMode = .center
        imageView.image = self
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = radius
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        let img = renderer.image { ctx in
            imageView.layer.render(in: ctx.cgContext)
        }
        
        return img
    }
}
