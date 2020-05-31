//
//  CardCollectionViewController.swift
//  Consolidation11
//
//  Created by Matt Free on 5/30/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class CardCollectionViewController: UIViewController {
    /// The CollectionView displaying the cards
    var collectionView: UICollectionView!
    /// The model for the cards
    var cardModel: CardModel
    /// Button to begin a new game
    var newGameButton: NewGameButton!
    /// Logic for matching cards
    var cardLogic = CardLogic()
    
    // MARK: - Setup UI
    init(cardModel: CardModel) {
        self.cardModel = cardModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        addViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cardModel.newGame()
        collectionView.reloadData()
    }
    
    func addViews() {
        addCollectionView()
        addNewGameButton()
        
        collectionView.pinToBounds()
        
        NSLayoutConstraint.activate([
            newGameButton.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            newGameButton.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            newGameButton.widthAnchor.constraint(equalToConstant: 200),
            newGameButton.heightAnchor.constraint(equalToConstant: 88)
        ])
    }
    
    /// Configures the CollectionView with proper layout, sets the delegate and dataSource, has a vertical bounce, has a clear background color to see the background image, and registers the proper CardCell
    func addCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.itemSize = CGSize(width: 69, height: 100)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 150), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: Constants.cardCellReuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    
    /// Creates the newGameButton
    func addNewGameButton() {
        newGameButton = NewGameButton()
        newGameButton.addTarget(self, action: #selector(newGame), for: .touchUpInside)
        view.addSubview(newGameButton)
    }
    
    /// Starts a new game with new cards and hides the button
    @objc func newGame() {
        cardModel.newGame()
        collectionView.reloadData()
        
        newGameButton.hide()
    }
}

// MARK: - CollectionView methods
extension CardCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardModel.cardSetSaver.totalCards
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cardCellReuseIdentifier, for: indexPath) as? CardCell else { fatalError("Unable to dequeue a CardCell.") }
        
        // sets the cell up
        cell.setCell(with: cardModel.card(at: indexPath.item))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else { fatalError("Could not find a CardCell") }
        
        let resultTuple: (flipCell1: Bool, flipBackCell1: Bool, flipBackCell2: Bool, removeCell1: Bool, removeCell2: Bool, flippedIndex: IndexPath?)
        
        if let flippedIndex = cardModel.flippedIndex {
            if let _ = collectionView.cellForItem(at: flippedIndex) as? CardCell {
                resultTuple = cardLogic.cardSelected(cardModel: cardModel, cell2Exists: true, selectedIndexPath: indexPath)
            } else {
                resultTuple = cardLogic.cardSelected(cardModel: cardModel, cell2Exists: false, selectedIndexPath: indexPath)
            }
        } else {
            resultTuple = cardLogic.cardSelected(cardModel: cardModel, cell2Exists: false, selectedIndexPath: indexPath)
        }
        
        if resultTuple.flipCell1 {
            cell.flip()
        }
        
        if resultTuple.flipBackCell1 {
            cell.flipBack()
        }
        
        if resultTuple.removeCell1 {
            cell.remove()
        }
        
        if resultTuple.flipBackCell2 {
            let cell2 = collectionView.cellForItem(at: resultTuple.flippedIndex!) as! CardCell
            cell2.flipBack()
            
            if resultTuple.removeCell2 {
                cell2.remove()
            }
        }
        
        // shows newGameButton if all cards are matched
        if cardModel.allMatched() {
            newGameButton.show()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for indexPath in collectionView.indexPathsForVisibleItems {
            if indexPath == cardLogic.hiddenCardIndexPath {
                // make sure the cell is flipped the correct way and reset hiddenCardIndexPath
                collectionView.reloadItems(at: [indexPath])
                cardLogic.hiddenCardIndexPath = nil
            }
        }
    }
}
