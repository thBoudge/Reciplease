//
//  StyleUIButton.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-05-23.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit

class StyleUIButton: UIButton {

    var isOn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    
    
    func initButton() {
        layer.borderWidth = 2.0
        layer.borderColor = #colorLiteral(red: 0.2662596107, green: 0.1814376712, blue: 0.355894357, alpha: 1)
        layer.cornerRadius = frame.size.height/2
    }
}
