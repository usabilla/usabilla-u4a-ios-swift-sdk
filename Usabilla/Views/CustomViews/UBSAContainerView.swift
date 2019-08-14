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
    static let stackViewWidth: CGFloat = 100.0
    static let stackViewHeight: CGFloat = 100.0
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
    
    private var stackViewHeigthConstraint: NSLayoutConstraint?
    private var stackViewWidthConstraint: NSLayoutConstraint?
    private var actionViewHeigthConstraint: NSLayoutConstraint?
    private var actionViewWidthConstraint: NSLayoutConstraint?

    private var currentSize: CGRect?

    fileprivate lazy var backgroundView: UIImageView = {
        let imageView = UIImageView(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = UBSAContainerViewValues.imageCornerRadius
        imageView.layer.masksToBounds = true
        insertSubview(imageView, at: backgroundIndex)
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
        return stackView
    }()

    fileprivate lazy var actionView: UIView = {
        let action = UIView(frame: frame)
        action.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(action, at: actionViewindex)
        action.clipsToBounds = true
        action.contentMode = UIViewContentMode.scaleAspectFill
        action.translatesAutoresizingMaskIntoConstraints = false
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

    func configureStackViewConstraints() {
        // Only the first time here, we will set constraints. This will ensure that
        // evrything stays in place during rotation (or maintain position)
        if stackViewHeigthConstraint != nil { return }

        stackViewWidthConstraint?.isActive = false
        stackViewHeigthConstraint?.isActive = false
        stackViewHeigthConstraint = stackView.heightAnchor.constraint(equalToConstant: stackView.frame.size.height)
        stackViewWidthConstraint = stackView.widthAnchor.constraint(equalToConstant: stackView.frame.size.width)
        stackViewWidthConstraint?.isActive = true
        stackViewHeigthConstraint?.isActive = true
    }

    fileprivate func configureView() {
        clipsToBounds = true
        backgroundColor = .clear
        layer.cornerRadius = UBSAContainerViewValues.cornerRadius
        layer.masksToBounds = true
        backgroundView.isHidden = false
        stackView.isHidden = false

        backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        stackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        actionView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        actionView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true

        trashView.alpha = UBSAContainerViewValues.trashViewAlpha
        actionView.isHidden = false
    }

    override func updateConstraints() {
        super.updateConstraints()
    }

    func reset() {
        stackViewWidthConstraint?.isActive = false
        stackViewHeigthConstraint?.isActive = false
        stackViewWidthConstraint = nil
        stackViewHeigthConstraint = nil

        actionViewHeigthConstraint?.isActive = false
        actionViewWidthConstraint?.isActive = false
        actionViewHeigthConstraint = nil
        actionViewWidthConstraint = nil

        trashView.alpha = UBSAContainerViewValues.trashViewAlpha
        if showTrashTimer != nil {
            showTrashTimer?.invalidate()
            showTrashTimer = nil
        }
        stackView.subviews.forEach { $0.removeFromSuperview() }
        currentSize = nil
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
        setTrashPosition()
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
    func sizeViewsCorrectly() {
        actionView.frame = workingFrame()
        if stackViewWidthConstraint != nil {
            return}
        stackView.frame = workingFrame()
        configureStackViewConstraints()
        setTrashPosition()
    }

    func setTrashPosition() {
        let rightSide = min(stackView.frame.origin.x + stackView.frame.size.width, frame.size.width)
        let bottom = min(stackView.frame.origin.y + stackView.frame.size.height, frame.size.height)
        trashView.frame = CGRect(x: rightSide - UBSAContainerViewValues.trashViewWidth - UBSAContainerViewValues.trashViewWidthMargin,
                                 y: bottom - UBSAContainerViewValues.trashViewHeight - UBSAContainerViewValues.trashViewHeightMargin,
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
        backgroundView.contentMode = UIViewContentMode.scaleAspectFit
        backgroundView.image = newImage
     }

    func workingFrame() -> CGRect {
        if let size = backgroundView.image?.size {
            // calculate iPad
            if DeviceInfo.isIPad() || UIDevice.current.orientation.isPortrait {
                if size.width < size.height { // If the device is in portrait, we use the whole frame as size
                    let rect = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
                    currentSize = rect
                    return rect
                }
                // if not portrait we will use the other calculation
            }
            let scalex = frame.size.width/size.width
            let scaley = frame.size.height/size.height
            let scale = min(scalex, scaley)
            let viewWidth = size.width*scale
            let viewHeight = size.height*scale

            let offsetX = CGFloat((frame.size.width-viewWidth)/2)
            let offsetY = CGFloat((frame.size.height-viewHeight)/2)

            let rect = CGRect(x: offsetX, y: offsetY, width: viewWidth, height: viewHeight)
            currentSize = rect
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
        actionViewHeigthConstraint?.isActive = false
        actionViewWidthConstraint?.isActive = false
        actionViewHeigthConstraint = actionView.heightAnchor.constraint(equalToConstant: stackView.frame.size.height)
        actionViewWidthConstraint = actionView.widthAnchor.constraint(equalToConstant: stackView.frame.size.width)
        actionViewHeigthConstraint?.isActive = true
        actionViewWidthConstraint?.isActive = true
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
