//
//  MoodContentController.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 10/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

@IBDesignable class NPSContentController: UIView {

    weak var delegate: IntFieldHandlerProtocol?
    var view: UIView!
    var buttons: [UIButton] = []
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var fifthBUtton: UIButton!
    @IBOutlet weak var sixthButton: UIButton!
    @IBOutlet weak var seventhButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var ninthhButton: UIButton!
    @IBOutlet weak var tenthBUtton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    var themeConfig: UsabillaThemeConfigurator? {
        didSet {
            applyCustomisation()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    func setUp() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleHeight, . FlexibleWidth]
        buttons = [zeroButton, firstButton, secondButton, thirdButton, fourthButton, fifthBUtton, sixthButton, seventhButton, eightButton, ninthhButton, tenthBUtton]


        addSubview(view)
    }

    func applyCustomisation() {
        view.backgroundColor = themeConfig?.backgroundColor

        for button in buttons {
            button.setTitleColor(themeConfig?.textOnAccentColor, forState: .Selected)
            button.setTitleColor(themeConfig?.textColor, forState: .Normal)
            button.backgroundColor = themeConfig?.backgroundColor
            button.layer.borderWidth = 1.0
            button.layer.cornerRadius = 6.0
            button.layer.borderColor = themeConfig?.hintColor.CGColor
        }
    }

    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm")
        let nib = UINib(nibName: "NPSContentController", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView


        return view
    }

    func resetButtons() {
        for button in buttons {
            button.backgroundColor = themeConfig?.backgroundColor
            button.selected = false
        }
    }

    func selectButton(value: Int) {
        resetButtons()
        for button in buttons {
            if button.tag == value {
                button.selected = true
                button.backgroundColor = themeConfig?.accentColor

            }
        }
    }


    @IBAction func buttonPressed(sender: UIButton, forEvent event: UIEvent) {
        for button in buttons {
            button.backgroundColor = themeConfig?.backgroundColor
            button.selected = false
        }
        sender.selected = true
        sender.backgroundColor = themeConfig?.accentColor

        delegate?.fieldValue = sender.tag
    }
}
