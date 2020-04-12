//
//  CustomizeBackgroundViewController.swift
//  Consolidation11
//
//  Created by Matt Free on 4/5/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class CustomizeBackgroundViewController: UIViewController {
    var currentBackground: UIImage!
    
    var smallBackgroundOptions = [UIButton]()
    
    let defaults = UserDefaults.standard
    
    // makes the top status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        resetSelected()
        
        switch defaults.string(forKey: "Background") {
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
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "ArrowButton"), for: .normal)
        backButton.addTarget(self, action: #selector(moveToGameViewController), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        backButton.showsTouchWhenHighlighted = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(backButton)
        
        // creating the background logo at the top
        let backgroundIcon = UIImageView(image: UIImage(named: "BackgroundButton"))
        backgroundIcon.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        backgroundIcon.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(backgroundIcon)
        
        // creating the background title label
        let backgroundTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        backgroundTitleLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        backgroundTitleLabel.font = UIFont(name: "Courgette-Regular", size: 36)
        backgroundTitleLabel.textAlignment = .center
        backgroundTitleLabel.text = "Background:"
        backgroundTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(backgroundTitleLabel)
        
        // creating the color labels
        let greenLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        greenLabel.textColor = UIColor(red: 0, green: 1, blue: 0.1, alpha: 1)
        greenLabel.font = UIFont(name: "ClickerScript-Regular", size: 30)
        greenLabel.textAlignment = .center
        greenLabel.text = "Green"
        greenLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(greenLabel)
        
        let redLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        redLabel.textColor = UIColor(red: 1, green: 0.337, blue: 0.337, alpha: 1)
        redLabel.font = UIFont(name: "ClickerScript-Regular", size: 30)
        redLabel.textAlignment = .center
        redLabel.text = "Red"
        redLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(redLabel)
        
        let blueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        blueLabel.textColor = UIColor(red: 0, green: 0.82, blue: 1, alpha: 1)
        blueLabel.font = UIFont(name: "ClickerScript-Regular", size: 30)
        blueLabel.textAlignment = .center
        blueLabel.text = "Blue"
        blueLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(blueLabel)
        
        let pinkLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        pinkLabel.textColor = UIColor(red: 1, green: 0.567, blue: 0.905, alpha: 1)
        pinkLabel.font = UIFont(name: "ClickerScript-Regular", size: 30)
        pinkLabel.textAlignment = .center
        pinkLabel.text = "Pink"
        pinkLabel.translatesAutoresizingMaskIntoConstraints = false
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
        let greenSmallBackground = UIButton(type: .custom)
        greenSmallBackground.setImage(UIImage(named: "SmallGreenBackground")?.imageWithBorder(width: 2, color: .white), for: .normal)
        greenSmallBackground.setImage(UIImage(named: "SmallGreenBackground")?.imageWithBorder(width: 2, color: .blue), for: .selected)
        greenSmallBackground.adjustsImageWhenHighlighted = false
        greenSmallBackground.addTarget(self, action: #selector(saveBackground), for: .touchUpInside)
        greenSmallBackground.tag = 0
        greenSmallBackground.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        smallBackgroundOptions.append(greenSmallBackground)
        
        let redSmallBackground = UIButton(type: .custom)
        redSmallBackground.setImage(UIImage(named: "SmallRedBackground")?.imageWithBorder(width: 2, color: .white), for: .normal)
        redSmallBackground.setImage(UIImage(named: "SmallRedBackground")?.imageWithBorder(width: 2, color: .blue), for: .selected)
        redSmallBackground.adjustsImageWhenHighlighted = false
        redSmallBackground.addTarget(self, action: #selector(saveBackground), for: .touchUpInside)
        redSmallBackground.tag = 1
        redSmallBackground.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        smallBackgroundOptions.append(redSmallBackground)
        
        let blueSmallBackground = UIButton(type: .custom)
        blueSmallBackground.setImage(UIImage(named: "SmallBlueBackground")?.imageWithBorder(width: 2, color: .white), for: .normal)
        blueSmallBackground.setImage(UIImage(named: "SmallBlueBackground")?.imageWithBorder(width: 2, color: .blue), for: .selected)
        blueSmallBackground.adjustsImageWhenHighlighted = false
        blueSmallBackground.addTarget(self, action: #selector(saveBackground), for: .touchUpInside)
        blueSmallBackground.tag = 2
        blueSmallBackground.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        smallBackgroundOptions.append(blueSmallBackground)
        
        let pinkSmallBackground = UIButton(type: .custom)
        pinkSmallBackground.setImage(UIImage(named: "SmallPinkBackground")?.imageWithBorder(width: 2, color: .white), for: .normal)
        pinkSmallBackground.setImage(UIImage(named: "SmallPinkBackground")?.imageWithBorder(width: 2, color: .blue), for: .selected)
        pinkSmallBackground.addTarget(self, action: #selector(saveBackground), for: .touchUpInside)
        pinkSmallBackground.tag = 3
        pinkSmallBackground.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
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
        let backsTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 50))
        backsTitleLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        backsTitleLabel.font = UIFont(name: "Courgette-Regular", size: 36)
        backsTitleLabel.textAlignment = .center
        backsTitleLabel.text = "Backs:"
        backsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(backsTitleLabel)
        
        // creating all the back styles
        let blueBack = UIImageView(image: UIImage(named: "BlueBack"))
        blueBack.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let redBack = UIImageView(image: UIImage(named: "RedBack"))
        redBack.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let greenBack = UIImageView(image: UIImage(named: "GreenBack"))
        greenBack.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let purpleBack = UIImageView(image: UIImage(named: "PurpleBack"))
        purpleBack.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let orangeBack = UIImageView(image: UIImage(named: "OrangeBack"))
        orangeBack.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let yellowBack = UIImageView(image: UIImage(named: "YellowBack"))
        yellowBack.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let pinkBack = UIImageView(image: UIImage(named: "PinkBack"))
        pinkBack.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let circleBack = UIImageView(image: UIImage(named: "CircleBack"))
        circleBack.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let eyeBack = UIImageView(image: UIImage(named: "EyeBack"))
        eyeBack.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
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
    
    func setBackground() {
        view.backgroundColor = UIColor.init(patternImage: currentBackground)
    }
    
    func resetSelected() {
        for option in smallBackgroundOptions {
            option.isSelected = false
        }
    }
    
    @objc func saveBackground(_ sender: UIButton) {
        resetSelected()
        
        switch sender.tag {
        case 0:
            defaults.set("green", forKey: "Background")
            smallBackgroundOptions[0].isSelected = true
            currentBackground = UIImage(data: defaults.data(forKey: "GreenBackground")!)
        case 1:
            defaults.set("red", forKey: "Background")
            smallBackgroundOptions[1].isSelected = true
            currentBackground = UIImage(data: defaults.data(forKey: "RedBackground")!)
        case 2:
            defaults.set("blue", forKey: "Background")
            smallBackgroundOptions[2].isSelected = true
            currentBackground = UIImage(data: defaults.data(forKey: "BlueBackground")!)
        default:
            defaults.set("pink", forKey: "Background")
            smallBackgroundOptions[3].isSelected = true
            currentBackground = UIImage(data: defaults.data(forKey: "PinkBackground")!)
        }
        
        setBackground()
    }
    
    @objc func moveToGameViewController() {
        navigationController?.popViewController(animated: true)
    }
}
