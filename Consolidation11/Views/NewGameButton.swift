//
//  NewGameButton.swift
//  Consolidation11
//
//  Created by Matt Free on 5/3/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

/// Button to start a new game
class NewGameButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupButton()
    }
    
    /// Configures the button
    private func setupButton() {
        setTitleColor(.magenta, for: .normal)
        setTitle("New Game", for: .normal)
        titleLabel?.font = UIFont(name: Constants.FontNames.kranky, size: 26)
        titleLabel?.textAlignment = .center
        
        backgroundColor = UIColor.darkGray
        layer.cornerRadius = 25
        layer.borderWidth = 5
        layer.borderColor = UIColor.black.cgColor
        
        isHidden = true
        alpha = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Shows the button
    func show() {
        isHidden = false
        
        UIView.animate(withDuration: TimeInterval(0.5)) {
            self.alpha = 0.75
        }
    }
    
    /// Hides the button
    func hide() {
        UIView.animate(withDuration: TimeInterval(0.5)) {
            self.alpha = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isHidden = true
        }
    }
}
