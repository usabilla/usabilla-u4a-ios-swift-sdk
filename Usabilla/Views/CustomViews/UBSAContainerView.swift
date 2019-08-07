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

struct UBSAContainerViewValues {
    static let trashViewHeight: CGFloat = 48
    static let trashViewWidth: CGFloat = 48
    static let cornerRadius: CGFloat = 44
    static let trashAreaWidth: CGFloat = 0
    static let trashAreaHeight: CGFloat = 0
    static let trashViewWidthMargin: CGFloat = 10.0
    static let trashViewHeightMargin: CGFloat = 10.0
    static let trashViewAnimationTime: TimeInterval = 0.3
    static let trashViewDelay: TimeInterval = 0.5
    static let actionViewWidth: CGFloat = 100.0
    static let actionViewHeight: CGFloat = 100.0
    static let stackViewWidth: CGFloat = 0.0
    static let stackViewHeight: CGFloat = 0.0
    static let trashViewAlpha: CGFloat = 0.0
    static let imageCornerRadius: CGFloat = 4.0
}

class UBSAContainerView: UIView {
    private var showTrashTimer: Timer?
    private var trashVisible = false
    private let backgroundIndex = 0
    private let stackViewIndex = 1
    private let trashViewIndex = 2
    private let actionViewindex = 3
    private var drawingModeOn = false

    fileprivate lazy var backgroundView: UIImageView = {
        let imageView = UIImageView(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = UBSAContainerViewValues.imageCornerRadius
        imageView.layer.masksToBounds = true
        insertSubview(imageView, at: backgroundIndex)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    fileprivate lazy var stackView: UIView = {
        let stackView = UIView(frame: frame)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(stackView, at: stackViewIndex)
        stackView.clipsToBounds = true
        stackView.contentMode = UIViewContentMode.scaleAspectFill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: UBSAContainerViewValues.stackViewWidth),
            stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: UBSAContainerViewValues.stackViewWidth)
        ])
        return stackView
    }()

    fileprivate lazy var actionView: UIView = {
        let action = UIView(frame: frame)
        action.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(action, at: actionViewindex)
        action.clipsToBounds = true
        action.contentMode = UIViewContentMode.scaleAspectFill
        action.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            action.centerYAnchor.constraint(equalTo: centerYAnchor),
            action.centerXAnchor.constraint(equalTo: centerXAnchor),
            action.heightAnchor.constraint(greaterThanOrEqualToConstant: UBSAContainerViewValues.actionViewHeight),
            action.widthAnchor.constraint(greaterThanOrEqualToConstant: UBSAContainerViewValues.actionViewWidth)
        ])
        return action
    }()

    fileprivate lazy var trashView: UIImageView = {
        let trashimage = UIImage.getImageFromSDKBundle(name: "ic_trash")
        let trashView = UIImageView(image: trashimage)
        trashView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(trashView, at: trashViewIndex)
        trashView.backgroundColor = .clear
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
        layer.cornerRadius = UBSAContainerViewValues.cornerRadius
        layer.masksToBounds = true
        backgroundView.isHidden = false
        stackView.isHidden = false
        trashView.alpha = UBSAContainerViewValues.trashViewAlpha
        actionView.isHidden = false
    }
    func reset() {
        trashView.alpha = UBSAContainerViewValues.trashViewAlpha
        if showTrashTimer != nil {
            showTrashTimer?.invalidate()
            showTrashTimer = nil
        }
        stackView.subviews.forEach { $0.removeFromSuperview() }
    }
}

extension UBSAContainerView: UBSADragableImageViewProtocol {
    func startedTouchedSubView(_ subview: UBSADragableImageView) {
        if showTrashTimer == nil {
            let timer = Timer.scheduledTimer(timeInterval: UBSAContainerViewValues.trashViewDelay, target: self, selector: #selector(showTrash), userInfo: nil, repeats: false)
            showTrashTimer = timer
        }
    }
    // If the user touch down, and up ithout moving the view, it will not be removed
    func endedTouchedSubView(_ subview: UBSADragableImageView) {
        if showTrashTimer == nil {
            showTrashTimer?.invalidate()
            showTrashTimer = nil
        }
        hideTrash()
    }

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
            let timer = Timer.scheduledTimer(timeInterval: UBSAContainerViewValues.trashViewDelay, target: self, selector: #selector(showTrash), userInfo: nil, repeats: false)
            showTrashTimer = timer
        }
        let fra1 = convert(trashView.frame, to: stackView)
        let fra2 = convert(subview.frame, to: self)
        // different coordinates systems, need to convert to same
        if fra2.intersects(fra1) {
            enableTrash()
            return
        }
        closeTrash()

    }
    @objc
    fileprivate func showTrash() {
        trashVisible = true
        UIView.animate(withDuration: UBSAContainerViewValues.trashViewAnimationTime, animations: {
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
        UIView.animate(withDuration: UBSAContainerViewValues.trashViewAnimationTime, animations: {
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

    /*
      - this method resizes actionview, stackview and posistions the trash can, depending on the size of the background image
      -  ist called when the actionView is added
     */
    fileprivate func sizeViewsCorrectly() {
        actionView.frame = workingFrame()
        stackView.frame = workingFrame()
        trashView.frame = CGRect(x: stackView.frame.origin.x + stackView.frame.size.width - UBSAContainerViewValues.trashViewWidth - UBSAContainerViewValues.trashViewWidthMargin,
                                 y: stackView.frame.origin.y + stackView.frame.size.height - UBSAContainerViewValues.trashViewHeight - UBSAContainerViewValues.trashViewHeightMargin,
                                 width: UBSAContainerViewValues.trashViewWidth, height: UBSAContainerViewValues.trashViewHeight)

    }
}
// MARK: - add / remove methods
extension UBSAContainerView {
    func backgroundImage() -> UIImage? {
        return backgroundView.image
    }

    func setBackgroundImage(_ image: UIImage) {
        let newImage = image.fixSizeAndOrientation(cornerRadius: UBSAContainerViewValues.imageCornerRadius)
        if image.size.width > image.size.height {
            backgroundView.contentMode = UIViewContentMode.scaleAspectFit
        } else {
            backgroundView.contentMode = UIViewContentMode.scaleAspectFill
        }
        backgroundView.image = newImage
     }

    func workingFrame() -> CGRect {
        if let size = backgroundView.image?.size {
            let scalex = frame.size.width/size.width
            let scaley = frame.size.height/size.height
            let scale = min(scalex, scaley)
            let offsetX = CGFloat((frame.size.width-(size.width*scale))/2)
            let offsetY = CGFloat((frame.size.height-(size.height*scale))/2)

            let rect = CGRect(x: offsetX, y: offsetY, width: size.width*scale, height: size.height*scale)
            return rect
        }
        return .zero
    }

    /**
     Add the Action view on top of all views in the
     - Paramater view: actionview, the view to add on top of all viws
     **/
    func addActionView(_ view: UIView) {
        // the actionview is added as the first task in the process, therefor all the views should be size correct
        // here.  Sized correct is dependent on the background images size.
        drawingModeOn = true
        sizeViewsCorrectly()
        actionView.addSubview(view)
        actionView.isHidden = false
    }

    /**
     Remove the Action view. User is responsible for removeing the view whan
     action has ben completed inside the action view
     **/
    func removeActionView() {
        if let view = actionView.subviews.last {
            view.removeFromSuperview()
        }
        actionView.isHidden = true
    }

    /**
     Overrides the UIView addSubView method and adds the subview to stackview
     - Parameter view: the flatten view as UIImageView
     **/
    override func addSubview(_ view: UIView) {
        addView(view)
    }

    /**
     Works as  UIView addSubView method and adds the subview to stackview
     - Parameter view: the flatten view as UIImageView
     - Parameter type: the drawingtool type of the view, defaults
     **/

    func addView(_ view: UIView, type: UBSADrawingToolType = .pen) {
        view.tag = type.rawValue
        stackView.frame = workingFrame()
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
        return  self.screenCapture.cropAlpha()
    }

    func numbeOfDrawings() -> Int? {
        if drawingModeOn {
            let array = stackView.subviews.compactMap({ $0.tag == UBSADrawingToolType.pen.rawValue})
            return array.count
        } else {
            return nil
        }
    }
}
