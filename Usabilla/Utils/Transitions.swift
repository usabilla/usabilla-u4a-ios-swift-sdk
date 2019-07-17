//
//  UIViewController.swift
//  Usabilla
//
//  Created by Anders Liebl on 15/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class BottomUpTransistion: NSObject, UIViewControllerAnimatedTransitioning {
    let presenting: Bool
    let duration: TimeInterval = TimeInterval(UINavigationControllerHideShowBarDuration)

    init(presenting: Bool = true) {
        self.presenting = presenting
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }

        if presenting {
            container.addSubview(toView)
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
        toView.frame.origin = CGPoint(x: 0, y: toView.frame.height)

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            toView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
class TopDownTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let presenting: Bool
    let duration: TimeInterval = TimeInterval(UINavigationControllerHideShowBarDuration)

    init(presenting: Bool = false) {
        self.presenting = presenting
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }

        if presenting {
            container.addSubview(toView)
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
        fromView.frame.origin = CGPoint(x: 0, y: 0)

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            fromView.frame.origin = CGPoint(x: 0, y: fromView.frame.height)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}

class LeftToRightTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let presenting: Bool
    let duration: TimeInterval = TimeInterval(UINavigationControllerHideShowBarDuration)

    init(presenting: Bool = true) {
        self.presenting = presenting
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }

        if presenting {
            container.addSubview(toView)
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
        toView.frame.origin = CGPoint(x: toView.frame.width, y: 0)

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            toView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { _ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}

class RightToLeftTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let presenting: Bool
    let duration: TimeInterval = TimeInterval(UINavigationControllerHideShowBarDuration)
    
    init(presenting: Bool = false) {
        self.presenting = presenting
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        if presenting {
            container.addSubview(toView)
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
        fromView.frame.origin = CGPoint(x: 0, y: 0)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            fromView.frame.origin = CGPoint(x: fromView.frame.width, y: 0)
        }, completion: { _ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
