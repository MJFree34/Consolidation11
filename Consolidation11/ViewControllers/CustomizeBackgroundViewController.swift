//
//  CustomizeBackgroundViewController.swift
//  Consolidation11
//
//  Created by Matt Free on 4/5/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class CustomizeBackgroundViewController: UIViewController {
    /// The model for the cards
    var cardModel: CardModel
    /// The background option buttons
    var smallBackgroundOptions = [UIButton]()
    /// The card back option buttons
    var cardBackOptions = [CardOptionButton]()
    /// Source for the background
    let backgroundSaver: BackgroundSaver
    
    init(cardModel: CardModel, backgroundSaver: BackgroundSaver) {
        self.backgroundSaver = backgroundSaver
        self.cardModel = cardModel
        
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
        
        selectSavedBackground()
        selectSavedCardBack()
    }
    
    override func loadView() {
        super.loadView()
        
        setupView()
    }
    
    /// Sets up the entire rendered screen
    func setupView() {
        setBackground()
        
        // giving the ability to swipe from the left of screen to pop to rootView
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        // creating scrollView
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: view.bounds.width - 16, height: 1050)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // creating backButton
        let backButton = BackButton()
        backButton.addTarget(self, action: #selector(moveToGameViewController), for: .touchUpInside)
        scrollView.addSubview(backButton)
        
        // creating the background logo at the top
        let backgroundIcon = TopIcon(imageName: Constants.ButtonNames.background)
        scrollView.addSubview(backgroundIcon)
        
        // creating the background title label
        let backgroundTitleLabel = HeaderLabel(title: "Background:")
        scrollView.addSubview(backgroundTitleLabel)
        
        // creating the color labels
        let greenLabel = ColorLabel(color: UIColor(red: 0, green: 1, blue: 0.1, alpha: 1), colorText: "Green")
        let redLabel = ColorLabel(color: UIColor(red: 1, green: 0.337, blue: 0.337, alpha: 1), colorText: "Red")
        let blueLabel = ColorLabel(color: UIColor(red: 0, green: 0.82, blue: 1, alpha: 1), colorText: "Blue")
        let pinkLabel = ColorLabel(color: UIColor(red: 1, green: 0.567, blue: 0.905, alpha: 1), colorText: "Pink")
        
        // creating the stackViews for the backgroundLabels
        let backgroundLabels1StackView = UIStackView(arrangedSubviews: [greenLabel, redLabel], spacing: 135, axis: .horizontal, tamic: false)
        scrollView.addSubview(backgroundLabels1StackView)
        
        let backgroundLabels2StackView = UIStackView(arrangedSubviews: [blueLabel, pinkLabel], spacing: 135, axis: .horizontal, tamic: false)
        scrollView.addSubview(backgroundLabels2StackView)
        
        createSmallBackgrounds()
        
        // creating the stackViews for the smallBackgrounds
        let backgrounds1StackView = UIStackView(arrangedSubviews: [smallBackgroundOptions[0], smallBackgroundOptions[1]], spacing: 45, axis: .horizontal, tamic: false)
        scrollView.addSubview(backgrounds1StackView)
        
        let backgrounds2StackView = UIStackView(arrangedSubviews: [smallBackgroundOptions[2], smallBackgroundOptions[3]], spacing: 45, axis: .horizontal, tamic: false)
        scrollView.addSubview(backgrounds2StackView)
        
        // creating the backs title label
        let backsTitleLabel = HeaderLabel(title: "Back:")
        scrollView.addSubview(backsTitleLabel)
        
        createCardBackOptions()
        
        // creating each row horizontalStackView to hold the cards
        let row1StackView = UIStackView(arrangedSubviews: [cardBackOptions[0], cardBackOptions[1], cardBackOptions[2]], spacing: 50, axis: .horizontal, tamic: true)
        let row2StackView = UIStackView(arrangedSubviews: [cardBackOptions[3], cardBackOptions[4], cardBackOptions[5]], spacing: 50, axis: .horizontal, tamic: true)
        let row3StackView = UIStackView(arrangedSubviews: [cardBackOptions[6], cardBackOptions[7], cardBackOptions[8]], spacing: 50, axis: .horizontal, tamic: true)
        
        // creating the verticalStackView to hold the stackViews
        let cardStackView = UIStackView(arrangedSubviews: [row1StackView, row2StackView, row3StackView], spacing: 35, axis: .vertical, tamic: false)
        scrollView.addSubview(cardStackView)

        // all constraints
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20-8),
            backButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40-8),
            
            backgroundIcon.widthAnchor.constraint(equalToConstant: 100),
            backgroundIcon.heightAnchor.constraint(equalToConstant: 100),
            backgroundIcon.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundIcon.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30-8),
            
            backgroundTitleLabel.widthAnchor.constraint(equalToConstant: 200),
            backgroundTitleLabel.heightAnchor.constraint(equalToConstant: 50),
            backgroundTitleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundTitleLabel.topAnchor.constraint(equalTo: backgroundIcon.bottomAnchor, constant: 5),
            
            backgroundLabels1StackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundLabels1StackView.topAnchor.constraint(equalTo: backgroundTitleLabel.bottomAnchor),
            
            backgrounds1StackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgrounds1StackView.topAnchor.constraint(equalTo: backgroundLabels1StackView.bottomAnchor, constant: 5),
            
            backgroundLabels2StackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundLabels2StackView.topAnchor.constraint(equalTo: backgrounds1StackView.bottomAnchor, constant: 5),
            
            backgrounds2StackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgrounds2StackView.topAnchor.constraint(equalTo: backgroundLabels2StackView.bottomAnchor, constant: 5),
            
            backsTitleLabel.widthAnchor.constraint(equalToConstant: 110),
            backsTitleLabel.heightAnchor.constraint(equalToConstant: 50),
            backsTitleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backsTitleLabel.topAnchor.constraint(equalTo: backgrounds2StackView.bottomAnchor, constant: 15),
            
            cardStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            cardStackView.topAnchor.constraint(equalTo: backsTitleLabel.bottomAnchor, constant: 20),
            cardStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10-8)
        ])
    }
    
    /// Selects the chosen background
    func selectSavedBackground() {
        switch backgroundSaver.currentBackgroundColor() {
        case "green":
            smallBackgroundOptions[0].isSelected = true
        case "red":
            smallBackgroundOptions[1].isSelected = true
        case "blue":
            smallBackgroundOptions[2].isSelected = true
        default:
            smallBackgroundOptions[3].isSelected = true
        }
    }
    
    /// Selects the chosen card back
    func selectSavedCardBack() {
        switch cardModel.card(at: 0).backImageName {
        case Constants.CardBackNames.blue:
            cardBackOptions[0].isSelected = true
        case Constants.CardBackNames.red:
            cardBackOptions[1].isSelected = true
        case Constants.CardBackNames.green:
            cardBackOptions[2].isSelected = true
        case Constants.CardBackNames.purple:
            cardBackOptions[3].isSelected = true
        case Constants.CardBackNames.orange:
            cardBackOptions[4].isSelected = true
        case Constants.CardBackNames.yellow:
            cardBackOptions[5].isSelected = true
        case Constants.CardBackNames.pink:
            cardBackOptions[6].isSelected = true
        case Constants.CardBackNames.circle:
            cardBackOptions[7].isSelected = true
        case Constants.CardBackNames.eye:
            cardBackOptions[8].isSelected = true
        default:
            cardBackOptions[0].isSelected = true
        }
    }
    
    /// Creates the small background buttons and adds them to smallBackgroundOptions array
    func createSmallBackgrounds() {
        let greenSmallBackground = SmallBackgroundButton(imageName: Constants.SmallBackgroundNames.green, tagNumber: 0)
        smallBackgroundOptions.append(greenSmallBackground)
        
        let redSmallBackground = SmallBackgroundButton(imageName: Constants.SmallBackgroundNames.red, tagNumber: 1)
        smallBackgroundOptions.append(redSmallBackground)
        
        let blueSmallBackground = SmallBackgroundButton(imageName: Constants.SmallBackgroundNames.blue, tagNumber: 2)
        smallBackgroundOptions.append(blueSmallBackground)
        
        let pinkSmallBackground = SmallBackgroundButton(imageName: Constants.SmallBackgroundNames.pink, tagNumber: 3)
        smallBackgroundOptions.append(pinkSmallBackground)
        
        // adds target to all of them
        for option in smallBackgroundOptions {
            option.addTarget(self, action: #selector(saveBackground), for: .touchUpInside)
        }
    }
    
    /// Creates the card back buttons and adds them to cardBackOptions array
    func createCardBackOptions() {
        let blueBack = CardOptionButton(imageName: Constants.CardBackNames.blue, tagNumber: 0)
        cardBackOptions.append(blueBack)
        
        let redBack = CardOptionButton(imageName: Constants.CardBackNames.red, tagNumber: 1)
        cardBackOptions.append(redBack)
        
        let greenBack = CardOptionButton(imageName: Constants.CardBackNames.green, tagNumber: 2)
        cardBackOptions.append(greenBack)
        
        let purpleBack = CardOptionButton(imageName: Constants.CardBackNames.purple, tagNumber: 3)
        cardBackOptions.append(purpleBack)
        
        let orangeBack = CardOptionButton(imageName: Constants.CardBackNames.orange, tagNumber: 4)
        cardBackOptions.append(orangeBack)
        
        let yellowBack = CardOptionButton(imageName: Constants.CardBackNames.yellow, tagNumber: 5)
        cardBackOptions.append(yellowBack)
        
        let pinkBack = CardOptionButton(imageName: Constants.CardBackNames.pink, tagNumber: 6)
        cardBackOptions.append(pinkBack)
        
        let circleBack = CardOptionButton(imageName: Constants.CardBackNames.circle, tagNumber: 7)
        cardBackOptions.append(circleBack)
        
        let eyeBack = CardOptionButton(imageName: Constants.CardBackNames.eye, tagNumber: 8)
        cardBackOptions.append(eyeBack)
        
        // adds target to all of them
        for option in cardBackOptions {
            option.addTarget(self, action: #selector(saveCardBack), for: .touchUpInside)
        }
    }
    
    /// Sets the background to the currentBackground
    func setBackground() {
        view.backgroundColor = UIColor.init(patternImage: backgroundSaver.currentBackground)
    }
}

// MARK: - Saving and Selecting
extension CustomizeBackgroundViewController {
    /// Resets the smallBackgroundOptions to not be selected
    func resetSelectedBackgrounds() {
        for option in smallBackgroundOptions {
            option.isSelected = false
        }
    }
    
    /// Saves the background that is tapped and updates the currentBackground
    /// - Parameter smallBackground: The small background button that was tapped and is to be selected as the currentBackground
    @objc func saveBackground(_ smallBackground: UIButton) {
        resetSelectedBackgrounds()
        
        switch smallBackground.tag {
        case 0:
            backgroundSaver.setCurrentBackground("green")
            smallBackgroundOptions[0].isSelected = true
        case 1:
            backgroundSaver.setCurrentBackground("red")
            smallBackgroundOptions[1].isSelected = true
        case 2:
            backgroundSaver.setCurrentBackground("blue")
            smallBackgroundOptions[2].isSelected = true
        default:
            backgroundSaver.setCurrentBackground("pink")
            smallBackgroundOptions[3].isSelected = true
        }
        
        setBackground()
    }
    
    /// Resets the cardBackOptions to not be selected
    func resetSelectedBacks() {
        for option in cardBackOptions {
            option.isSelected = false
        }
    }
    
    /// Saves the card back that is tapped and updates the cardModel
    /// - Parameter cardBack: The card back button that was tapped and is to be selected as the current card back
    @objc func saveCardBack(_ cardBack: UIButton) {
        resetSelectedBacks()
        
        switch cardBack.tag {
        case 0:
            cardModel.cardSetSaver.saveCardBack(Constants.CardBackNames.blue)
            cardBackOptions[0].isSelected = true
        case 1:
            cardModel.cardSetSaver.saveCardBack(Constants.CardBackNames.red)
            cardBackOptions[1].isSelected = true
        case 2:
            cardModel.cardSetSaver.saveCardBack(Constants.CardBackNames.green)
            cardBackOptions[2].isSelected = true
        case 3:
            cardModel.cardSetSaver.saveCardBack(Constants.CardBackNames.purple)
            cardBackOptions[3].isSelected = true
        case 4:
            cardModel.cardSetSaver.saveCardBack(Constants.CardBackNames.orange)
            cardBackOptions[4].isSelected = true
        case 5:
            cardModel.cardSetSaver.saveCardBack(Constants.CardBackNames.yellow)
            cardBackOptions[5].isSelected = true
        case 6:
            cardModel.cardSetSaver.saveCardBack(Constants.CardBackNames.pink)
            cardBackOptions[6].isSelected = true
        case 7:
            cardModel.cardSetSaver.saveCardBack(Constants.CardBackNames.circle)
            cardBackOptions[7].isSelected = true
        default:
            cardModel.cardSetSaver.saveCardBack(Constants.CardBackNames.eye)
            cardBackOptions[8].isSelected = true
        }
    }
}

// MARK: - Navigation
extension CustomizeBackgroundViewController {
    /// Pushes to GameViewController
    @objc func moveToGameViewController() {
        navigationController?.popViewController(animated: true)
    }
}
