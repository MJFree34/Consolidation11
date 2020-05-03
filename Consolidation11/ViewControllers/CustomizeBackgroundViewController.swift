//
//  CustomizeBackgroundViewController.swift
//  Consolidation11
//
//  Created by Matt Free on 4/5/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class CustomizeBackgroundViewController: UIViewController, UIGestureRecognizerDelegate {
    var currentBackground: UIImage!
    var cardModel: CardModel!
    
    var smallBackgroundOptions = [UIButton]()
    var cardBackOptions = [CardOptionButton]()
    
    let defaults = UserDefaults.standard
    
    // makes the top status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        resetSelectedBackgrounds()
        
        switch defaults.string(forKey: Constants.UDKeys.background) {
        case "green":
            smallBackgroundOptions[0].isSelected = true
        case "red":
            smallBackgroundOptions[1].isSelected = true
        case "blue":
            smallBackgroundOptions[2].isSelected = true
        default:
            smallBackgroundOptions[3].isSelected = true
        }
        
        resetSelectedBacks()
        
        switch defaults.string(forKey: Constants.UDKeys.cardBack) {
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
        default:
            cardBackOptions[8].isSelected = true
        }
    }
    
    func setupView() {
        // setting background pic
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
        scrollView.addSubview(greenLabel)
        
        let redLabel = ColorLabel(color: UIColor(red: 1, green: 0.337, blue: 0.337, alpha: 1), colorText: "Red")
        scrollView.addSubview(redLabel)
        
        let blueLabel = ColorLabel(color: UIColor(red: 0, green: 0.82, blue: 1, alpha: 1), colorText: "Blue")
        scrollView.addSubview(blueLabel)
        
        let pinkLabel = ColorLabel(color: UIColor(red: 1, green: 0.567, blue: 0.905, alpha: 1), colorText: "Pink")
        scrollView.addSubview(pinkLabel)
        
        // creating the stackViews for the backgroundLabels
        let backgroundLabels1StackView = UIStackView(arrangedSubviews: [greenLabel, redLabel])
        backgroundLabels1StackView.alignment = .center
        backgroundLabels1StackView.spacing = 135
        backgroundLabels1StackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundLabels1StackView)
        
        let backgroundLabels2StackView = UIStackView(arrangedSubviews: [blueLabel, pinkLabel])
        backgroundLabels2StackView.alignment = .center
        backgroundLabels2StackView.spacing = 135
        backgroundLabels2StackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundLabels2StackView)
        
        // creating the background options
        let greenSmallBackground = SmallBackgroundButton(imageName: Constants.SmallBackgroundNames.green, tagNumber: 0)
        greenSmallBackground.addTarget(self, action: #selector(saveBackground), for: .touchUpInside)
        smallBackgroundOptions.append(greenSmallBackground)
        
        let redSmallBackground = SmallBackgroundButton(imageName: Constants.SmallBackgroundNames.red, tagNumber: 1)
        redSmallBackground.addTarget(self, action: #selector(saveBackground), for: .touchUpInside)
        smallBackgroundOptions.append(redSmallBackground)
        
        let blueSmallBackground = SmallBackgroundButton(imageName: Constants.SmallBackgroundNames.blue, tagNumber: 2)
        blueSmallBackground.addTarget(self, action: #selector(saveBackground), for: .touchUpInside)
        smallBackgroundOptions.append(blueSmallBackground)
        
        let pinkSmallBackground = SmallBackgroundButton(imageName: Constants.SmallBackgroundNames.pink, tagNumber: 3)
        pinkSmallBackground.addTarget(self, action: #selector(saveBackground), for: .touchUpInside)
        smallBackgroundOptions.append(pinkSmallBackground)
        
        // creating the stackViews for the smallBackgrounds
        let backgrounds1StackView = UIStackView(arrangedSubviews: [greenSmallBackground, redSmallBackground])
        backgrounds1StackView.alignment = .center
        backgrounds1StackView.axis = .horizontal
        backgrounds1StackView.spacing = 45
        backgrounds1StackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgrounds1StackView)
        
        let backgrounds2StackView = UIStackView(arrangedSubviews: [blueSmallBackground, pinkSmallBackground])
        backgrounds2StackView.alignment = .center
        backgrounds2StackView.axis = .horizontal
        backgrounds2StackView.spacing = 45
        backgrounds2StackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgrounds2StackView)
        
        // creating the backs title label
        let backsTitleLabel = HeaderLabel(title: "Back:")
        scrollView.addSubview(backsTitleLabel)
        
        // creating all the back styles
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
        
        // adds target to all cardOptions
        addTargetToCardBackOptions()
        
        // creating each row horizontalStackView to hold the cards
        let row1StackView = UIStackView(arrangedSubviews: [blueBack, redBack, greenBack])
        row1StackView.alignment = .center
        row1StackView.axis = .horizontal
        row1StackView.spacing = 50
        
        let row2StackView = UIStackView(arrangedSubviews: [purpleBack, orangeBack, yellowBack])
        row2StackView.alignment = .center
        row2StackView.axis = .horizontal
        row2StackView.spacing = 50
        
        let row3StackView = UIStackView(arrangedSubviews: [pinkBack, circleBack, eyeBack])
        row3StackView.alignment = .center
        row3StackView.axis = .horizontal
        row3StackView.spacing = 50
        
        // creating the verticalStackView to hold the stackViews
        let cardStackView = UIStackView(arrangedSubviews: [row1StackView, row2StackView, row3StackView])
        cardStackView.alignment = .center
        cardStackView.axis = .vertical
        cardStackView.spacing = 35
        cardStackView.translatesAutoresizingMaskIntoConstraints = false
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
            backsTitleLabel.topAnchor.constraint(equalTo: blueSmallBackground.bottomAnchor, constant: 15),
            
            cardStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            cardStackView.topAnchor.constraint(equalTo: backsTitleLabel.bottomAnchor, constant: 20),
            cardStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10-8)
        ])
    }
    
    func resetSelectedBackgrounds() {
        for option in smallBackgroundOptions {
            option.isSelected = false
        }
    }
    
    @objc func saveBackground(_ sender: UIButton) {
        resetSelectedBackgrounds()
        
        switch sender.tag {
        case 0:
            defaults.set("green", forKey: Constants.UDKeys.background)
            smallBackgroundOptions[0].isSelected = true
            currentBackground = UIImage(data: defaults.data(forKey: Constants.BackgroundNames.green)!)
        case 1:
            defaults.set("red", forKey: Constants.UDKeys.background)
            smallBackgroundOptions[1].isSelected = true
            currentBackground = UIImage(data: defaults.data(forKey: Constants.BackgroundNames.red)!)
        case 2:
            defaults.set("blue", forKey: Constants.UDKeys.background)
            smallBackgroundOptions[2].isSelected = true
            currentBackground = UIImage(data: defaults.data(forKey: Constants.BackgroundNames.blue)!)
        default:
            defaults.set("pink", forKey: Constants.UDKeys.background)
            smallBackgroundOptions[3].isSelected = true
            currentBackground = UIImage(data: defaults.data(forKey: Constants.BackgroundNames.pink)!)
        }
        
        setBackground()
    }
    
    func setBackground() {
        view.backgroundColor = UIColor.init(patternImage: currentBackground)
    }
    
    func addTargetToCardBackOptions() {
        for option in cardBackOptions {
            option.addTarget(self, action: #selector(saveCardBack), for: .touchUpInside)
        }
    }
    
    func resetSelectedBacks() {
        for option in cardBackOptions {
            option.isSelected = false
        }
    }
    
    @objc func saveCardBack(_ cardBack: UIButton) {
        resetSelectedBacks()
        
        switch cardBack.tag {
        case 0:
            defaults.set(Constants.CardBackNames.blue, forKey: Constants.UDKeys.cardBack)
            cardBackOptions[0].isSelected = true
        case 1:
            defaults.set(Constants.CardBackNames.red, forKey: Constants.UDKeys.cardBack)
            cardBackOptions[1].isSelected = true
        case 2:
            defaults.set(Constants.CardBackNames.green, forKey: Constants.UDKeys.cardBack)
            cardBackOptions[2].isSelected = true
        case 3:
            defaults.set(Constants.CardBackNames.purple, forKey: Constants.UDKeys.cardBack)
            cardBackOptions[3].isSelected = true
        case 4:
            defaults.set(Constants.CardBackNames.orange, forKey: Constants.UDKeys.cardBack)
            cardBackOptions[4].isSelected = true
        case 5:
            defaults.set(Constants.CardBackNames.yellow, forKey: Constants.UDKeys.cardBack)
            cardBackOptions[5].isSelected = true
        case 6:
            defaults.set(Constants.CardBackNames.pink, forKey: Constants.UDKeys.cardBack)
            cardBackOptions[6].isSelected = true
        case 7:
            defaults.set(Constants.CardBackNames.circle, forKey: Constants.UDKeys.cardBack)
            cardBackOptions[7].isSelected = true
        default:
            defaults.set(Constants.CardBackNames.eye, forKey: Constants.UDKeys.cardBack)
            cardBackOptions[8].isSelected = true
        }
        
        cardModel.setCardBacks()
    }
    
    @objc func moveToGameViewController() {
        navigationController?.popViewController(animated: true)
    }
}
