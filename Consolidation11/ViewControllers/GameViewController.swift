//
//  GameViewController.swift
//  Consolidation11
//
//  Created by Matt Free on 3/24/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    /// The model for the cards
    var cardModel = CardModel()
    
    /// The IndexPath for an offscreen-matched cell
    var hiddenCardIndexPath: IndexPath?
    
    /// The standard UserDefaults
    let defaults = UserDefaults.standard
    
    /// The background displayed
    var currentBackground: UIImage!
    
    /// Button to begin a new game
    var newGameButton: NewGameButton!
    
    /// The CollectionView displaying the cards
    var collectionView: UICollectionView!
    
    // MARK: - Setup UI
    
    /// Makes the contents of the status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // loads a new game with the current background
        cardModel.newGame()
        setCurrentBackground()
        collectionView.reloadData()
    }
    
    /// Sets up the entire rendered screen
    func setupView() {
        createCollectionView()
        
        // setting background picture
        resizeBackgrounds()
        
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
    
    /// Configures the CollectionView with proper layout, sets the delegate and dataSource, has a vertical bounce, has a clear background color to see the background image, and registers the proper CardCell
    func createCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.itemSize = CGSize(width: 69, height: 100)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: Constants.cardCellReuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    
    /// If this is the first time opening the app, it will render all backgrounds in the proper size for the device and cache them
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
    
    /// Sets the background from the UserDefaults to the view's backgroundColor
    func setCurrentBackground() {
        switch defaults.string(forKey: UserDefaults.Keys.background) {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for indexPath in collectionView.indexPathsForVisibleItems {
            if indexPath == hiddenCardIndexPath {
                // make sure the cell is flipped the correct way and reset hiddenCardIndexPath
                collectionView.reloadItems(at: [indexPath])
                hiddenCardIndexPath = nil
            }
        }
    }
}

// MARK: - CollectionView methods
extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardModel.getTotalCards()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cardCellReuseIdentifier, for: indexPath) as? CardCell else { fatalError("Unable to dequeue a CardCell.") }
        
        // sets the cell up
        cell.setCell(with: cardModel.card(at: indexPath.item))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else { fatalError("Could not find a CardCell") }
        
        // selected card is not flipped nor matched
        if !cardModel.card(at: indexPath.item).isFlipped && !cardModel.card(at: indexPath.item).isMatched {
            // there has been another card flipped
            if let cardIndexPath = cardModel.getFlippedIndex() {
                // flips selected cell and card
                cardModel.toggleFlip(for: indexPath.item)
                cell.flip()
                
                // other cell is visible that is flipped
                if let cell2 = collectionView.cellForItem(at: cardIndexPath) as? CardCell {
                    // match the cards if they match
                    if cardModel.matchCards(index1: indexPath.item, index2: cardIndexPath.item) {
                        cell.remove()
                        cell2.remove()
                    }
                    
                    // flips both over
                    cell.flipBack()
                    cell2.flipBack()
                } else { // the second cell is offscreen
                    // match the cards if they match
                    if cardModel.matchCards(index1: indexPath.item, index2: cardIndexPath.item) {
                        cell.remove()
                    }
                    
                    // flipping all of these for both match and not match
                    cell.flipBack()
                    
                    // set this to know of a hidden card in the future
                    hiddenCardIndexPath = cardIndexPath
                }
                
                // no more cards are flipped
                cardModel.resetFlipIndex()
                cardModel.toggleFlip(for: indexPath.item)
                cardModel.toggleFlip(for: cardIndexPath.item)
            } else { // only one card flipped
                // set the flippedIndex to this indexPath and flip the card and cell
                cardModel.setFlippedIndex(to: indexPath)
                cardModel.toggleFlip(for: indexPath.item)
                cell.flip()
            }
        }
        
        // shows newGameButton if all cards are matched
        if cardModel.allMatched() {
            newGameButton.show()
        }
    }
}

// MARK: - Button Methods
extension GameViewController {
    /// Starts a new game with new cards and hides the button
    @objc func newGame() {
        cardModel.newGame()
        collectionView.reloadData()
        
        newGameButton.hide()
    }
    
    /// Transition to the CustomizeBackgroundViewController
    @objc func moveToCustomizeBackgroundViewController() {
        let vc = CustomizeBackgroundViewController()
        vc.currentBackground = currentBackground
        vc.cardModel = cardModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Transition to the CustomizeCardsViewController
    @objc func moveToCustomizeCardsViewController() {
        let vc = CustomizeCardsViewController()
        vc.currentBackground = currentBackground
        vc.cardModel = cardModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
