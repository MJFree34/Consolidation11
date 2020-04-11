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
    
    var options = [UIButton]()
    
    var frontsTitleLabel: UILabel!
    
    let defaults = UserDefaults.standard
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        if defaults.integer(forKey: "NumberOfCards") != 0 {
            resetSelecteds()
            
            switch defaults.integer(forKey: "NumberOfCards") {
            case 8:
                options[0].isSelected = true
            case 16:
                options[1].isSelected = true
            case 24:
                options[2].isSelected = true
            case 32:
                options[3].isSelected = true
            default:
                options[4].isSelected = true
            }
        }
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
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "ArrowButton"), for: .normal)
        backButton.addTarget(self, action: #selector(moveToGameViewController), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        backButton.showsTouchWhenHighlighted = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(backButton)
        
        // creating the card logo at the top
        let cardIcon = UIImageView(image: UIImage(named: "CardButton"))
        cardIcon.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        cardIcon.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(cardIcon)
        
        // creating the numberOfCards title label
        let numberOfCardsTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        numberOfCardsTitleLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        numberOfCardsTitleLabel.font = UIFont(name: "Courgette-Regular", size: 36)
        numberOfCardsTitleLabel.textAlignment = .center
        numberOfCardsTitleLabel.text = "Number of Cards:"
        numberOfCardsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(numberOfCardsTitleLabel)
        
        // creating the number options
        let eightOption = UIButton()
        eightOption.setTitleColor(.white, for: .normal)
        eightOption.setTitleColor(UIColor(red: 0, green: 0.94, blue: 1, alpha: 1), for: .selected)
        eightOption.setTitle("8", for: .normal)
        eightOption.titleLabel?.font = UIFont(name: "Kranky-Regular", size: 36)
        eightOption.titleLabel?.textAlignment = .center
        eightOption.addTarget(self, action: #selector(saveNumberOfCards), for: .touchUpInside)
        eightOption.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        options.append(eightOption)
        
        let sixteenOption = UIButton()
        sixteenOption.setTitleColor(.white, for: .normal)
        sixteenOption.setTitleColor(UIColor(red: 1, green: 0.9, blue: 0, alpha: 1), for: .selected)
        sixteenOption.setTitle("16", for: .normal)
        sixteenOption.titleLabel?.font = UIFont(name: "Kranky-Regular", size: 36)
        sixteenOption.titleLabel?.textAlignment = .center
        sixteenOption.addTarget(self, action: #selector(saveNumberOfCards), for: .touchUpInside)
        sixteenOption.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        options.append(sixteenOption)
        
        let twentyFourOption = UIButton()
        twentyFourOption.setTitleColor(.white, for: .normal)
        twentyFourOption.setTitleColor(UIColor(red: 0.56, green: 1, blue: 0, alpha: 1), for: .selected)
        twentyFourOption.setTitle("24", for: .normal)
        twentyFourOption.titleLabel?.font = UIFont(name: "Kranky-Regular", size: 36)
        twentyFourOption.titleLabel?.textAlignment = .center
        twentyFourOption.addTarget(self, action: #selector(saveNumberOfCards), for: .touchUpInside)
        twentyFourOption.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        options.append(twentyFourOption)
        
        let thirtyTwoOption = UIButton()
        thirtyTwoOption.setTitleColor(.white, for: .normal)
        thirtyTwoOption.setTitleColor(UIColor(red: 0.32, green: 0, blue: 0.571, alpha: 1), for: .selected)
        thirtyTwoOption.setTitle("32", for: .normal)
        thirtyTwoOption.titleLabel?.font = UIFont(name: "Kranky-Regular", size: 36)
        thirtyTwoOption.titleLabel?.textAlignment = .center
        thirtyTwoOption.addTarget(self, action: #selector(saveNumberOfCards), for: .touchUpInside)
        thirtyTwoOption.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        options.append(thirtyTwoOption)
        
        let fourtyOption = UIButton()
        fourtyOption.setTitleColor(.white, for: .normal)
        fourtyOption.setTitleColor(UIColor(red: 1, green: 0.584, blue: 0.2, alpha: 1), for:.selected )
        fourtyOption.setTitle("40", for: .normal)
        fourtyOption.titleLabel?.font = UIFont(name: "Kranky-Regular", size: 36)
        fourtyOption.titleLabel?.textAlignment = .center
        fourtyOption.addTarget(self, action: #selector(saveNumberOfCards), for: .touchUpInside)
        fourtyOption.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        options.append(fourtyOption)
        
        // creating the numbers' stackView
        let numbersStackView = UIStackView(arrangedSubviews: [eightOption, sixteenOption, twentyFourOption, thirtyTwoOption, fourtyOption])
        numbersStackView.alignment = .center
        numbersStackView.axis = .horizontal
        numbersStackView.spacing = 30
        numbersStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(numbersStackView)
        
        // creating the fronts label
        frontsTitleLabel = UILabel()
        frontsTitleLabel.textColor = .white
        frontsTitleLabel.text = "Fronts (Pick 12):"
        frontsTitleLabel.font = UIFont(name: "Courgette-Regular", size: 36)
        frontsTitleLabel.textAlignment = .center
        frontsTitleLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        frontsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(frontsTitleLabel)
        
        // creating all the front styles
        let biohazardCard = UIImageView(image: UIImage(named: "BiohazardCard"))
        biohazardCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let targetCard = UIImageView(image: UIImage(named: "TargetCard"))
        targetCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let crossCard = UIImageView(image: UIImage(named: "CrossCard"))
        crossCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let heartCard = UIImageView(image: UIImage(named: "HeartCard"))
        heartCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let basketballCard = UIImageView(image: UIImage(named: "BasketballCard"))
        basketballCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let fleurDeLisCard = UIImageView(image: UIImage(named: "FleurDeLisCard"))
        fleurDeLisCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let tulipCard = UIImageView(image: UIImage(named: "TulipCard"))
        tulipCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let imperialCard = UIImageView(image: UIImage(named: "ImperialCard"))
        imperialCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let rebelCard = UIImageView(image: UIImage(named: "RebelCard"))
        rebelCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let snowflakeCard = UIImageView(image: UIImage(named: "SnowflakeCard"))
        snowflakeCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let atomCard = UIImageView(image: UIImage(named: "AtomCard"))
        atomCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let appleCard = UIImageView(image: UIImage(named: "AppleCard"))
        appleCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let bookCard = UIImageView(image: UIImage(named: "BookCard"))
        bookCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let cowboyHatCard = UIImageView(image: UIImage(named: "CowboyHatCard"))
        cowboyHatCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let sunglassesCard = UIImageView(image: UIImage(named: "SunglassesCard"))
        sunglassesCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let usFlagCard = UIImageView(image: UIImage(named: "USFlagCard"))
        usFlagCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let dogCard = UIImageView(image: UIImage(named: "DogCard"))
        dogCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let flowerCard = UIImageView(image: UIImage(named: "FlowerCard"))
        flowerCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let palmCard = UIImageView(image: UIImage(named: "PalmCard"))
        palmCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let bagelCard = UIImageView(image: UIImage(named: "BagelCard"))
        bagelCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let mountainCard = UIImageView(image: UIImage(named: "MountainCard"))
        mountainCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let purpleCard = UIImageView(image: UIImage(named: "PurpleCard"))
        purpleCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let sunsetCard = UIImageView(image: UIImage(named: "SunsetCard"))
        sunsetCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let turtleCard = UIImageView(image: UIImage(named: "TurtleCard"))
        turtleCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let carCard = UIImageView(image: UIImage(named: "CarCard"))
        carCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let motorcycleCard = UIImageView(image: UIImage(named: "MotorcycleCard"))
        motorcycleCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let catCard = UIImageView(image: UIImage(named: "CatCard"))
        catCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let waterfallCard = UIImageView(image: UIImage(named: "WaterfallCard"))
        waterfallCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let roadCard = UIImageView(image: UIImage(named: "RoadCard"))
        roadCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let templeCard = UIImageView(image: UIImage(named: "TempleCard"))
        templeCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let storkCard = UIImageView(image: UIImage(named: "StorkCard"))
        storkCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
        let toiletPaperCard = UIImageView(image: UIImage(named: "ToiletPaperCard"))
        toiletPaperCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        
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
    
    @objc func saveNumberOfCards(_ sender: UIButton) {
        resetSelecteds()
        
        switch sender.title(for: .normal) {
        case "8":
            defaults.set(8, forKey: "NumberOfCards")
            options[0].isSelected = true
        case "16":
            defaults.set(16, forKey: "NumberOfCards")
            options[1].isSelected = true
        case "24":
            defaults.set(24, forKey: "NumberOfCards")
            options[2].isSelected = true
        case "32":
            defaults.set(32, forKey: "NumberOfCards")
            options[3].isSelected = true
        default:
            defaults.set(40, forKey: "NumberOfCards")
            options[4].isSelected = true
        }
    }
    
    func resetSelecteds() {
        for option in options {
            option.isSelected = false
        }
    }
    
    @objc func moveToGameViewController() {
        navigationController?.popViewController(animated: true)
    }
}
