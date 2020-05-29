//
//  CustomizeCardsViewController.swift
//  Consolidation11
//
//  Created by Matt Free on 4/5/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class CustomizeCardsViewController: UIViewController {
    /// The background displayed
    var currentBackground: UIImage
    /// The model for the cards
    var cardModel: CardModel
    /// The options for number of displayable cards
    var numberOptions = [NumberButton]()
    /// The options for card fronts
    var cardOptions = [CardOptionButton]()
    /// The header of the card fronts section that changes based on the number of cards selected from numberOptions
    var frontsTitleLabel: HeaderLabel!
    /// The indexes of the selected card fronts in the cardOptions array
    var selectedCardTags = [Int]()
    /// The standard UserDefaults
    var defaults: UserDefaults
    
    init(cardModel: CardModel, defaults: UserDefaults, currentBackground: UIImage) {
        self.currentBackground = currentBackground
        self.cardModel = cardModel
        self.defaults = defaults
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    /// Makes the contents of the status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectSavedNumberOption()
        selectCardFrontsFromSavedTags()
    }
    
    override func loadView() {
        super.loadView()
        
        setupView()
    }
    
    /// Sets up the entire rendered screen
    func setupView() {
        // setting background pic
        view.backgroundColor = UIColor.init(patternImage: currentBackground)
        
        // giving the ability to swipe from the left of screen to pop to rootView
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        // creating scrollView
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: view.bounds.width - 16, height: 1300)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // creating backButton
        let backButton = BackButton()
        backButton.addTarget(self, action: #selector(moveToGameViewController), for: .touchUpInside)
        scrollView.addSubview(backButton)
        
        // creating the card logo at the top
        let cardIcon = TopIcon(imageName: Constants.ButtonNames.card)
        scrollView.addSubview(cardIcon)
        
        // creating the numberOfCards title label
        let numberOfCardsTitleLabel = HeaderLabel(title: "Number of Cards:")
        scrollView.addSubview(numberOfCardsTitleLabel)
        
        createNumberOptions()
        
        // creating the numbers' stackView
        let numbersStackView = UIStackView(arrangedSubviews: [numberOptions[0], numberOptions[1], numberOptions[2], numberOptions[3], numberOptions[4]], spacing: 30, axis: .horizontal, tamic: false)
        scrollView.addSubview(numbersStackView)
        
        // creating the fronts label
        frontsTitleLabel = HeaderLabel(title: "Fronts (Pick 12):")
        scrollView.addSubview(frontsTitleLabel)
        
        createCardOptions()
        
        // creating the verticalStackView to hold the stackViews
        let cardStackView = UIStackView(arrangedSubviews: [], spacing: 20, axis: .vertical, tamic: false)
        scrollView.addSubview(cardStackView)
        
        // creating each row a horizontalStackView to hold the cards
        for i in 1...8 {
            let rowStackView = UIStackView(arrangedSubviews: [cardOptions[i * 4 - 4], cardOptions[i * 4 - 3], cardOptions[i * 4 - 2], cardOptions[i * 4 - 1]], spacing: 20, axis: .horizontal, tamic: true)
            
            // adding the row to the verticalStackView
            cardStackView.addArrangedSubview(rowStackView)
        }
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20-8),
            backButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40-8),
            
            cardIcon.widthAnchor.constraint(equalToConstant: 100),
            cardIcon.heightAnchor.constraint(equalToConstant: 100),
            cardIcon.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            cardIcon.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30-8),
            
            numberOfCardsTitleLabel.widthAnchor.constraint(equalToConstant: 300),
            numberOfCardsTitleLabel.heightAnchor.constraint(equalToConstant: 50),
            numberOfCardsTitleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            numberOfCardsTitleLabel.topAnchor.constraint(equalTo: cardIcon.bottomAnchor, constant: 5),
            
            numbersStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            numbersStackView.topAnchor.constraint(equalTo: numberOfCardsTitleLabel.bottomAnchor, constant: 5),
            
            frontsTitleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            frontsTitleLabel.topAnchor.constraint(equalTo: numbersStackView.bottomAnchor, constant: 10),
            
            cardStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            cardStackView.topAnchor.constraint(equalTo: frontsTitleLabel.bottomAnchor, constant: 5),
            cardStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10-8)
        ])
    }
    
    /// Selects the numberOption matching the cardNumber in the UserDefaults and sets the frontsTitleLabel's text to pick the right amount of cards
    func selectSavedNumberOption() {
        switch cardModel.cardSetSaver.totalCards {
        case 8:
            numberOptions[0].isSelected = true
        case 16:
            numberOptions[1].isSelected = true
        case 24:
            numberOptions[2].isSelected = true
        case 32:
            numberOptions[3].isSelected = true
        default:
            numberOptions[4].isSelected = true
        }
        
        frontsTitleLabel.text = "Fronts (Pick \(cardModel.cardSetSaver.totalCards / 2)):"
    }
    
    /// Sets the selectedCardTags to the saved version from UserDefaults and selects the cards using the tags
    func selectCardFrontsFromSavedTags() {
        guard let cardFrontTags = defaults.array(forKey: UserDefaults.Keys.cardFrontTags.rawValue) as? [Int] else { fatalError("FrontCardTags should have a default value filled in CardSetSaver") }
        
        selectedCardTags = cardFrontTags
        
        for index in selectedCardTags {
            cardOptions[index].isSelected = true
        }
    }
    
    /// Creates all of the number option buttons and appends them to numberOptions
    func createNumberOptions() {
        let eightOption = NumberButton(color: UIColor(red: 0, green: 0.94, blue: 1, alpha: 1), numberText: "8")
        numberOptions.append(eightOption)
        
        let sixteenOption = NumberButton(color: UIColor(red: 1, green: 0.9, blue: 0, alpha: 1), numberText: "16")
        numberOptions.append(sixteenOption)
        
        let twentyFourOption = NumberButton(color: UIColor(red: 0.56, green: 1, blue: 0, alpha: 1), numberText: "24")
        numberOptions.append(twentyFourOption)
        
        let thirtyTwoOption = NumberButton(color: UIColor(red: 0.827, green: 1, blue: 0.333, alpha: 1), numberText: "32")
        numberOptions.append(thirtyTwoOption)
        
        let fortyOption = NumberButton(color: UIColor(red: 1, green: 0.584, blue: 0.2, alpha: 1), numberText: "40")
        numberOptions.append(fortyOption)
        
        // adds target to all the options
        for option in numberOptions {
            option.addTarget(self, action: #selector(saveNumberOfCards), for: .touchUpInside)
        }
    }
    
    /// Creates all of the card option buttons and appends them to cardOptions using the cardModel's cardFrontTypes from card-fronts.txt
    func createCardOptions() {
        for (index, cardFrontName) in cardModel.cardSetSaver.cardFrontTypes.enumerated() {
            let cardButton = CardOptionButton(imageName: cardFrontName, tagNumber: index)
            cardButton.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
            cardOptions.append(cardButton)
        }
    }
}

// MARK: - Saving and Selecting
extension CustomizeCardsViewController {
    /// Saves the number of cards to the cardModel and defaults, selects the button tapped, and adjusts the frontsTitleLabel's text accordingly
    /// - Parameter sender: The number option button that was tapped and is to be selected as the current number of cards to be displayed
    @objc func saveNumberOfCards(_ sender: UIButton) {
        // unselects all number options
        for option in numberOptions {
            option.isSelected = false
        }
        
        let totalCards: Int
        
        switch sender.title(for: .normal) {
        case "8":
            totalCards = 8
            numberOptions[0].isSelected = true
        case "16":
            totalCards = 16
            numberOptions[1].isSelected = true
        case "24":
            totalCards = 24
            numberOptions[2].isSelected = true
        case "32":
            totalCards = 32
            numberOptions[3].isSelected = true
        default:
            totalCards = 40
            numberOptions[4].isSelected = true
        }
        
        cardModel.cardSetSaver.saveTotalCards(totalCards)
        
        frontsTitleLabel.text = "Fronts (Pick \(cardModel.cardSetSaver.totalCards / 2)):"
    }
    
    /// Selects the tapped card front button or unselects it and appends it or removes it from selectedCardTags
    /// - Parameter sender: The tapped card that is selected or unselected, depending on if it was selected beforehand
    @objc func saveAndAdjustCards(_ sender: UIButton) {
        if sender.isSelected {
            for (index, tag) in selectedCardTags.enumerated() {
                if sender.tag == tag {
                    selectedCardTags.remove(at: index)
                    sender.isSelected = false
                }
            }
            
            assert(!sender.isSelected)
        } else {
            selectedCardTags.append(sender.tag)
        }
        
        cardModel.cardSetSaver.saveCardFrontIndexes(selectedCardTags)
    }
}

// MARK: - Navigation
extension CustomizeCardsViewController {
    /// Pops to GameViewController
    @objc func moveToGameViewController() {
        navigationController?.popViewController(animated: true)
    }
}
