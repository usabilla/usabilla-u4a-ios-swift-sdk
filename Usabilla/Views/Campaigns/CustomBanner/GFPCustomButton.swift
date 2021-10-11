//
//  GFPCustomButton.swift
//  Usabilla
//
//  Created by Anders Liebl on 12/11/2021.
//  Copyright © 2021 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class GFPCustomButton: UIView {
   
    var cornerRadius:CGFloat = 20
    private var button: UIButton?
    private var imageView = UIImageView()
    private var image: UIImage = UIImage()
    init(image: UIImage?, button: UIButton) {
        super.init(frame: CGRect.zero)
        if let aImage = image {
            self.image = aImage
        }
       // backgroundColor = .brown
        self.button = button
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - configuration
    private func configureView() {
        addImageView()
        addButton()
    }
    
    private func addImageView() {
        let aImage = self.image
        imageView.image = aImage
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true

    }

    private func addButton() {
        if let aButton = button {
            addSubview(aButton)
            aButton.translatesAutoresizingMaskIntoConstraints = false
            aButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            aButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            aButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
            aButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        }
    }
    override func layoutSubviews() {
        //print("her")
        imageView.layoutSubviews()
        button?.layoutSubviews()
    }

}
