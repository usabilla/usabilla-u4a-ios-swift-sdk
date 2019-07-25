//
//  UBSAContainerView.swift
//  Usabilla
//
//  Created by Anders Liebl on 24/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import UIKit

class UBSAContainerView: UIView {
    private let backgroundIndex = 0
    private var indexOfActionView = 1
    fileprivate lazy var backgroundView: UIImageView = {
        let imageView = UIImageView(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(imageView, at: backgroundIndex)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

   override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    func configureView() {
        clipsToBounds = true
        backgroundColor = .clear
        layer.cornerRadius = 4
        layer.masksToBounds = true
        
    }
    func reset(){
        if let aView = subviews[0] as? UIImageView {
            aView.image = nil
        }
        for index in 1..<indexOfActionView {
            subviews[1].removeFromSuperview()
        }
    }
}
extension UBSAContainerView {
    func backgroundImage() -> UIImage? {
        return backgroundView.image
    }
    func setBackgroundImage(_ image: UIImage) {
        backgroundView.image = image
    }
    
    func addActionView(_ view: UIView) {
        insertSubview(view, at: indexOfActionView)
    }
    
    func removeActionView() {
        if subviews.count < indexOfActionView {
            return
        }
        let view = subviews[indexOfActionView]
        view.removeFromSuperview()
    }
    
    override func addSubview(_ view: UIView) {
        addView(view)
    }
    
    func addView(_ view: UIView) {
        if subviews.count < indexOfActionView {
            addSubview(view)
            indexOfActionView += 1
            return
        }
        insertSubview(view, at: indexOfActionView)
        indexOfActionView += 1
    }
    
    func finalImage() -> UIImage {
        return  self.screenCapture
    }
}

