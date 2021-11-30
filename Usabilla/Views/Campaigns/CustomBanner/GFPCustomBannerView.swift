//
//  CustomBannerView.swift
//  Usabilla
//
//  Created by Anders Liebl on 07/10/2021.
//  Copyright © 2021 Usabilla. All rights reserved.
//

import Foundation
import UIKit

struct BannerConfiguration {
    var bannerType: BannerType = .gfpDefault
    var buttonStyle: ButtonType = .gfpButtonHorizontal
    
    var topMargin: Float = 20
    var leftMargin: Float = 20
    var rightMargin: Float = -20
    var bottomMargin: Float = -20
    var maxWidth: Float = 600
    var maxHeight: Float = 400
    var backgroundImage: UIImage?
    var clickThrough = false
    
    var logoTopMargin: Float = 0
    var logoLeftMargin: Float = 0
    var logoRightMargin: Float = 0
    var logoBottomMargin: Float = 0
    var logoHeight: Float = 150
    var logoWidth: Float = 115
    var logoImage: UIImage? 
    
    var titleLeftMargin: Float = 16
    var titleRightMargin: Float = -16

    var titleHeight: Float = 0
    var titleWidth: Float = 0
    var titleAlignment: NSTextAlignment = .left


    var componentLeftMargin: Float = 16
    var componentRightMargin: Float = -16
    var componentHeight: Float = 0
    var componentWidth: Float = 0
    var componentTextAlignment: NSTextAlignment = .left
    
    var buttonsTopMargin: Float = 16
    var buttonLeftMargin: Float = 40
    var buttonRightMargin: Float = -40
    var buttonBottomMargin: Float = 16
    var buttonHeight: Float = 0
    var buttonWidth: Float = 0
    var cancelButtonImage: UIImage?
    var cancelButtonTitleColor: UIColor?
    var continueButtonImage: UIImage?
    var continueButtonTitleColor: UIColor?
}


public enum BannerType {
    case gfpDefault
    case gfpBackgroundImage
    case gfpBackgroundImageAndLogo
}

public enum ButtonType {
    case gfpDefault
    case gfpButtonHorizontal
    case gfpButtonVertical
}



class GFPCustomBannerView: UBCustomTouchableView, UBIntroOutroViewProtocol {
    var viewModel: IntroPageViewModel
    var nativeBanner = false
    private var bannerView: UIView = UIView()
    private var cardView: GFPCardView = GFPCardView()
    private lazy var insideStackView: UIStackView = UIStackView()
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 00.0
        stack.distribution = .fillProportionally
        return stack
    }()

    private var continueButton: UIButton?
    private var cancelButton: UIButton!

    
    private var compenentView = UIView()
    
    private var imageView: UIImageView?
    private var titleLabel: UILabel!
    private var componentView: UIControl?
    
    private var titleTopConstraint: NSLayoutConstraint!
    
    weak var delegate: UBIntroOutroViewDelegate?
    private var bannerConfig: BannerConfiguration
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init(viewModel: IntroPageViewModel,
                  configuration : BannerConfiguration = BannerConfiguration()) {
        self.viewModel = viewModel
        self.bannerConfig = configuration
        super.init(frame: CGRect.zero)


        SwiftEventBus.onMainThread(self, name: "pageUpdatedValues") { _ in
           // self.updateContinueButton()
        }
        configureViews()
    }

    deinit {
        SwiftEventBus.unregister(self)
    }
    //MARK: - setup views
    fileprivate func configureViews() {
        addBannerView()
        setupCardView()
        setupImageView()
        configureComponentsView()
        setupButtons()
    }

    func addBannerView() {
        bannerView.backgroundColor = .clear
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        addBackgroundImage()

        addSubview(bannerView)
        bannerView.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        bannerView.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        bannerView.topAnchor.constraint(equalTo: topAnchor).activate()
        bannerView.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
        
    }

    fileprivate func addBackgroundImage() {
        switch bannerConfig.bannerType {
        case .gfpBackgroundImage, .gfpBackgroundImageAndLogo:
            if let aImage = bannerConfig.backgroundImage {
                let aImageView = UIImageView(image: aImage)
                aImageView.translatesAutoresizingMaskIntoConstraints = false
                aImageView.alpha = 0.8
                addSubview(aImageView)
                aImageView.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
                aImageView.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
                aImageView.topAnchor.constraint(equalTo: topAnchor).activate()
                aImageView.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
            }
        default:
            return
        }
    }

    // MARK: - Card
    func setupCardView() {
        cardView.backgroundColor = .white
        cardView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.addSubview(cardView)
        cardView.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor, constant: CGFloat(bannerConfig.leftMargin)).activate()
        cardView.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor, constant: CGFloat(bannerConfig.rightMargin)).activate()
        cardView.centerXAnchor.constraint(equalTo: bannerView.centerXAnchor).activate()
        cardView.centerYAnchor.constraint(equalTo: bannerView.centerYAnchor).activate()
    }

    // MARK: - Image View
    func setupImageView() {
        guard bannerConfig.bannerType == .gfpBackgroundImageAndLogo else {return}
        if let image = bannerConfig.logoImage {
            let imageview = UIImageView(image: image)
            imageview.frame = CGRect(x: 0, y: 0, width: CGFloat(bannerConfig.logoWidth), height: CGFloat(bannerConfig.logoHeight))
            imageview.contentMode = .scaleToFill
            imageview.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubviewToStack(imageview)
            imageView = imageview
            imageview.widthAnchor.constraint(equalToConstant: CGFloat(bannerConfig.logoWidth)).activate()
            imageview.heightAnchor.constraint(equalToConstant: CGFloat(bannerConfig.logoHeight)).activate()
        }
    }
    
    //MARK: - utilities
    override func layoutSubviews() {
        cardView.layoutSubviews()
        componentView?.layoutSubviews()
        cancelButton.layoutSubviews()
//        configureScrollHeight()
    }

    private func updateContinueButton() {
        continueButton?.isEnabled = viewModel.canContinue
    }

    @objc func dismissAction() {
        delegate?.introViewDidCancel(introView: self)
    }

    @objc func continueAction() {
        delegate?.introViewDidContinue(introView: self)
    }

    @objc func componentValueChanged() {
        delegate?.introViewDidContinue(introView: self)
    }

    //override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let view = super.hitTest(point, with: event)
            return view == self ? nil : view
        }

 }

//MARK: - buttons
extension GFPCustomBannerView {
    
    private func setupButtons() {
        configureButtonViews()
        cancelButton = UIButton(type: .system)
        cancelButton.setTitle(viewModel.cancelLabelText, for: .normal)
        if let color = bannerConfig.cancelButtonTitleColor  {
            cancelButton.setTitleColor(color, for: UIControl.State.normal)
        }
        let aButtonView = GFPCustomButton(image: nil, button: cancelButton)

        if viewModel.hasContinueButton || UIAccessibilityIsVoiceOverRunning() {
            let aContinueButton = UIButton(type: .system)
            if let color = bannerConfig.continueButtonTitleColor  {
                aContinueButton.setTitleColor(color, for: UIControl.State.normal)
            }
            let aButtonView = GFPCustomButton(image: bannerConfig.continueButtonImage, button: aContinueButton)
            buttonStackView.addArrangedSubview(aButtonView)

            //buttonStackView.addArrangedSubview(aContinueButton)
            // In case voice over is activated we want to add a continue button even if it does not exist
            var continueText = viewModel.continueLabelText
            if UIAccessibilityIsVoiceOverRunning() && (continueText?.isEmpty ?? true) {
                continueText = LocalisationHandler.getLocalisedStringForKey("usa_accessibility_button_label_continue")
            }
            aContinueButton.setTitle(continueText, for: .normal)
            aContinueButton.addTarget(self, action: #selector(UBIntroOutroView.continueAction), for: .touchUpInside)
            continueButton = aContinueButton
        }
        cancelButton.addTarget(self, action: #selector(UBIntroOutroView.dismissAction), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(aButtonView)

        updateContinueButton()

    }
    fileprivate func configureButtonViews() {
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubviewToStack(buttonStackView)
        buttonStackView.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: CGFloat(bannerConfig.buttonLeftMargin)).isActive = true
        buttonStackView.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: CGFloat(bannerConfig.buttonRightMargin)).isActive = true

        switch bannerConfig.buttonStyle {
        case .gfpButtonHorizontal:
            buttonStackView.axis = .horizontal
            buttonStackView.distribution = .fillEqually

        case .gfpButtonVertical:
            buttonStackView.axis = .vertical
            buttonStackView.distribution = .fillProportionally
        default:
            buttonStackView.axis = .vertical
            buttonStackView.distribution = .fillProportionally
        }
        
    }
    

}

// MARK: - Component view
extension GFPCustomBannerView {

    private func configureComponentsView() {
         insideStackView.axis = .vertical
         insideStackView.isLayoutMarginsRelativeArrangement = true
         insideStackView.spacing = 10.0
         insideStackView.alignment = .leading
         insideStackView.distribution = .fill//fillProportionally
        
        addTitle()
        addComponent()
        
        insideStackView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubviewToStack(insideStackView)
        insideStackView.leftAnchor.constraint(equalTo: cardView.cardStackView.leftAnchor, constant: 0).isActive = true
        insideStackView.rightAnchor.constraint(equalTo: cardView.cardStackView.rightAnchor, constant: 0).isActive = true

    }

    private func addTitle() {
        titleLabel = UILabel()
        titleLabel.text = viewModel.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = UBDimensions.IntroOutroView.textTitleLines
        insideStackView.addArrangedSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: insideStackView.leftAnchor, constant: CGFloat(bannerConfig.titleLeftMargin)).activate()
        titleLabel.rightAnchor.constraint(equalTo: insideStackView.rightAnchor, constant: CGFloat(bannerConfig.titleRightMargin)).activate()
        titleLabel.textAlignment = bannerConfig.titleAlignment
    }

    private func addComponent() {
        guard let componentViewModel = viewModel.componentViewModel else { return }
        let aComponentView = ComponentFactory.component(viewModel: componentViewModel)
        
        if let aField = aComponentView as? ParagraphComponent {
            aField.textView.textAlignment = NSTextAlignment.center
        }
        if let aField = aComponentView as? TextAreaComponent {
            aField.textView.textAlignment = NSTextAlignment.center
        }
        
        
        if !viewModel.hasContinueButton && !UIAccessibilityIsVoiceOverRunning() {
            aComponentView.addTarget(self, action: #selector(UBIntroOutroView.componentValueChanged), for: [.valueChanged])
        }
        insideStackView.addArrangedSubview(aComponentView)
            
        aComponentView.translatesAutoresizingMaskIntoConstraints = false
        aComponentView.leftAnchor.constraint(equalTo: insideStackView.leftAnchor, constant: CGFloat(bannerConfig.componentLeftMargin)).isActive = true
        aComponentView.rightAnchor.constraint(equalTo: insideStackView.rightAnchor, constant: CGFloat(bannerConfig.componentRightMargin)).isActive = true
        compenentView = aComponentView
    }
}
