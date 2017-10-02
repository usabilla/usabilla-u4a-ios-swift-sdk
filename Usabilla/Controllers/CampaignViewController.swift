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

    let sideMargin: CGFloat = 16
    let topMargin: CGFloat = 20
    let viewModel: CampaignViewModel

    fileprivate weak var delegate: CampaignViewControllerDelegate?

    var backgroundLayer: UIView?
    var introView: UBIntroOutroView?
    var formNavigationController: UINavigationController?

    var modalBottomConstraint: NSLayoutConstraint?

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
            let keyboardFrame: CGRect = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
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
        let base = UINavigationController(rootViewController: formController)
        formController.delegate = self
        formNavigationController = base

        if DeviceInfo.isIPad() {
            base.modalPresentationStyle = .formSheet
            // swiftlint:disable:next force_unwrapping
            viewModel.introPresenter?.dismiss(view: introView!, inView: view, animations: {
                self.introView?.alpha = 0
            }, completion: {
                self.introView?.removeFromSuperview()
                self.present(base, animated: true, completion: nil)
            })

            return
        }

        addChildViewController(base)
        view.addSubview(base.view)

        base.view.alpha = 0
        base.view.layer.cornerRadius = 14
        base.view.layer.masksToBounds = true

        base.view.translatesAutoresizingMaskIntoConstraints = false
        base.view.topAnchor.constraint(equalTo: view.topAnchor, constant: topMargin).activate()
        base.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: sideMargin).activate()
        base.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -sideMargin).activate()
        modalBottomConstraint = base.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -sideMargin).activate()

        createBackgroundLayer()

        base.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)

        view.layoutIfNeeded()
        // swiftlint:disable:next force_unwrapping
        viewModel.introPresenter?.dismiss(view: introView!, inView: view, animations: {
            base.view.alpha = 1
            self.backgroundLayer?.alpha = 1
            self.introView?.alpha = 0
            base.view.transform = CGAffineTransform.identity
            base.view.layoutSubviews()
        }, completion: {
            self.introView?.removeFromSuperview()
        })
    }

    func removeFormController(completion: (() -> Void)?) {
        if DeviceInfo.isIPad() {
            formNavigationController?.dismiss(animated: true, completion: {
                completion?()
            })

            return
        }

        UIView.animate(withDuration: 0.2, animations: {
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
        let thankYoutext = viewModel.toastPageViewModel?.text
        let toast = UBToast(delegate: self, text: thankYoutext, duration: 2)
        toast.show {
            self.closeCampaign()
        }
    }

    func closeCampaign(atPageIndex index: Int? = nil) {
        let result = FeedbackResult(rating: viewModel.ratingValueForReview, abandonedPageIndex: index)
        UsabillaInternal.delegate?.campaignDidClose(self, with: result, isRedirectToAppStoreEnabled: viewModel.formViewModel.model.redirectToAppStore)
        self.delegate?.campaignDidEnd()
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
