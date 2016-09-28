//
//  MoodContentController.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 10/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

@IBDesignable class MoodContentController: UIView {
    
    weak var delegate: IntFieldHandlerProtocol? = nil {
        didSet{
            applyCustomisations()
        }
    }
    var view: UIView!
    var buttons: [UIButton]!
    
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
    
    
    init(asd: IntFieldHandlerProtocol){
        super.init(frame: CGRectZero)
        delegate = asd
        setUp()
    }
    
    
    func setUp() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        //view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        
        
        
     
    }
    
    func applyCustomisations(){
        var smilies: [UIImage] = []

        if delegate?.themeConfig.disabledEmoticons != nil {
            smilies = (delegate?.themeConfig.disabledEmoticons!)!
        } else {
            smilies = (delegate?.themeConfig.enabledEmoticons)!
        }
        
        view.backgroundColor = delegate?.themeConfig.backgroundColor
        firstButton.setImage(smilies[0], forState: .Normal)
        secondButton.setImage(smilies[1], forState: .Normal)
        thirdButton.setImage(smilies[2], forState: .Normal)
        fourthButton.setImage(smilies[3], forState: .Normal)
        fifthBUtton.setImage(smilies[4], forState: .Normal)
        
        buttons = [firstButton, secondButton, thirdButton, fourthButton, fifthBUtton]

    }

    func setNumberOfItems(number: Int) {
        switch number {
        case 3:
            secondButton.hidden = true
            fourthButton.hidden = true
        case 2:
            secondButton.hidden = true
            fourthButton.hidden = true
            thirdButton.hidden = true
        default:
            break
        }
    
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm")
        let nib = UINib(nibName: "MoodContentController", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    
        return view
    }
    
    func resetSelected() {
        if let disabled = delegate?.themeConfig.disabledEmoticons {
            firstButton.setImage(disabled[0], forState: .Normal)
            secondButton.setImage(disabled[1], forState: .Normal)
            thirdButton.setImage(disabled[2], forState: .Normal)
            fourthButton.setImage(disabled[3], forState: .Normal)
            fifthBUtton.setImage(disabled[4], forState: .Normal)
        } else {
            firstButton.alpha = 0.5
            secondButton.alpha = 0.5
            thirdButton.alpha = 0.5
            fourthButton.alpha = 0.5
            fifthBUtton.alpha = 0.5
        }
    }
    
    func setSelected(selected: Int) {
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
    
    func enableButton(button: UIButton, position: Int) {
        button.setImage(delegate?.themeConfig.enabledEmoticons[position-1], forState: .Normal)
        button.alpha = 1
    }
    
    
    @IBAction func buttonPressed(sender: UIButton, forEvent event: UIEvent) {
        delegate?.fieldValue = sender.tag
        
        if let disabled = delegate?.themeConfig.disabledEmoticons {
            firstButton.setImage(disabled[0], forState: .Normal)
            secondButton.setImage(disabled[1], forState: .Normal)
            thirdButton.setImage(disabled[2], forState: .Normal)
            fourthButton.setImage(disabled[3], forState: .Normal)
            fifthBUtton.setImage(disabled[4], forState: .Normal)
            sender.setImage(delegate?.themeConfig.enabledEmoticons[sender.tag-1], forState: .Normal)
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
