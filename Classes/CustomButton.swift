//
//  CustomButton.swift
//  CabRide-Driver
//
//  Created by Mayur iMac on 20/02/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: - View
    override func awakeFromNib() {
        self.backgroundColor = UIColor(hex: "F21541")
    }

}
