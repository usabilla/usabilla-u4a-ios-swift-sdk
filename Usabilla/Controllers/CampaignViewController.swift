//
//  CampaignViewController.swift
//  Usabilla
//
//  Created by Benjamin Grima on 21/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

protocol CampaignViewControllerDelegate: class {
    func campaignDidEnd()
}

class CampaignViewController: UIViewController {

    let sideMargin: CGFloat = 0
    let topMargin: CGFloat = 0
    let viewModel: CampaignViewModel
    let transition = CampaignAnimator()

    fileprivate weak var delegate: CampaignViewControllerDelegate?

    var backgroundLayer: UIView?
    var containerView: UIView?
    var introView: UBIntroOutroView?
    var formNavigationController: UINavigationController?
    var toast: UBToast?
    var animationSpeed = 0.3

    var modalTopConstraint: NSLayoutConstraint?
    var modalRightConstraint: NSLayoutConstraint?
    var modalBottomConstraint: NSLayoutConstraint?
    var modalLeftConstraint: NSLayoutConstraint?

    private var modalsMargin: UIEdgeInsets {
        return UIEdgeInsets(top: topMargin, left: sideMargin, bottom: sideMargin, right: sideMargin)
    }

    override func viewDidLoad() {
        if let introPageViewModel = viewModel.introPageViewModel {
            let introView = UBIntroOutroView(viewModel: introPageViewModel)
            self.introView = introView
            introView.delegate = self

            var animations: (() -> Void)?

            if viewModel.introPageViewModel?.displayMode == .alert {
                createBackgroundLayer()
                animations = {
                    self.backgroundLayer?.alpha = 1
                }
            }
            view.addSubview(introView)
            viewModel.introPresenter?.present(view: introView, inView: view, animations: animations)
            return
        }
    }

    override func loadView() {
        self.view = UBCustomTouchableView()
        self.view.frame = UIScreen.main.bounds
    }

    init(viewModel: CampaignViewModel, delegate: CampaignViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(CampaignViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CampaignViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        guard let info: [AnyHashable: Any] = notification.userInfo,
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let bottomConstraint = modalBottomConstraint else { return }

        let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue ?? 0.5
        let curve = UIViewAnimationOptions(rawValue: UInt(duration))
        let offset = -sideMargin - keyboardFrame.height
        let form = self.formNavigationController?.childViewControllers[0] as? FormViewController

        UIView.animate(withDuration: duration, delay: 0, options: curve, animations: {
            bottomConstraint.constant = offset
            self.view.layoutIfNeeded()
            form?.pageViewController.tableView.beginUpdates()
            form?.pageViewController.tableView.endUpdates()
        })
    }

    func keyboardWillHide(notification: NSNotification) {
        guard let _: [AnyHashable: Any] = notification.userInfo, let bottomConstraint = modalBottomConstraint else { return }

        let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue ?? 0.5
        let curve = UIViewAnimationOptions(rawValue: UInt(duration))
        let offset = -sideMargin

        UIView.animate(withDuration: duration, delay: 0, options: curve, animations: {
            bottomConstraint.constant = offset
            self.view.layoutIfNeeded()

        })
    }

    func createBackgroundLayer() {
        guard backgroundLayer == nil else {
            return
        }
        let backgroundView = UIView()
        backgroundView.alpha = 0.0
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundLayer = backgroundView
        // swiftlint:disable:next force_unwrapping
        view.insertSubview(backgroundLayer!, at: 0)
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showModalForm() {
        let formController = FormViewController(viewModel: viewModel.formViewModel)
        let rect = introView?.frame ?? CGRect()
        formController.initialRect = rect
        let base = UBNavigationController(rootViewController: formController)
        formController.delegate = self

        formNavigationController = base
        guard let introview = introView else {
            return
        }

        if DeviceInfo.isIPad() {
            base.transitioningDelegate = self
            base.view.alpha = 1
            base.modalPresentationStyle = .formSheet
            base.preferredContentSize = DeviceInfo.preferedFormSize()
            transition.originFrame = rect
            transition.duration = animationSpeed
            self.present(base, animated: true, completion: nil)
            UIView.animate(withDuration: 0.2, animations: {
                self.introView?.alpha = 0
            }, completion: { _ in
                self.viewModel.introPresenter?.dismiss(view: introview, inView: self.view, animations: {
                }, completion: {
                    self.introView?.removeFromSuperview()
                })
            })
            return
        }

        addChildViewController(base)
        view.addSubview(base.view)

        base.view.alpha = 0
        base.view.layer.cornerRadius = 0
        base.view.layer.masksToBounds = true

        base.view.translatesAutoresizingMaskIntoConstraints = false
        createBackgroundLayer()

        base.view.frame = rect
        base.view.alpha = 1
        modalTopConstraint = base.view.topAnchor.constraint(equalTo: introview.topAnchor).activate()
        modalLeftConstraint = base.view.leftAnchor.constraint(equalTo: introview.leftAnchor).activate()
        modalRightConstraint = base.view.rightAnchor.constraint(equalTo: introview.rightAnchor).activate()
        modalBottomConstraint = base.view.bottomAnchor.constraint(equalTo: introview.bottomAnchor).activate()
        updateModalConstraints()

        self.backgroundLayer?.alpha = 1

        view.layoutIfNeeded()
        UIView.animate(withDuration: animationSpeed, animations: {
            self.introView?.alpha = 0
            base.view.frame = UIScreen.main.bounds
            base.view.layoutIfNeeded()
            self.modalTopConstraint = base.view.topAnchor.constraint(equalTo: self.view.topAnchor).activate()
            self.modalLeftConstraint = base.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).activate()
            self.modalRightConstraint = base.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).activate()
            self.modalBottomConstraint = base.view.bottomAnchor.constraint(equalTo:self.view.bottomAnchor).activate()
            self.updateModalConstraints()

        }, completion: { _ in
            self.viewModel.introPresenter?.dismiss(view: introview, inView: self.view, animations: {
            }, completion: {
  
                self.introView?.removeFromSuperview()
            })

        })
    }

    func removeFormController(completion: (() -> Void)?) {
        if DeviceInfo.isIPad() {
            self.formNavigationController?.dismiss(animated: true, completion: {
                completion?()
            })
            return
        }
        let position = (viewModel.form.pages[0] as? IntroPageModel)?.displayMode ?? .bannerBottom
        let calculatedY = position == .bannerTop ? -view.frame.size.height : view.frame.size.height

        UIView.animate(withDuration: animationSpeed, animations: {
            self.formNavigationController?.view.frame = CGRect(x: 0, y: calculatedY, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.formNavigationController?.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.formNavigationController?.view.alpha = 0
            self.backgroundLayer?.alpha = 0
            // swiftlint:disable:next multiple_closures_with_trailing_closure
        }) { _ in
            self.formNavigationController?.view.removeFromSuperview()
            self.formNavigationController?.removeFromParentViewController()
            completion?()
        }
    }

    func showToast() {
        let bannerPosition = (viewModel.form.pages[0] as? IntroPageModel)?.displayMode ?? IntroPageDisplayMode.bannerBottom
        let thankYoutext = viewModel.toastPageViewModel?.text ?? ""
        let estimatedDuration: UBToastDuration = thankYoutext.count > 40 && UIAccessibilityIsVoiceOverRunning() ? .long : .normal
        toast = UBToast(delegate: self, text: thankYoutext, duration: estimatedDuration)
        toast?.show(position: bannerPosition) {
            self.closeCampaign()
        }
    }

    func closeCampaign(atPageIndex index: Int? = nil) {
        let result = FeedbackResult(rating: viewModel.ratingValueForReview, abandonedPageIndex: index)
        UsabillaInternal.delegate?.campaignDidClose(withFeedbackResult: result, isRedirectToAppStoreEnabled: viewModel.formViewModel.model.redirectToAppStore)
        self.delegate?.campaignDidEnd()
    }

    private func updateModalConstraints() {
        modalTopConstraint?.constant = modalsMargin.top
        modalLeftConstraint?.constant = modalsMargin.left
        modalRightConstraint?.constant = -modalsMargin.right
        modalBottomConstraint?.constant = -modalsMargin.bottom + 50
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        introView?.setNeedsUpdateConstraints()
        toast?.setNeedsUpdateConstraints()
        updateModalConstraints()
    }
}

extension CampaignViewController: UBIntroOutroViewDelegate {

    func introViewDidCancel(introView: UBIntroOutroView) {
        var animations: (() -> Void)?
        if viewModel.introPageViewModel?.displayMode == .alert {
            animations = {
                self.backgroundLayer?.alpha = 0.0
            }
        }

        viewModel.introPresenter?.dismiss(view: introView, inView: self.view, animations: animations) {
            self.backgroundLayer?.removeFromSuperview()
            introView.removeFromSuperview()
            self.closeCampaign(atPageIndex: 0)
        }
    }

    func introViewDidContinue(introView: UBIntroOutroView) {
        viewModel.introViewDidContinue()
        if viewModel.currentPageType == .toast {
            viewModel.introPresenter?.dismiss(view: introView, inView: view, animations: nil, completion: {
                self.showToast()
            })
            return
        }
        showModalForm()
    }
}

extension CampaignViewController: FormViewControllerDelegate {

    func formWillClose(_ formViewController: FormViewController) {
        removeFormController {
            self.closeCampaign(atPageIndex: formViewController.viewModel.currentPageIndex)
        }
    }

    func pageDidTurn(oldPageModel: PageModel, oldPageIndex: Int, newPageIndex: Int, nextPageType: PageType, formViewController: FormViewController) {
        viewModel.pageDidTurn(pageIndex: oldPageIndex, pageModel: oldPageModel, nextPageType: nextPageType)

        if formViewController.viewModel.isItTheEnd {
            removeFormController {
                self.showToast()
            }
        }
    }
}

extension CampaignViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
