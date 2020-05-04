//
//  CustomizeCardsViewController.swift
//  Consolidation11
//
//  Created by Matt Free on 4/5/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class CustomizeCardsViewController: UIViewController {
    var currentBackground: UIImage!
    var cardModel: CardModel!
    
    var numberOptions = [NumberButton]()
    var cardOptions = [CardOptionButton]()
    
    var frontsTitleLabel: UILabel!
    
    var selectedCardTags = [Int]()
    
    let defaults = UserDefaults.standard
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        // setting the number of cards from saved state
        resetSelectedNumbers()
        
        switch defaults.integer(forKey: Constants.UDKeys.cardNumber) {
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
        
        frontsTitleLabel.text = "Fronts (Pick \(cardModel.getTotalCards() / 2)):"
        
        // setting the selected card fronts from saved state
        if let frontCardsTags = defaults.array(forKey: Constants.UDKeys.cardFrontTags) as? [Int] {
            selectedCardTags = frontCardsTags
        }
        
        setSelectedCards()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        fillCardsSelected()
    }
    
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
        
        // creating the number options
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
        
        addTargetsToNumberOptions()
        
        // creating the numbers' stackView
        let numbersStackView = UIStackView(arrangedSubviews: [eightOption, sixteenOption, twentyFourOption, thirtyTwoOption, fortyOption])
        numbersStackView.alignment = .center
        numbersStackView.axis = .horizontal
        numbersStackView.spacing = 30
        numbersStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(numbersStackView)
        
        // creating the fronts label
        frontsTitleLabel = HeaderLabel(title: "Fronts (Pick 12):")
        scrollView.addSubview(frontsTitleLabel)
        
        // creating all the front styles
        let biohazardCard = CardOptionButton(imageName: Constants.CardFrontNames.biohazard, tagNumber: 0)
        cardOptions.append(biohazardCard)
        
        let targetCard = CardOptionButton(imageName: Constants.CardFrontNames.target, tagNumber: 1)
        cardOptions.append(targetCard)
        
        let crossCard = CardOptionButton(imageName: Constants.CardFrontNames.cross, tagNumber: 2)
        cardOptions.append(crossCard)
        
        let heartCard = CardOptionButton(imageName: Constants.CardFrontNames.heart, tagNumber: 3)
        cardOptions.append(heartCard)
        
        let basketballCard = CardOptionButton(imageName: Constants.CardFrontNames.basketball, tagNumber: 4)
        cardOptions.append(basketballCard)
        
        let fleurDeLisCard = CardOptionButton(imageName: Constants.CardFrontNames.fleurDeLis, tagNumber: 5)
        cardOptions.append(fleurDeLisCard)
        
        let tulipCard = CardOptionButton(imageName: Constants.CardFrontNames.tulip, tagNumber: 6)
        cardOptions.append(tulipCard)
        
        let imperialCard = CardOptionButton(imageName: Constants.CardFrontNames.imperial, tagNumber: 7)
        cardOptions.append(imperialCard)
        
        let rebelCard = CardOptionButton(imageName: Constants.CardFrontNames.rebel, tagNumber: 8)
        cardOptions.append(rebelCard)
        
        let snowflakeCard = CardOptionButton(imageName: Constants.CardFrontNames.snowflake, tagNumber: 9)
        cardOptions.append(snowflakeCard)
        
        let atomCard = CardOptionButton(imageName: Constants.CardFrontNames.atom, tagNumber: 10)
        cardOptions.append(atomCard)
        
        let appleCard = CardOptionButton(imageName: Constants.CardFrontNames.apple, tagNumber: 11)
        cardOptions.append(appleCard)
        
        let bookCard = CardOptionButton(imageName: Constants.CardFrontNames.book, tagNumber: 12)
        cardOptions.append(bookCard)
        
        let cowboyHatCard = CardOptionButton(imageName: Constants.CardFrontNames.cowboyHat, tagNumber: 13)
        cardOptions.append(cowboyHatCard)
        
        let sunglassesCard = CardOptionButton(imageName: Constants.CardFrontNames.sunglasses, tagNumber: 14)
        cardOptions.append(sunglassesCard)
        
        let usFlagCard = CardOptionButton(imageName: Constants.CardFrontNames.usFlag, tagNumber: 15)
        cardOptions.append(usFlagCard)
        
        let dogCard = CardOptionButton(imageName: Constants.CardFrontNames.dog, tagNumber: 16)
        cardOptions.append(dogCard)
        
        let flowerCard = CardOptionButton(imageName: Constants.CardFrontNames.flower, tagNumber: 17)
        cardOptions.append(flowerCard)
        
        let palmCard = CardOptionButton(imageName: Constants.CardFrontNames.palm, tagNumber: 18)
        cardOptions.append(palmCard)
        
        let bagelCard = CardOptionButton(imageName: Constants.CardFrontNames.bagel, tagNumber: 19)
        cardOptions.append(bagelCard)
        
        let mountainCard = CardOptionButton(imageName: Constants.CardFrontNames.mountain, tagNumber: 20)
        cardOptions.append(mountainCard)
        
        let purpleCard = CardOptionButton(imageName: Constants.CardFrontNames.purple, tagNumber: 21)
        cardOptions.append(purpleCard)
        
        let sunsetCard = CardOptionButton(imageName: Constants.CardFrontNames.sunset, tagNumber: 22)
        cardOptions.append(sunsetCard)
        
        let turtleCard = CardOptionButton(imageName: Constants.CardFrontNames.turtle, tagNumber: 23)
        cardOptions.append(turtleCard)
        
        let carCard = CardOptionButton(imageName: Constants.CardFrontNames.car, tagNumber: 24)
        cardOptions.append(carCard)
        
        let motorcycleCard = CardOptionButton(imageName: Constants.CardFrontNames.motorcycle, tagNumber: 25)
        cardOptions.append(motorcycleCard)
        
        let catCard = CardOptionButton(imageName: Constants.CardFrontNames.cat, tagNumber: 26)
        cardOptions.append(catCard)
        
        let waterfallCard = CardOptionButton(imageName: Constants.CardFrontNames.waterfall, tagNumber: 27)
        cardOptions.append(waterfallCard)
        
        let roadCard = CardOptionButton(imageName: Constants.CardFrontNames.road, tagNumber: 28)
        cardOptions.append(roadCard)
        
        let templeCard = CardOptionButton(imageName: Constants.CardFrontNames.temple, tagNumber: 29)
        cardOptions.append(templeCard)
        
        let storkCard = CardOptionButton(imageName: Constants.CardFrontNames.stork, tagNumber: 30)
        cardOptions.append(storkCard)
        
        let toiletPaperCard = CardOptionButton(imageName: Constants.CardFrontNames.toiletPaper, tagNumber: 31)
        cardOptions.append(toiletPaperCard)
        
        addTargetsToCardOptions()
        
        // creating each row horizontalStackView to hold the cards
        let row1StackView = UIStackView(arrangedSubviews: [biohazardCard, targetCard, crossCard, heartCard])
        row1StackView.alignment = .center
        row1StackView.axis = .horizontal
        row1StackView.spacing = 20
        
        let row2StackView = UIStackView(arrangedSubviews: [basketballCard, fleurDeLisCard, tulipCard, imperialCard])
        row2StackView.alignment = .center
        row2StackView.axis = .horizontal
        row2StackView.spacing = 20
        
        let row3StackView = UIStackView(arrangedSubviews: [rebelCard, snowflakeCard, atomCard, appleCard])
        row3StackView.alignment = .center
        row3StackView.axis = .horizontal
        row3StackView.spacing = 20
        
        let row4StackView = UIStackView(arrangedSubviews: [bookCard, cowboyHatCard, sunglassesCard, usFlagCard])
        row4StackView.alignment = .center
        row4StackView.axis = .horizontal
        row4StackView.spacing = 20
        
        let row5StackView = UIStackView(arrangedSubviews: [dogCard, flowerCard, palmCard, bagelCard])
        row5StackView.alignment = .center
        row5StackView.axis = .horizontal
        row5StackView.spacing = 20
        
        let row6StackView = UIStackView(arrangedSubviews: [mountainCard, purpleCard, sunsetCard, turtleCard])
        row6StackView.alignment = .center
        row6StackView.axis = .horizontal
        row6StackView.spacing = 20
        
        let row7StackView = UIStackView(arrangedSubviews: [carCard, motorcycleCard, catCard, waterfallCard])
        row7StackView.alignment = .center
        row7StackView.axis = .horizontal
        row7StackView.spacing = 20
        
        let row8StackView = UIStackView(arrangedSubviews: [roadCard, templeCard, storkCard, toiletPaperCard])
        row8StackView.alignment = .center
        row8StackView.axis = .horizontal
        row8StackView.spacing = 20
        
        // creating the verticalStackView to hold the stackViews
        let cardStackView = UIStackView(arrangedSubviews: [row1StackView, row2StackView, row3StackView, row4StackView, row5StackView, row6StackView, row7StackView, row8StackView])
        cardStackView.alignment = .center
        cardStackView.axis = .vertical
        cardStackView.spacing = 20
        cardStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(cardStackView)
        
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
    
    func addTargetsToCardOptions() {
        for option in cardOptions {
            option.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        }
    }
    
    func addTargetsToNumberOptions() {
        for option in numberOptions {
            option.addTarget(self, action: #selector(saveNumberOfCards), for: .touchUpInside)
        }
    }
    
    func resetSelectedNumbers() {
        for option in numberOptions {
            option.isSelected = false
        }
    }
    
    @objc func saveNumberOfCards(_ sender: UIButton) {
        resetSelectedNumbers()
        
        switch sender.title(for: .normal) {
        case "8":
            defaults.set(8, forKey: Constants.UDKeys.cardNumber)
            numberOptions[0].isSelected = true
        case "16":
            defaults.set(16, forKey: Constants.UDKeys.cardNumber)
            numberOptions[1].isSelected = true
        case "24":
            defaults.set(24, forKey: Constants.UDKeys.cardNumber)
            numberOptions[2].isSelected = true
        case "32":
            defaults.set(32, forKey: Constants.UDKeys.cardNumber)
            numberOptions[3].isSelected = true
        default:
            defaults.set(40, forKey: Constants.UDKeys.cardNumber)
            numberOptions[4].isSelected = true
        }
        
        cardModel.saveTotalCards()
        setSelectedCards()
        adjustSelectedCards()
    }
    
    @objc func saveAndAdjustCards(_ sender: UIButton) {
        if sender.isSelected {
            for (index, tag) in selectedCardTags.enumerated() {
                if sender.tag == tag {
                    selectedCardTags.remove(at: index)
                }
            }
        } else {
            selectedCardTags.append(sender.tag)
        }
        
        setSelectedCards()
    }
    
    func adjustSelectedCards() {
        while selectedCardTags.count > cardModel.getTotalCards() / 2 {
            selectedCardTags.removeFirst()
        }
    }
    
    func fillCardsSelected() {
        if selectedCardTags.count < cardModel.getTotalCards() / 2 {
            // fills space up to amount of cards necessary in tags
            while selectedCardTags.count < cardModel.getTotalCards() / 2 || selectedCardTags.isEmpty {
                var i = 0
                while selectedCardTags.contains(cardOptions[i].tag) {
                    i += 1
                }
                selectedCardTags.append(cardOptions[i].tag)
            }
        }
        
        defaults.set(selectedCardTags, forKey: Constants.UDKeys.cardFrontTags)
        cardModel.setCardFronts()
    }
    
    func selectSavedCardsWithTags() {
        for tag in selectedCardTags {
            cardOptions[tag].isSelected = true
        }
    }
    
    func setSelectedCards() {
        for card in cardOptions {
            card.isSelected = false
        }
        
        for tag in selectedCardTags {
            cardOptions[tag].isSelected = true
        }
    }
    
    @objc func moveToGameViewController() {
        navigationController?.popViewController(animated: true)
    }
}
