//
//  PageViewController.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 01/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

let footerHeight: CGFloat = 90.0

class PageViewController: UIViewController, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {

    var client: ClientModel!
    var viewModel: PageViewModel!
    var cellHeights: [IndexPath: CGFloat] = [IndexPath: CGFloat]()
    private var constraintHeaderLeft: NSLayoutConstraint?
    private var constraintHeaderRight: NSLayoutConstraint?
    private var pickController: UIViewController?
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        return tableView
    }()
    var alreadyAtTop: Bool = true

    var requiredLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.isAccessibilityElement = false
        if #available(iOS 10.0, *) {
            label.adjustsFontForContentSizeCategory = true
        }
        return label
    }()
    lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(self.requiredLabel)
        return headerView
    }()

    init(viewModel: PageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UsabillaInternal.supportedOrientations
    }
    override var shouldAutorotate: Bool {
        if UsabillaInternal.supportedOrientations == .all {
            return true
        }
        return false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftEventBus.onMainThread(self, name: "updateClientModel") { result in
            if result?.object == nil {
                let imageTypeDict = ["image_type": nil as Any?, "number_of_drawings": nil]
                self.client.addBehaviour("screenshot_annotations", imageTypeDict)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        customizeView()

        let gestureReCognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        gestureReCognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureReCognizer)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        registerEventsBus()
    }

    func setUpView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).activate()
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).activate()
        tableView.topAnchor.constraint(equalTo: view.topAnchor).activate()
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
        tableView.register(RootCellView.self, forCellReuseIdentifier: "root")
        tableView.register(FooterTableViewCell.self, forCellReuseIdentifier: "footer")
        tableView.canCancelContentTouches = false
        requiredLabel.text = viewModel.errorMessage

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .automatic
        }

        handleHeaderViewVisibility()
    }

    func customizeView() {
        view.backgroundColor = viewModel.theme.colors.background
        tableView.backgroundColor = viewModel.theme.colors.background

        requiredLabel.applyFontWithDynamicTypeEnabled(font: viewModel.theme.fonts.font)
        requiredLabel.textColor = viewModel.theme.colors.text
    }

    func handleHeaderViewVisibility() {
        if tableView.tableHeaderView == nil {
            tableView.tableHeaderView = headerView
            //headerView.heightAnchor.constraint(equalToConstant: 60).activate()
            constraintHeaderLeft = headerView.leftAnchor.constraint(equalTo: view.leftAnchor).activate()
            constraintHeaderRight = headerView.rightAnchor.constraint(equalTo: view.rightAnchor).activate()
            requiredLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: DeviceInfo.getLeftCardBorder()).activate()
            requiredLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -DeviceInfo.getRightCardBorder()).activate()
            requiredLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: DeviceInfo.getTopCardBorder()+5).activate()
            requiredLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -DeviceInfo.getBottomCardBorder()).activate()
            updateHeaderMargins()
            tableView.tableHeaderView?.layoutIfNeeded()
        }

        if !viewModel.shouldShowRequiredLabel {
            tableView.tableHeaderView = nil
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        // This moodel is null, must figure out why this happens!!!
        guard //viewModel.shouldAddMarginWhenKeyboardIsShown,
            var userInfo = notification.userInfo,
            var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }

        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset: UIEdgeInsets = self.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.tableView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInset
    }

    func registerEventsBus() {
        SwiftEventBus.onMainThread(self, name: "pageUpdatedValues") { _ in
            self.reloadCellInTableAfterEvent()
        }

        SwiftEventBus.onMainThread(self, name: "click") { _ in
            self.clickImageFromCamera()
        }

        SwiftEventBus.onMainThread(self, name: "iPadPickerButtonTapped") { sender in
            if DeviceInfo.isIPad() {
                guard let pickerComponent = sender?.object as? PickerComponent else {
                    return
                }
                self.showPickerViewForiPad(pickerComponent: pickerComponent)
                return
            }
        }

        SwiftEventBus.onMainThread(self, name: "updateMySize") { _ in
            let lastScrollOffset = self.tableView.contentOffset
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            self.tableView.setContentOffset(lastScrollOffset, animated: false)
        }
    }

    func showPickerViewForiPad(pickerComponent: PickerComponent) {
        // Create picker ipad component
        let picker = PickerIPadComponent(viewModel: pickerComponent.viewModel)
        picker.delegate = pickerComponent

        // Add picker component in a container view controller
        let pickerController = UIViewController()
        pickerController.view = picker
        pickerController.modalPresentationStyle = .popover
        pickerController.preferredContentSize = CGSize(width: 274, height: 200)

        // Create the PopOverPresenter
        let popController = pickerController.popoverPresentationController
        popController?.permittedArrowDirections = .up
        popController?.delegate = self
        popController?.sourceView = pickerComponent.borderView
        popController?.sourceRect = CGRect(x: 134, y: 44, width: 0, height: 0)

        // present the pop over
        self.present(pickerController, animated: true, completion: nil)
        self.pickController = pickerController
    }

    func tableViewContentHeight() -> CGFloat {
        let sectionFrame = tableView.rect(forSection: 0)
        let emptySpaceHeight = tableView.frame.size.height - (sectionFrame.origin.y + sectionFrame.size.height)
        return emptySpaceHeight
    }

    func reloadCellInTableAfterEvent() {
        let listOfIndexes = viewModel.dynamicFields.filter {
            viewModel.viewModelForCellAt(index: $0)?.isViewCurrentlyVisible != viewModel.viewModelForCellAt(index: $0)?.shouldAppear
        }
        let indexPaths: [IndexPath] = listOfIndexes.map {
            IndexPath(row: $0, section: 0)
        }
        if listOfIndexes.count > 0 {
            self.reloadCellsWithAnimation(indexPaths)
        }
    }

    func deinitPageController() {
        SwiftEventBus.unregister(self)
    }

    func setupViewModel(_ viewModel: PageViewModel) {
        self.viewModel = viewModel
        cellHeights = [:]
        alreadyAtTop = false
        tableView.reloadData()
        handleHeaderViewVisibility()
    }

    func scrollToTop() {
        tableView.scrollTo(indexPath: IndexPath(row: 0, section: 0), animated: true)
    }

    func reloadTableWithAnimation() {
        let range = 0..<tableView.numberOfSections
        let sections = IndexSet(integersIn: range)
        self.tableView.reloadSections(sections, with: .automatic)
    }

    func reloadCellsWithAnimation(_ indexPaths: [IndexPath]) {

        let tableViewOffset = tableView.contentOffset
        tableView.beginUpdates()

        self.tableView.reloadRows(at: Array(Set(indexPaths)), with: .automatic)
        tableView.endUpdates()
        UIView.setAnimationsEnabled(false)
        tableView.layer.removeAllAnimations()
        tableView.setContentOffset(tableViewOffset, animated: false)
        UIView.setAnimationsEnabled(true)
    }

    func gotToNextErrorField() {
        viewModel.verifyFields()
        if let index = viewModel.indexOfInvalidField() {
            let cellIndexPath = IndexPath(row: index, section: 0)
            tableView.scrollTo(indexPath: cellIndexPath, animated: true)
            reloadCellAt(indexPath: cellIndexPath)
        }
    }

    func reloadCellAt(indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    //Image handling stuff
    fileprivate func presentFullDrawSolution(with client: ClientModel) {
        let controller = UBEditImageMainViewController(theme: viewModel.theme, client: client)
        let navController = UBNavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .overCurrentContext
        navController.isNavigationBarHidden = true
        present(navController, animated: false, completion: nil )
    }

    //Image handling stuff
    fileprivate func presentLibraryOnlySolution(with client: ClientModel) {
        let controller = UBImagePickerController(theme: viewModel.theme, fallBackMode: true)
        controller.client = client
        present(controller, animated: false, completion: nil )
    }

    func clickImageFromCamera() {
        if client == nil { // if network is lost between form-presentastion and click on camera the clientModel is not properly init
            client = ClientModel()
        }
        if DeviceInfo.requiredOrientationAvailable() {
            presentFullDrawSolution(with: client)
            return
        }
        presentLibraryOnlySolution(with: client)
    }

    @objc
    static func openUsabilla() {
        // swiftlint:disable:next force_unwrapping
        UIApplication.shared.openURL(URL(string: "http://www.usabilla.com")!)
    }

    private func updateHeaderMargins() {
        constraintHeaderLeft?.constant = UIView.safeAreaEdgeInsets.left
        constraintHeaderRight?.constant = UIView.safeAreaEdgeInsets.right
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       super.viewWillTransition(to: size, with: coordinator)
        if let pickController = pickController {
            pickController.dismiss(animated: true, completion: nil)
        }
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        updateHeaderMargins()
        headerView.setNeedsUpdateConstraints()
    }
}

extension PageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? viewModel.numberOfCells : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "footer", for: indexPath)
            if let cell = cell as? FooterTableViewCell {
                cell.footerView = PoweredByUsabillaView(theme: viewModel.theme)
            }
            cell.backgroundColor = .clear
            return cell
        }

        let cellViewModel = viewModel.viewModelForCellAt(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "root", for: indexPath)
        if let cell = cell as? RootCellView {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.cellViewModel = cellViewModel
        }
        return cell
    }
}

extension PageViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                if !alreadyAtTop {
                    scrollToTop()
                    alreadyAtTop = true
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let cellViewModel = viewModel.viewModelForCellAt(index: indexPath.row)
            cellViewModel?.updateVisibility()
            return cellViewModel?.isViewCurrentlyVisible == false ? 0 : UITableViewAutomaticDimension
        }
        if indexPath.section == 1 {
            let emptySpace = tableViewContentHeight()
            return emptySpace < footerHeight ? footerHeight : emptySpace
        }
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section == 0, let cell = viewModel.viewModelForCellAt(index: indexPath.row), !cell.shouldAppear else { return cellHeights[indexPath] ?? UITableViewAutomaticDimension
        }
        return 0
    }
}
