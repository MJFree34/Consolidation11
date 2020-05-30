//
//  UIViewController+Extensions.swift
//  Consolidation11
//
//  Created by Matt Free on 5/30/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
