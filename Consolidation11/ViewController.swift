//
//  ViewController.swift
//  Consolidation11
//
//  Created by Matt Free on 3/24/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var backgroundPictures = [UIImage]()
    
    let defaults = UserDefaults.standard
    
    var currentBackground: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.frame = self.view.frame
        collectionView.alwaysBounceVertical = true

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "Card")
        view.addSubview(collectionView)
        
        // setting background picture
        resizeBackgrounds()
        
        currentBackground = backgroundPictures[0]
        
        view.backgroundColor = UIColor.init(patternImage: currentBackground)
        collectionView.backgroundColor = .clear
    }
    
    func resizeBackgrounds() {
        guard defaults.data(forKey: "GreenBackground")?.isEmpty ?? true else {
            addBackgroundPicture(from: defaults.data(forKey: "GreenBackground")!)
            addBackgroundPicture(from: defaults.data(forKey: "BlueBackground")!)
            addBackgroundPicture(from: defaults.data(forKey: "PinkBackground")!)
            addBackgroundPicture(from: defaults.data(forKey: "RedBackground")!)

            return
        }
        
        for i in 0..<4 {
            let render = UIGraphicsImageRenderer(size: CGSize(width: view.bounds.width, height: view.bounds.height))
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
                
                background.draw(in: CGRect(x: -50, y: -50, width: view.bounds.width + 100, height: view.bounds.height + 100))
            }
            
            backgroundPictures.append(image)
            
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { fatalError("Could not save background image") }
            
            defaults.set(imageData, forKey: backgroundName)
        }
    }
    
    func addBackgroundPicture(from data: Data) {
        let image = UIImage(data: data)!
        backgroundPictures.append(image)
    }
}
