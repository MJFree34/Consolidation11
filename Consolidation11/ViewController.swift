//
//  ViewController.swift
//  Consolidation11
//
//  Created by Matt Free on 3/24/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var backgroundPictures = [UIImage]()
    var currentCards = [UIImage]()
    
    let defaults = UserDefaults.standard
    
    var currentBackground: UIImage!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // creating the collectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.itemSize = CGSize(width: 69, height: 100)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "Card")
        
        // setting background picture
        resizeBackgrounds()
        
        currentBackground = backgroundPictures[0]
        
        view.backgroundColor = UIColor.init(patternImage: currentBackground)
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as? CardCell else { fatalError("Unable to dequeue a CardCell.") }
        
        
        
        return cell
    }
}
