//
//  MoodContentController.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 10/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

@IBDesignable class MoodContentController: UIView {

    weak var delegate: IntFieldHandlerProtocol? = nil
    var view: UIView!
    var buttons: [UIButton]!
    var themeConfig: UsabillaThemeConfigurator? {
        didSet {
            applyCustomisations()
        }
    }

    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var fifthBUtton: UIButton!

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
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //view.translatesAutoresizingMaskIntoConstraints = false
        buttons = [firstButton, secondButton, thirdButton, fourthButton, fifthBUtton]

        addSubview(view)
    }

    func applyCustomisations() {
        var smilies: [UIImage] = []

        if themeConfig?.disabledEmoticons != nil {
            smilies = (themeConfig?.disabledEmoticons!)!
        } else {
            smilies = (themeConfig?.enabledEmoticons)!
        }

        view.backgroundColor = themeConfig?.backgroundColor
        firstButton.setImage(smilies[0], for: UIControlState())
        secondButton.setImage(smilies[1], for: UIControlState())
        thirdButton.setImage(smilies[2], for: UIControlState())
        fourthButton.setImage(smilies[3], for: UIControlState())
        fifthBUtton.setImage(smilies[4], for: UIControlState())


    }

    func setNumberOfItems(_ number: Int) {
        switch number {
        case 3:
            secondButton.isHidden = true
            fourthButton.isHidden = true
        case 2:
            secondButton.isHidden = true
            fourthButton.isHidden = true
            thirdButton.isHidden = true
        default:
            break
        }

    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")
        let nib = UINib(nibName: "MoodContentController", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        return view
    }

    func resetSelected() {
        if let disabled = themeConfig?.disabledEmoticons {
            firstButton.setImage(disabled[0], for: UIControlState())
            secondButton.setImage(disabled[1], for: UIControlState())
            thirdButton.setImage(disabled[2], for: UIControlState())
            fourthButton.setImage(disabled[3], for: UIControlState())
            fifthBUtton.setImage(disabled[4], for: UIControlState())
        } else {
            firstButton.alpha = 0.5
            secondButton.alpha = 0.5
            thirdButton.alpha = 0.5
            fourthButton.alpha = 0.5
            fifthBUtton.alpha = 0.5
        }
    }

    func setSelected(_ selected: Int) {
        resetSelected()
        switch selected {
        case 1:
            enableButton(firstButton, position: 1)
        case 2:
            enableButton(secondButton, position: 2)
        case 3:
            enableButton(thirdButton, position: 3)
        case 4:
            enableButton(fourthButton, position: 4)
        case 5:
            enableButton(fifthBUtton, position: 5)
        default:
            break
        }
    }

    func enableButton(_ button: UIButton, position: Int) {
        button.setImage(themeConfig?.enabledEmoticons[position-1], for: UIControlState())
        button.alpha = 1
    }


    @IBAction func buttonPressed(_ sender: UIButton, forEvent event: UIEvent) {
        delegate?.fieldValue = sender.tag

        if let disabled = themeConfig?.disabledEmoticons {
            firstButton.setImage(disabled[0], for: UIControlState())
            secondButton.setImage(disabled[1], for: UIControlState())
            thirdButton.setImage(disabled[2], for: UIControlState())
            fourthButton.setImage(disabled[3], for: UIControlState())
            fifthBUtton.setImage(disabled[4], for: UIControlState())
            sender.setImage(themeConfig?.enabledEmoticons[sender.tag-1], for: UIControlState())
        } else {
            firstButton.alpha = 0.5
            secondButton.alpha = 0.5
            thirdButton.alpha = 0.5
            fourthButton.alpha = 0.5
            fifthBUtton.alpha = 0.5
            sender.alpha = 1
        }
    }
}
