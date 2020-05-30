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
            setCurrentBackground(nil)
            
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
        
        setCurrentBackground("green")
    }
    
    /// Sets the background to the currentBackground and saves into defaults
    func setCurrentBackground(_ backgroundColor: String?) {
        var backgroundColor = backgroundColor
        if backgroundColor == nil {
            backgroundColor = defaults.string(forKey: UserDefaults.Keys.background.rawValue)!
        }
        
        switch backgroundColor {
        case "green":
            defaults.set("green", forKey: UserDefaults.Keys.background.rawValue)
            currentBackground = UIImage(data: defaults.data(forKey: UserDefaults.Keys.greenBackground.rawValue)!)
        case "red":
            defaults.set("red", forKey: UserDefaults.Keys.background.rawValue)
            currentBackground = UIImage(data: defaults.data(forKey: UserDefaults.Keys.redBackground.rawValue)!)
        case "blue":
            defaults.set("blue", forKey: UserDefaults.Keys.background.rawValue)
            currentBackground = UIImage(data: defaults.data(forKey: UserDefaults.Keys.blueBackground.rawValue)!)
        default:
            defaults.set("pink", forKey: UserDefaults.Keys.background.rawValue)
            currentBackground = UIImage(data: defaults.data(forKey: UserDefaults.Keys.pinkBackground.rawValue)!)
        }
    }
    
    func currentBackgroundColor() -> String {
        return defaults.string(forKey: UserDefaults.Keys.background.rawValue)!
    }
}
