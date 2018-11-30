//
//  CampaignAnimator.swift
//  Usabilla
//
//  Created by Anders Liebl on 29/11/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import UIKit
class CampaignAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.5
    var presenting = true
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)

        if let toview = toView { // We are animating in
            var initialFrame = originFrame
            let finalFrame = UIScreen.main.bounds
            let xScaleFactor = initialFrame.width / finalFrame.width
            let yScaleFactor = initialFrame.height / finalFrame.height
            let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

            toview.transform = scaleTransform
            toview.center = CGPoint( x: initialFrame.midX, y: initialFrame.midY)
            toview.clipsToBounds = true
            containerView.addSubview(toview)

            UIView.animate(withDuration: duration, delay: 0.0,
                           usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0,
                           animations: {
                            toview.transform = CGAffineTransform.identity
                            toview.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            },
                           completion: { _ in
                            transitionContext.completeTransition(true)
            })
            return
        }
        // Animating out
        if let fromview = fromView {
            let terminatingY = originFrame.origin.y > UIScreen.main.bounds.size.height / 2 ? UIScreen.main.bounds.size.height : -100
            let initialFrame = fromview.frame
            let finalFrame = CGRect(x: UIScreen.main.bounds.size.width/2-100, y: terminatingY, width: 200, height: 100)
            let xScaleFactor = finalFrame.width / initialFrame.width
            let yScaleFactor = finalFrame.height / initialFrame.height
            let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

            UIView.animate(withDuration: duration, animations: {
                fromview.transform = scaleTransform
                fromview.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            }, completion: { _ in
                      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
