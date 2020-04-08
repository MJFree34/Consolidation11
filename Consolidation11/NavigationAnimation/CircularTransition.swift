//
//  CircularTransition.swift
//  Consolidation11
//
//  Created by Matt Free on 4/5/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

protocol CircleTransitionable {
    var button: UIButton { get }
    var mainView: UIView { get }
}

class CircularTransition: NSObject, UIViewControllerAnimatedTransitioning {
    weak var context: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? CircleTransitionable, let toVC = transitionContext.viewController(forKey: .to) as? CircleTransitionable, let snapshot = fromVC.mainView.snapshotView(afterScreenUpdates: false) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        
        let backgroundView = UIView()
        backgroundView.frame = toVC.mainView.frame
        backgroundView.backgroundColor = fromVC.mainView.backgroundColor
        
        containerView.addSubview(snapshot)
        fromVC.mainView.removeFromSuperview()
        
        animateOldTextOffscreen(fromView: snapshot)
        
        containerView.addSubview(toVC.mainView)
        animate(toView: toVC.mainView, fromButton: fromVC.button)
    }
    
    func animateOldTextOffscreen(fromView: UIView) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseIn], animations: {
            fromView.center = CGPoint(x: fromView.center.x - 1300, y: fromView.center.y + 1500)
            fromView.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
        }, completion: nil)
    }
    
    func animate(toView: UIView, fromButton triggerButton: UIButton) {
        // original circle
        let rect = CGRect(x: triggerButton.frame.origin.x, y: triggerButton.frame.origin.y, width: triggerButton.frame.width, height: triggerButton.frame.width)
        let circleMaskPathInitial = UIBezierPath(ovalIn: rect)
        
        // final circle
        let fullHeight = toView.bounds.height
        let extremePoint = CGPoint(x: triggerButton.center.x, y: fullHeight)
        let radius = sqrt((extremePoint.x * extremePoint.x) + (extremePoint.y * extremePoint.y))
        let circleMaskPathFinal = UIBezierPath(ovalIn: triggerButton.frame.insetBy(dx: -radius, dy: -radius))
        
        // mask
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.cgPath
        toView.layer.mask = maskLayer
        
        // creating animation from start circle to end circle
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
        maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
        maskLayerAnimation.duration = 0.15
        maskLayerAnimation.delegate = self
        
        // adding animation to mask
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
}

extension CircularTransition: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        context?.completeTransition(true)
    }
}
