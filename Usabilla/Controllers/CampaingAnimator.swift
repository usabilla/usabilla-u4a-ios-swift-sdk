//
//  CampaignAnimator.swift
//  Usabilla
//
//  Created by Anders Liebl on 29/11/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import UIKit
class CampaignAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var duration = 0.5
    var presenting = true
    var originFrame = CGRect.zero
    var container: UIView?
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)

        if let toview = toView { // We are animating in
            let initialFrame = originFrame
            let finalFrame = UIScreen.main.bounds
            let xScaleFactor = (initialFrame.width + 200) / finalFrame.width
            let yScaleFactor = (initialFrame.height + 50) / finalFrame.height
            let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
            toview.transform = scaleTransform
            toview.center = CGPoint( x: initialFrame.midX, y: initialFrame.midY)
            toview.clipsToBounds = true
            if let aContainer = container {
                aContainer.addSubview(toview)
            } else {
                containerView.addSubview(toview)
            }
            UIView.animate(withDuration: duration, delay:
                0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, animations: {
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
            let finalFrame = CGRect(x: (UIScreen.main.bounds.size.width-DeviceInfo.preferedFormSize().width) / 2,
                                    y: terminatingY,
                                    width: DeviceInfo.preferedFormSize().width,
                                    height: DeviceInfo.preferedFormSize().height)
            let xScaleFactor = finalFrame.width / initialFrame.width
            let yScaleFactor = finalFrame.height / initialFrame.height
            let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

            UIView.animate(withDuration: duration - 1, animations: {
                fromview.transform = scaleTransform
                fromview.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            }, completion: { _ in
                      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
