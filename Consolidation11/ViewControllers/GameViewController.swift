//
//  GameViewController.swift
//  Consolidation11
//
//  Created by Matt Free on 3/24/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var backgroundPictures = [UIImage]()
    var cardModel = CardModel()
    
    let defaults = UserDefaults.standard
    
    var currentBackground: UIImage!
    var collectionView: UICollectionView!
    
    var firstLoad = true
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        // creating the collectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.itemSize = CGSize(width: 69, height: 100)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "Card")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        // setting background picture
        resizeBackgrounds()
        currentBackground = backgroundPictures[0]
        view.backgroundColor = UIColor.init(patternImage: currentBackground)
        collectionView.backgroundColor = .clear
        
        // creating customize label
        let customizeLabel = UILabel()
        customizeLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        customizeLabel.backgroundColor = .clear
        
        customizeLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        customizeLabel.font = UIFont(name: "FingerPaint-Regular", size: 36)
        customizeLabel.textAlignment = .center
        customizeLabel.text = "Customize Here:"
        
        customizeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customizeLabel)
        
        // creating bottom buttons
        let customizeBackgroundButton = UIButton(type: .custom)
        customizeBackgroundButton.setImage(UIImage(named: "BackgroundButton"), for: .normal)
        customizeBackgroundButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        customizeBackgroundButton.showsTouchWhenHighlighted = true
        customizeBackgroundButton.addTarget(self, action: #selector(moveToCustomizeBackgroundViewController), for: .touchUpInside)
        customizeBackgroundButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customizeBackgroundButton)
        
        let customizeCardsButton = UIButton(type: .custom)
        customizeCardsButton.setImage(UIImage(named: "CardButton"), for: .normal)
        customizeCardsButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        customizeCardsButton.showsTouchWhenHighlighted = true
        customizeCardsButton.addTarget(self, action: #selector(moveToCustomizeCardsViewController), for: .touchUpInside)
        customizeCardsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customizeCardsButton)
        
        // activating all constraints
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            
            customizeBackgroundButton.widthAnchor.constraint(equalToConstant: 44),
            customizeBackgroundButton.heightAnchor.constraint(equalToConstant: 44),
            customizeBackgroundButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 85),
            customizeBackgroundButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            customizeCardsButton.widthAnchor.constraint(equalToConstant: 44),
            customizeCardsButton.heightAnchor.constraint(equalToConstant: 44),
            customizeCardsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -85),
            customizeCardsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            customizeLabel.widthAnchor.constraint(equalToConstant: view.frame.width),
            customizeLabel.heightAnchor.constraint(equalToConstant: 60),
            customizeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customizeLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10)
        ])
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
        return cardModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as? CardCell else { fatalError("Unable to dequeue a CardCell.") }
        
        cell.setCell(with: cardModel.card(at: indexPath.item))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else { fatalError("Could not find a CardCell") }
        
        // two cards flipped
        if !cardModel.card(at: indexPath.item).isFlipped && !cardModel.card(at: indexPath.item).isMatched {
            if let cardIndexPath = cardModel.getFlippedIndex() {
                if let cell2 = collectionView.cellForItem(at: cardIndexPath) as? CardCell {
                    cardModel.toggleFlip(for: indexPath.item)
                    cell.flip()
                    
                    if cardModel.matchCards(index1: indexPath.item, index2: cardIndexPath.item) {
                        cell.remove()
                        cell2.remove()
                    }
                    
                    // flipping all of these for both match and not match
                    cell.flipBack()
                    cell2.flipBack()
                } else {
                    // for when the cell is offscreen
                    if cardModel.matchCards(index1: indexPath.item, index2: cardIndexPath.item) {
                        cell.remove()
                    }
                    
                    // flipping all of these for both match and not match
                    cell.flipBack()
                }
                
                cardModel.resetFlipIndex()
                cardModel.toggleFlip(for: indexPath.item)
                cardModel.toggleFlip(for: cardIndexPath.item)
            } else {
                // only one card flipped
                cardModel.setFlippedIndex(to: indexPath)
                cardModel.toggleFlip(for: indexPath.item)
                cell.flip()
            }
        }
    }
    
    @objc func moveToCustomizeBackgroundViewController() {
        let vc = CustomizeBackgroundViewController()
        vc.currentBackground = currentBackground
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moveToCustomizeCardsViewController() {
        let vc = CustomizeCardsViewController()
        vc.currentBackground = currentBackground
        navigationController?.pushViewController(vc, animated: true)
    }
}
