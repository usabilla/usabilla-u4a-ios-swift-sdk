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
    internal let distanceFromTop: CGFloat = 100.0
    internal let offset: CGFloat = 10

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
        if DeviceInfo.isIPad() {
            showModalFormiPad()
            return
        }
        showModalFormiPhone()
    }

    private func showModalFormiPad () {
        let formController = FormViewController(viewModel: viewModel.formViewModel)
        let rect = introView?.frame ?? CGRect()
        formController.initialRect = rect
        let base = UBNavigationController(rootViewController: formController)
        formController.delegate = self

        guard let introview = introView else {
            return
        }
        formNavigationController = base

        base.transitioningDelegate = self
        base.view.alpha = 1
        base.modalPresentationStyle = .formSheet
        base.preferredContentSize = DeviceInfo.preferedFormSize()
        transition.originFrame = rect
        transition.duration = 0.4
        self.present(base, animated: true, completion: nil)
        UIView.animate(withDuration: 0.0, delay: 0.2, options: [], animations: {
            introview.alpha = 0
        }, completion: { _ in
            self.viewModel.introPresenter?.dismiss(view: introview, inView: self.view, animations: {
            }, completion: {
                introview.removeFromSuperview()
            })
        })
    }

    private func showModalFormiPhone() {
        let formController = FormViewController(viewModel: viewModel.formViewModel)
        let rect = introView?.frame ?? CGRect()
        formController.initialRect = rect
        let base = UBNavigationController(rootViewController: formController)
        formController.delegate = self

        guard let introview = introView else {
            return
        }
        formNavigationController = base

        addChildViewController(base)
        view.insertSubview(base.view, belowSubview: introview)

        base.view.alpha = 0
        base.view.layer.cornerRadius = 0
        base.view.layer.masksToBounds = true

        base.view.translatesAutoresizingMaskIntoConstraints = false
        createBackgroundLayer()

        base.view.frame = rect
        base.view.alpha = 0
        modalTopConstraint = base.view.topAnchor.constraint(equalTo: introview.topAnchor).activate()
        modalLeftConstraint = base.view.leftAnchor.constraint(equalTo: introview.leftAnchor).activate()
        modalRightConstraint = base.view.rightAnchor.constraint(equalTo: introview.rightAnchor).activate()
        modalBottomConstraint = base.view.bottomAnchor.constraint(equalTo: introview.bottomAnchor).activate()
        self.backgroundLayer?.alpha = 1

        view.layoutIfNeeded()

        let scaleTransform = CGAffineTransform(scaleX: 0.3, y: 0.3)

        base.view.transform = scaleTransform
        base.view.center = CGPoint( x: rect.midX, y: rect.midY)
        base.view.alpha = 1

        UIView.animate(withDuration: 0.4, delay: 0.0,
                       usingSpringWithDamping: 0.9, initialSpringVelocity: 0.6,
                       animations: {
                        base.view.transform = CGAffineTransform.identity
                        base.view.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
                        base.view .frame = UIScreen.main.bounds
                        self.introView?.alpha = 0
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
        modalTopConstraint?.isActive = false
        modalLeftConstraint?.isActive = false
        modalRightConstraint?.isActive = false
        modalBottomConstraint?.isActive = false
        modalTopConstraint = formNavigationController?.view.topAnchor.constraint(equalTo: view.topAnchor)
        modalLeftConstraint = formNavigationController?.view.leftAnchor.constraint(equalTo: view.leftAnchor)
        modalRightConstraint = formNavigationController?.view.rightAnchor.constraint(equalTo: view.rightAnchor)
        modalBottomConstraint = formNavigationController?.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        modalTopConstraint?.isActive = true
        modalLeftConstraint?.isActive = true
        modalRightConstraint?.isActive = true
        modalBottomConstraint?.isActive = true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if viewModel.currentPageType == PageType.banner {
            coordinator.animate(alongsideTransition: { [weak self] (_ : UIViewControllerTransitionCoordinatorContext) in
                let orientation = UIApplication.shared.statusBarOrientation
                self?.viewModel.introPresenter?.updateConstraints(to: size, orientation: orientation)
            })
        } else if viewModel.currentPageType == PageType.toast {
            toast?.setNeedsUpdateConstraints()
        } else {
            updateModalConstraints()
        }
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
        let completion: ((Bool) -> Void) = { _ in
            self.backgroundLayer?.removeFromSuperview()
            introView.removeFromSuperview()
            self.closeCampaign(atPageIndex: 0)

        }
        removeBannerView(introView: introView, completion: completion)
    }

    private func removeBannerView(introView: UBIntroOutroView, completion: ((Bool) -> Void)?) {
        var fra = introView.frame
        if fra.origin.y > CGFloat(distanceFromTop) { // indicates bottom....
            fra.origin.y = view.frame.size.height + offset
        } else {
            fra.origin.y = -(fra.size.height + offset)
        }
        UIView.animate(withDuration: 0.3, animations: {
            introView.frame = fra
        }, completion: completion)
    }

    func introViewDidContinue(introView: UBIntroOutroView) {
        viewModel.introViewDidContinue()
        if viewModel.currentPageType == .toast {
            let completion: ((Bool) -> Void) = { _ in
                introView.removeFromSuperview()
                self.showToast()
            }
            removeBannerView(introView: introView, completion: completion)
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
