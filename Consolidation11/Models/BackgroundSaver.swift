//
//  BackgroundSaver.swift
//  Consolidation11
//
//  Created by Matt Free on 5/29/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class BackgroundSaver {
    /// The background displayed
    var currentBackground: UIImage!
    /// The standard UserDefaults
    let defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    /// If this is the first time opening the app, it will render all backgrounds in the proper size for the device and cache them
    func resizeBackgrounds(viewBounds: CGRect) {
        guard defaults.data(forKey: UserDefaults.Keys.greenBackground.rawValue)?.isEmpty ?? true else {
            setCurrentBackground()
            
            return
        }
        
        for i in 0..<4 {
            let render = UIGraphicsImageRenderer(size: CGSize(width: viewBounds.width, height: viewBounds.height))
            let backgroundName: String
            
            switch i {
            case 0:
                backgroundName = "GreenBackground"
            case 1:
                backgroundName = "RedBackground"
            case 2:
                backgroundName = "PinkBackground"
            default: // case 3
                backgroundName = "BlueBackground"
            }
            
            let image = render.image { (context) in
                let background = UIImage(named: backgroundName)!
                
                background.draw(in: CGRect(x: -50, y: -50, width: viewBounds.width + 100, height: viewBounds.height + 100))
            }
            
            let imageData = image.jpegData(compressionQuality: 0.5)!
            
            defaults.set(imageData, forKey: backgroundName)
        }
        
        defaults.set("green", forKey: UserDefaults.Keys.background.rawValue)
        setCurrentBackground()
    }
    
    /// Sets the background from the UserDefaults to the view's backgroundColor
    func setCurrentBackground() {
        switch defaults.string(forKey: UserDefaults.Keys.background.rawValue) {
        case "green":
            currentBackground = UIImage(data: defaults.data(forKey: UserDefaults.Keys.greenBackground.rawValue)!)
        case "red":
            currentBackground = UIImage(data: defaults.data(forKey: UserDefaults.Keys.redBackground.rawValue)!)
        case "blue":
            currentBackground = UIImage(data: defaults.data(forKey: UserDefaults.Keys.blueBackground.rawValue)!)
        default:
            currentBackground = UIImage(data: defaults.data(forKey: UserDefaults.Keys.pinkBackground.rawValue)!)
        }
    }
}
