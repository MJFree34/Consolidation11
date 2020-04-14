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
    var currentNumberOfCards: Int = 0 {
        didSet {
            frontsTitleLabel.text = "Fronts (Pick \(currentNumberOfCards / 2)):"
        }
    }
    
    var numberOptions = [UIButton]()
    var cardOptions = [UIButton]()
    
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
        
        switch defaults.integer(forKey: "NumberOfCards") {
        case 8:
            numberOptions[0].isSelected = true
            currentNumberOfCards = 8
        case 16:
            numberOptions[1].isSelected = true
            currentNumberOfCards = 16
        case 24:
            numberOptions[2].isSelected = true
            currentNumberOfCards = 24
        case 32:
            numberOptions[3].isSelected = true
            currentNumberOfCards = 32
        default:
            numberOptions[4].isSelected = true
            currentNumberOfCards = 40
        }
        
        // setting the selected card fronts from saved state
        if let frontCardsTags = defaults.array(forKey: "CardFrontTags") as? [Int] {
            selectedCardTags = frontCardsTags
        }
        
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
        numberOptions.append(eightOption)
        
        let sixteenOption = UIButton()
        sixteenOption.setTitleColor(.white, for: .normal)
        sixteenOption.setTitleColor(UIColor(red: 1, green: 0.9, blue: 0, alpha: 1), for: .selected)
        sixteenOption.setTitle("16", for: .normal)
        sixteenOption.titleLabel?.font = UIFont(name: "Kranky-Regular", size: 36)
        sixteenOption.titleLabel?.textAlignment = .center
        sixteenOption.addTarget(self, action: #selector(saveNumberOfCards), for: .touchUpInside)
        sixteenOption.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        numberOptions.append(sixteenOption)
        
        let twentyFourOption = UIButton()
        twentyFourOption.setTitleColor(.white, for: .normal)
        twentyFourOption.setTitleColor(UIColor(red: 0.56, green: 1, blue: 0, alpha: 1), for: .selected)
        twentyFourOption.setTitle("24", for: .normal)
        twentyFourOption.titleLabel?.font = UIFont(name: "Kranky-Regular", size: 36)
        twentyFourOption.titleLabel?.textAlignment = .center
        twentyFourOption.addTarget(self, action: #selector(saveNumberOfCards), for: .touchUpInside)
        twentyFourOption.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        numberOptions.append(twentyFourOption)
        
        let thirtyTwoOption = UIButton()
        thirtyTwoOption.setTitleColor(.white, for: .normal)
        thirtyTwoOption.setTitleColor(UIColor(red: 0.827, green: 1, blue: 0.333, alpha: 1), for: .selected)
        thirtyTwoOption.setTitle("32", for: .normal)
        thirtyTwoOption.titleLabel?.font = UIFont(name: "Kranky-Regular", size: 36)
        thirtyTwoOption.titleLabel?.textAlignment = .center
        thirtyTwoOption.addTarget(self, action: #selector(saveNumberOfCards), for: .touchUpInside)
        thirtyTwoOption.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        numberOptions.append(thirtyTwoOption)
        
        let fortyOption = UIButton()
        fortyOption.setTitleColor(.white, for: .normal)
        fortyOption.setTitleColor(UIColor(red: 1, green: 0.584, blue: 0.2, alpha: 1), for:.selected )
        fortyOption.setTitle("40", for: .normal)
        fortyOption.titleLabel?.font = UIFont(name: "Kranky-Regular", size: 36)
        fortyOption.titleLabel?.textAlignment = .center
        fortyOption.addTarget(self, action: #selector(saveNumberOfCards), for: .touchUpInside)
        fortyOption.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        numberOptions.append(fortyOption)
        
        // creating the numbers' stackView
        let numbersStackView = UIStackView(arrangedSubviews: [eightOption, sixteenOption, twentyFourOption, thirtyTwoOption, fortyOption])
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
        let biohazardCard = UIButton(type: .custom)
        biohazardCard.setImage(UIImage(named: "BiohazardCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        biohazardCard.setImage(UIImage(named: "BiohazardCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        biohazardCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        biohazardCard.adjustsImageWhenHighlighted = false
        biohazardCard.tag = 0
        biohazardCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(biohazardCard)
        
        let targetCard = UIButton(type: .custom)
        targetCard.setImage(UIImage(named: "TargetCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        targetCard.setImage(UIImage(named: "TargetCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        targetCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        targetCard.adjustsImageWhenHighlighted = false
        targetCard.tag = 1
        targetCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(targetCard)
        
        let crossCard = UIButton(type: .custom)
        crossCard.setImage(UIImage(named: "CrossCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        crossCard.setImage(UIImage(named: "CrossCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        crossCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        crossCard.adjustsImageWhenHighlighted = false
        crossCard.tag = 2
        crossCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(crossCard)
        
        let heartCard = UIButton(type: .custom)
        heartCard.setImage(UIImage(named: "HeartCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        heartCard.setImage(UIImage(named: "HeartCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        heartCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        heartCard.adjustsImageWhenHighlighted = false
        heartCard.tag = 3
        heartCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(heartCard)
        
        let basketballCard = UIButton(type: .custom)
        basketballCard.setImage(UIImage(named: "BasketballCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        basketballCard.setImage(UIImage(named: "BasketballCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        basketballCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        basketballCard.adjustsImageWhenHighlighted = false
        basketballCard.tag = 4
        basketballCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(basketballCard)
        
        let fleurDeLisCard = UIButton(type: .custom)
        fleurDeLisCard.setImage(UIImage(named: "FleurDeLisCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        fleurDeLisCard.setImage(UIImage(named: "FleurDeLisCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        fleurDeLisCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        fleurDeLisCard.adjustsImageWhenHighlighted = false
        fleurDeLisCard.tag = 5
        fleurDeLisCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(fleurDeLisCard)
        
        let tulipCard = UIButton(type: .custom)
        tulipCard.setImage(UIImage(named: "TulipCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        tulipCard.setImage(UIImage(named: "TulipCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        tulipCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        tulipCard.adjustsImageWhenHighlighted = false
        tulipCard.tag = 6
        tulipCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(tulipCard)
        
        let imperialCard = UIButton(type: .custom)
        imperialCard.setImage(UIImage(named: "ImperialCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        imperialCard.setImage(UIImage(named: "ImperialCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        imperialCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        imperialCard.adjustsImageWhenHighlighted = false
        imperialCard.tag = 7
        imperialCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(imperialCard)
        
        let rebelCard = UIButton(type: .custom)
        rebelCard.setImage(UIImage(named: "RebelCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        rebelCard.setImage(UIImage(named: "RebelCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        rebelCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        rebelCard.adjustsImageWhenHighlighted = false
        rebelCard.tag = 8
        rebelCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(rebelCard)
        
        let snowflakeCard = UIButton(type: .custom)
        snowflakeCard.setImage(UIImage(named: "SnowflakeCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        snowflakeCard.setImage(UIImage(named: "SnowflakeCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        snowflakeCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        snowflakeCard.adjustsImageWhenHighlighted = false
        snowflakeCard.tag = 9
        snowflakeCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(snowflakeCard)
        
        let atomCard = UIButton(type: .custom)
        atomCard.setImage(UIImage(named: "AtomCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        atomCard.setImage(UIImage(named: "AtomCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        atomCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        atomCard.adjustsImageWhenHighlighted = false
        atomCard.tag = 10
        atomCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(atomCard)
        
        let appleCard = UIButton(type: .custom)
        appleCard.setImage(UIImage(named: "AppleCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        appleCard.setImage(UIImage(named: "AppleCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        appleCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        appleCard.adjustsImageWhenHighlighted = false
        appleCard.tag = 11
        appleCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(appleCard)
        
        let bookCard = UIButton(type: .custom)
        bookCard.setImage(UIImage(named: "BookCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        bookCard.setImage(UIImage(named: "BookCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        bookCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        bookCard.adjustsImageWhenHighlighted = false
        bookCard.tag = 12
        bookCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(bookCard)
        
        let cowboyHatCard = UIButton(type: .custom)
        cowboyHatCard.setImage(UIImage(named: "CowboyHatCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        cowboyHatCard.setImage(UIImage(named: "CowboyHatCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        cowboyHatCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        cowboyHatCard.adjustsImageWhenHighlighted = false
        cowboyHatCard.tag = 13
        cowboyHatCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(cowboyHatCard)
        
        let sunglassesCard = UIButton(type: .custom)
        sunglassesCard.setImage(UIImage(named: "SunglassesCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        sunglassesCard.setImage(UIImage(named: "SunglassesCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        sunglassesCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        sunglassesCard.adjustsImageWhenHighlighted = false
        sunglassesCard.tag = 14
        sunglassesCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(sunglassesCard)
        
        let usFlagCard = UIButton(type: .custom)
        usFlagCard.setImage(UIImage(named: "USFlagCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        usFlagCard.setImage(UIImage(named: "USFlagCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        usFlagCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        usFlagCard.adjustsImageWhenHighlighted = false
        usFlagCard.tag = 15
        usFlagCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(usFlagCard)
        
        let dogCard = UIButton(type: .custom)
        dogCard.setImage(UIImage(named: "DogCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        dogCard.setImage(UIImage(named: "DogCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        dogCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        dogCard.adjustsImageWhenHighlighted = false
        dogCard.tag = 16
        dogCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(dogCard)
        
        let flowerCard = UIButton(type: .custom)
        flowerCard.setImage(UIImage(named: "FlowerCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        flowerCard.setImage(UIImage(named: "FlowerCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        flowerCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        flowerCard.adjustsImageWhenHighlighted = false
        flowerCard.tag = 17
        flowerCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(flowerCard)
        
        let palmCard = UIButton(type: .custom)
        palmCard.setImage(UIImage(named: "PalmCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        palmCard.setImage(UIImage(named: "PalmCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        palmCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        palmCard.adjustsImageWhenHighlighted = false
        palmCard.tag = 18
        palmCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(palmCard)
        
        let bagelCard = UIButton(type: .custom)
        bagelCard.setImage(UIImage(named: "BagelCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        bagelCard.setImage(UIImage(named: "BagelCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        bagelCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        bagelCard.adjustsImageWhenHighlighted = false
        bagelCard.tag = 19
        bagelCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(bagelCard)
        
        let mountainCard = UIButton(type: .custom)
        mountainCard.setImage(UIImage(named: "MountainCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        mountainCard.setImage(UIImage(named: "MountainCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        mountainCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        mountainCard.adjustsImageWhenHighlighted = false
        mountainCard.tag = 20
        mountainCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(mountainCard)
        
        let purpleCard = UIButton(type: .custom)
        purpleCard.setImage(UIImage(named: "PurpleCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        purpleCard.setImage(UIImage(named: "PurpleCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        purpleCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        purpleCard.adjustsImageWhenHighlighted = false
        purpleCard.tag = 21
        purpleCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(purpleCard)
        
        let sunsetCard = UIButton(type: .custom)
        sunsetCard.setImage(UIImage(named: "SunsetCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        sunsetCard.setImage(UIImage(named: "SunsetCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        sunsetCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        sunsetCard.adjustsImageWhenHighlighted = false
        sunsetCard.tag = 22
        sunsetCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(sunsetCard)
        
        let turtleCard = UIButton(type: .custom)
        turtleCard.setImage(UIImage(named: "TurtleCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        turtleCard.setImage(UIImage(named: "TurtleCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        turtleCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        turtleCard.adjustsImageWhenHighlighted = false
        turtleCard.tag = 23
        turtleCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(turtleCard)
        
        let carCard = UIButton(type: .custom)
        carCard.setImage(UIImage(named: "CarCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        carCard.setImage(UIImage(named: "CarCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        carCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        carCard.adjustsImageWhenHighlighted = false
        carCard.tag = 24
        carCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(carCard)
        
        let motorcycleCard = UIButton(type: .custom)
        motorcycleCard.setImage(UIImage(named: "MotorcycleCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        motorcycleCard.setImage(UIImage(named: "MotorcycleCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        motorcycleCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        motorcycleCard.adjustsImageWhenHighlighted = false
        motorcycleCard.tag = 25
        motorcycleCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(motorcycleCard)
        
        let catCard = UIButton(type: .custom)
        catCard.setImage(UIImage(named: "CatCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        catCard.setImage(UIImage(named: "CatCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        catCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        catCard.adjustsImageWhenHighlighted = false
        catCard.tag = 26
        catCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(catCard)
        
        let waterfallCard = UIButton(type: .custom)
        waterfallCard.setImage(UIImage(named: "WaterfallCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        waterfallCard.setImage(UIImage(named: "WaterfallCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        waterfallCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        waterfallCard.adjustsImageWhenHighlighted = false
        waterfallCard.tag = 27
        waterfallCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(waterfallCard)
        
        let roadCard = UIButton(type: .custom)
        roadCard.setImage(UIImage(named: "RoadCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        roadCard.setImage(UIImage(named: "RoadCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        roadCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        roadCard.adjustsImageWhenHighlighted = false
        roadCard.tag = 28
        roadCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(roadCard)
        
        let templeCard = UIButton(type: .custom)
        templeCard.setImage(UIImage(named: "TempleCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        templeCard.setImage(UIImage(named: "TempleCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        templeCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        templeCard.adjustsImageWhenHighlighted = false
        templeCard.tag = 29
        templeCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(templeCard)
        
        let storkCard = UIButton(type: .custom)
        storkCard.setImage(UIImage(named: "StorkCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        storkCard.setImage(UIImage(named: "StorkCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        storkCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        storkCard.adjustsImageWhenHighlighted = false
        storkCard.tag = 30
        storkCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(storkCard)
        
        let toiletPaperCard = UIButton(type: .custom)
        toiletPaperCard.setImage(UIImage(named: "ToiletPaperCard")?.imageWithBorder(width: 2, radius: 5, color: .black), for: .normal)
        toiletPaperCard.setImage(UIImage(named: "ToiletPaperCard")?.imageWithBorder(width: 2, radius: 5, color: .blue), for: .selected)
        toiletPaperCard.addTarget(self, action: #selector(saveAndAdjustCards), for: .touchUpInside)
        toiletPaperCard.adjustsImageWhenHighlighted = false
        toiletPaperCard.tag = 31
        toiletPaperCard.frame = CGRect(x: 0, y: 0, width: 69, height: 100)
        cardOptions.append(toiletPaperCard)
        
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
    
    func resetSelectedNumbers() {
        for option in numberOptions {
            option.isSelected = false
        }
    }
    
    @objc func saveNumberOfCards(_ sender: UIButton) {
        resetSelectedNumbers()
        
        switch sender.title(for: .normal) {
        case "8":
            defaults.set(8, forKey: "NumberOfCards")
            numberOptions[0].isSelected = true
            currentNumberOfCards = 8
        case "16":
            defaults.set(16, forKey: "NumberOfCards")
            numberOptions[1].isSelected = true
            currentNumberOfCards = 16
        case "24":
            defaults.set(24, forKey: "NumberOfCards")
            numberOptions[2].isSelected = true
            currentNumberOfCards = 24
        case "32":
            defaults.set(32, forKey: "NumberOfCards")
            numberOptions[3].isSelected = true
            currentNumberOfCards = 32
        default:
            defaults.set(40, forKey: "NumberOfCards")
            numberOptions[4].isSelected = true
            currentNumberOfCards = 40
        }
        
        fillCardsSelected()
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
        
        fillCardsSelected()
    }
    
    func fillCardsSelected() {
        if selectedCardTags.count < currentNumberOfCards / 2 {
            // fills space up to amount of cards necessary in tags
            while selectedCardTags.count < currentNumberOfCards / 2 || selectedCardTags.isEmpty {
                var i = 0
                while selectedCardTags.contains(cardOptions[i].tag) {
                    i += 1
                }
                selectedCardTags.append(cardOptions[i].tag)
            }
        } else if selectedCardTags.count == currentNumberOfCards / 2 {
            // do nothing this is state we want
        } else {
            // removes the excess
            while selectedCardTags.count > currentNumberOfCards / 2 {
                selectedCardTags.removeFirst()
            }
        }
        
        setSelectedCards()
        
        defaults.set(selectedCardTags, forKey: "CardFrontTags")
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
