//
//  NPSToolTipSelected.swift
//  Usabilla
//
//  Created by Anders Liebl on 02/11/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class NPSToolTipSelected: UIView {

    required convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 36, height: 46))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        internalInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalInit()
    }
    
    func internalInit() {
        addSubviews(icon, label)
        icon.frame = self.bounds
    }
}

}

