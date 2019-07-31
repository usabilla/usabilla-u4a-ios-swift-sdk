//
//  UBSAContainerView.swift
//  Usabilla
//
//  Created by Anders Liebl on 24/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

//  This view implemnts several featues:
//   - Background image view
//   - Container view, where aditional views can be added and moved (if of type UBSDragableImageView)
//   - Trash, where views from the containerview will be removed, if dropped over the trash
//       the trashview appears after 1 second of dragging / touching a view in the container
//   - Actionview. A view put on top of all the views, and could be manipulated from other classes
//
//   The views will be merged and returned as one view calling the finalImage method
import UIKit

class UBSAContainerView: UIView {
    private var showTrashTimer: Timer?
    private let backgroundIndex = 0
    private var stackViewIndex = 1
    private var trashViewIndex = 2
    private var indexOfActionView = 3
    private var trashVisible = false
    
    private let trashAreaWidth: CGFloat = 0
    private let trashAreaHeight: CGFloat = 0
    private let trashViewAnimationTime: TimeInterval = 0.3
    private let trashViewDelay: TimeInterval = 1.0
    
    fileprivate lazy var backgroundView: UIImageView = {
        let imageView = UIImageView(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(imageView, at: backgroundIndex)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    fileprivate lazy var stackView: UIView = {
        let stackView = UIView(frame: frame)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(stackView, at: stackViewIndex)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.contentMode = UIViewContentMode.scaleAspectFill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    fileprivate lazy var trashView: UIImageView = {
        let trashimage = UIImage.getImageFromSDKBundle(name: "ic_trash")
        let trashView = UIImageView(image: trashimage)
        trashView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(trashView, at: trashViewIndex)
        trashView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: UBDimensions.UBSAContainerView.trashViewTrailingMargin).isActive = true
        trashView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UBDimensions.UBSAContainerView.trashViewBottomMargin ).isActive = true
        trashView.heightAnchor.constraint(equalToConstant: UBDimensions.UBSAContainerView.trashViewHeight).isActive = true
        trashView.widthAnchor.constraint(equalToConstant: UBDimensions.UBSAContainerView.trashViewWidth).isActive = true
        trashView.translatesAutoresizingMaskIntoConstraints = false
        trashView.alpha = UBAlpha.zeroAlpha.rawValue
        return trashView
    }()

   override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }

    fileprivate func configureView() {
        clipsToBounds = true
        backgroundColor = .clear
        layer.cornerRadius = UBDimensions.UBSAContainerView.cornerRadius
        layer.masksToBounds = true
        backgroundView.isHidden = false
        stackView.isHidden = false
        trashView.alpha = 0.0
    }
    func reset() {
        trashView.isHidden = true
        if showTrashTimer != nil {
            showTrashTimer?.invalidate()
            showTrashTimer = nil
        }
        stackView.subviews.forEach { $0.removeFromSuperview() }
    }
}


extension UBSAContainerView: UBSADragableImageViewProtocol {
    func movedSubview(_ subview: UBSADragableImageView, center: CGPoint) {
        if showTrashTimer == nil {
            showTrashTimer?.invalidate()
            showTrashTimer = nil
        }
        if trashVisible {
            if let index = stackView.subviews.index(of: subview) {
                stackView.subviews[index].removeFromSuperview()
            }
        }
        hideTrash()

    }

    func draggingSubview(_ subview: UBSADragableImageView, center: CGPoint) {
        if showTrashTimer == nil {
            let timer = Timer.scheduledTimer(timeInterval: trashViewDelay, target: self, selector: #selector(showTrash), userInfo: nil, repeats: false)
            showTrashTimer = timer
        }

        if subview.frame.intersects(CGRect(x: trashView.frame.origin.x-trashAreaWidth, y: trashView.frame.origin.y-trashAreaHeight, width: trashAreaWidth, height: trashAreaHeight )) {
            enableTrash()
            return
        }
        closeTrash()

    }
    @objc
    fileprivate func showTrash() {
        trashVisible = true
        UIView.animate(withDuration: trashViewAnimationTime, animations: {
            self.trashView.alpha = UBAlpha.fullAlpha.rawValue
        })
    }

    @objc
    fileprivate func hideTrash() {
        if showTrashTimer != nil {
            showTrashTimer?.invalidate()
        }
        showTrashTimer = nil
        trashVisible = false
        UIView.animate(withDuration: trashViewAnimationTime, animations: {
            self.trashView.alpha = UBAlpha.zeroAlpha.rawValue
        })

    }

    fileprivate func enableTrash() {
        let trashimage = UIImage.getImageFromSDKBundle(name: "ic_open_trash")
        trashView.image = trashimage
        trashVisible = true
    }
    fileprivate func closeTrash() {
        let trashimage = UIImage.getImageFromSDKBundle(name: "ic_trash")
        trashView.image = trashimage
        trashVisible = false
    }

}
// MARK: - add / remove methods
extension UBSAContainerView {
    func backgroundImage() -> UIImage? {
        return backgroundView.image
    }
    func setBackgroundImage(_ image: UIImage) {
        backgroundView.image = image
     }

    /**
     Add the Action view on top of all views in the
     - Paramater view: actionview, the view to add on top of all viws
     **/
    func addActionView(_ view: UIView) {
        insertSubview(view, at: indexOfActionView)
    }
    
    /**
     Remove the Action view. User is responsible for removeing the view whan
     action has ben completed inside the action view
     **/
    func removeActionView() {
        let view = subviews[indexOfActionView]
        view.removeFromSuperview()
    }

    /**
     Overrides the UIView addSubView method and adds the subview to stackview
     - Parameter view: the flatten view as UIImageView
     **/
    override func addSubview(_ view: UIView) {
        if let theView =  view as? UBSADragableImageView {
            theView.delegate = self
            stackView.addSubview(theView)
            return
        }
        stackView.addSubview(view)
    }
    
    /**
     Works as  UIView addSubView method and adds the subview to stackview
     - Parameter view: the flatten view as UIImageView
     **/

    func addView(_ view: UIView) {
        if let theView =  view as? UBSADragableImageView {
            theView.delegate = self
            stackView.addSubview(theView)
            return
        }
        stackView.addSubview(view)
    }

    /**
     All views presented are flattend and return
     - returns: the flatten view as UIImageView
     **/
    func finalImage() -> UIImage {
        return  self.screenCapture
    }
}
