//
//  GameViewController.swift
//  Consolidation11
//
//  Created by Matt Free on 3/24/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var cardModel = CardModel()
    var hiddenCardIndexPath: IndexPath?
    
    let defaults = UserDefaults.standard
    
    var currentBackground: UIImage!
    var newGameButton: NewGameButton!
    
    var collectionView: UICollectionView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        cardModel.newGame()
        setCurrentBackground()
        collectionView.reloadData()
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
        
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: Constants.cardCellReuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        // setting background picture
        resizeBackgrounds()
        collectionView.backgroundColor = .clear
        
        // creating newGameButton
        newGameButton = NewGameButton()
        newGameButton.addTarget(self, action: #selector(newGame), for: .touchUpInside)
        view.addSubview(newGameButton)
        
        // creating customize label
        let customizeLabel = UILabel()
        customizeLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        customizeLabel.backgroundColor = .clear
        
        customizeLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        customizeLabel.font = UIFont(name: Constants.FontNames.fingerPaint, size: 36)
        customizeLabel.textAlignment = .center
        customizeLabel.text = "Customize Here:"
        
        customizeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customizeLabel)
        
        // creating bottom buttons
        let customizeBackgroundButton = UIButton(type: .custom)
        customizeBackgroundButton.setImage(UIImage(named: Constants.ButtonNames.background), for: .normal)
        customizeBackgroundButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        customizeBackgroundButton.showsTouchWhenHighlighted = true
        customizeBackgroundButton.addTarget(self, action: #selector(moveToCustomizeBackgroundViewController), for: .touchUpInside)
        customizeBackgroundButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customizeBackgroundButton)
        
        let customizeCardsButton = UIButton(type: .custom)
        customizeCardsButton.setImage(UIImage(named: Constants.ButtonNames.card), for: .normal)
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
            
            newGameButton.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            newGameButton.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            newGameButton.widthAnchor.constraint(equalToConstant: 200),
            newGameButton.heightAnchor.constraint(equalToConstant: 88),
            
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
        guard defaults.data(forKey: Constants.BackgroundNames.green)?.isEmpty ?? true else {
            setCurrentBackground()
            
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
            
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { fatalError("Could not save background image") }
            
            defaults.set(imageData, forKey: backgroundName)
        }
        
        currentBackground = UIImage(data: defaults.data(forKey: Constants.BackgroundNames.green)!)
    }
    
    func setCurrentBackground() {
        switch defaults.string(forKey: Constants.UDKeys.background) {
        case "green":
            currentBackground = UIImage(data: defaults.data(forKey: Constants.BackgroundNames.green)!)
        case "red":
            currentBackground = UIImage(data: defaults.data(forKey: Constants.BackgroundNames.red)!)
        case "blue":
            currentBackground = UIImage(data: defaults.data(forKey: Constants.BackgroundNames.blue)!)
        default:
            currentBackground = UIImage(data: defaults.data(forKey: Constants.BackgroundNames.pink)!)
        }
        
        view.backgroundColor = UIColor.init(patternImage: currentBackground)
    }
    
    @objc func newGame() {
        cardModel.newGame()
        collectionView.reloadData()
        
        newGameButton.hide()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardModel.getTotalCards()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cardCellReuseIdentifier, for: indexPath) as? CardCell else { fatalError("Unable to dequeue a CardCell.") }
        
        cell.setCell(with: cardModel.card(at: indexPath.item))
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for indexPath in collectionView.indexPathsForVisibleItems {
            if indexPath == hiddenCardIndexPath {
                // make sure the cell is flipped the correct way and reset hiddenCardIndexPath
                collectionView.reloadItems(at: [indexPath])
                hiddenCardIndexPath = nil
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else { fatalError("Could not find a CardCell") }
        
        // two cards flipped
        if !cardModel.card(at: indexPath.item).isFlipped && !cardModel.card(at: indexPath.item).isMatched {
            if let cardIndexPath = cardModel.getFlippedIndex() {
                cardModel.toggleFlip(for: indexPath.item)
                cell.flip()
                
                if let cell2 = collectionView.cellForItem(at: cardIndexPath) as? CardCell {
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
                    
                    hiddenCardIndexPath = cardIndexPath
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
        
        if cardModel.allMatched() {
            newGameButton.show()
        }
    }
    
    @objc func moveToCustomizeBackgroundViewController() {
        let vc = CustomizeBackgroundViewController()
        vc.currentBackground = currentBackground
        vc.cardModel = cardModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moveToCustomizeCardsViewController() {
        let vc = CustomizeCardsViewController()
        vc.currentBackground = currentBackground
        vc.cardModel = cardModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
