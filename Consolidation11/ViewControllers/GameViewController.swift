//
//  GameViewController.swift
//  Consolidation11
//
//  Created by Matt Free on 3/24/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    /// The standard UserDefaults
    let defaults: UserDefaults
    /// The model for the cards
    var cardModel: CardModel
    /// Source for the background
    let backgroundSaver: BackgroundSaver
    /// Button to begin a new game
    var newGameButton: NewGameButton!
    /// Child collectionViewController
    var cardCollectionViewController: CardCollectionViewController!
    
    // MARK: - Setup UI
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.cardModel = CardModel(defaults: self.defaults)
        self.backgroundSaver = BackgroundSaver(defaults: self.defaults)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Makes the contents of the status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundSaver.resizeBackgrounds(viewBounds: view.bounds)
    }
    
    override func loadView() {
        super.loadView()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // loads a new game with the current background
        view.backgroundColor = UIColor.init(patternImage: backgroundSaver.currentBackground)
    }
    
    /// Sets up the entire rendered screen
    func setupView() {
        cardCollectionViewController = CardCollectionViewController(cardModel: cardModel)
        add(cardCollectionViewController)
        
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
            cardCollectionViewController.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardCollectionViewController.collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            cardCollectionViewController.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardCollectionViewController.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            
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
            customizeLabel.topAnchor.constraint(equalTo: cardCollectionViewController.collectionView.bottomAnchor, constant: 10)
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for indexPath in cardCollectionViewController.collectionView.indexPathsForVisibleItems {
            if indexPath == cardCollectionViewController.hiddenCardIndexPath {
                // make sure the cell is flipped the correct way and reset hiddenCardIndexPath
                cardCollectionViewController.collectionView.reloadItems(at: [indexPath])
                cardCollectionViewController.hiddenCardIndexPath = nil
            }
        }
    }
}

// MARK: - Button Methods
extension GameViewController {
    /// Transition to the CustomizeBackgroundViewController
    @objc func moveToCustomizeBackgroundViewController() {
        let vc = CustomizeBackgroundViewController(cardModel: cardModel, backgroundSaver: backgroundSaver)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Transition to the CustomizeCardsViewController
    @objc func moveToCustomizeCardsViewController() {
        let vc = CustomizeCardsViewController(cardModel: cardModel, defaults: defaults, backgroundSaver: backgroundSaver)
        navigationController?.pushViewController(vc, animated: true)
    }
}
