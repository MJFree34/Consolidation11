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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting background pic
        view.backgroundColor = UIColor.init(patternImage: currentBackground)
        
        // giving the ability to swipe from the left of screen to pop to rootView
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        // creating backButton
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "ArrowButton"), for: .normal)
        backButton.addTarget(self, action: #selector(moveToGameViewController), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        backButton.showsTouchWhenHighlighted = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
        ])
    }
    
    @objc func moveToGameViewController() {
        navigationController?.popViewController(animated: true)
    }
}
