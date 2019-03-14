//
//  NiceButton.swift
//  DropDown
//
//  Created by Kevin Hirsch on 06/06/16.
//  Copyright © 2016 Kevin Hirsch. All rights reserved.
//

import UIKit

class NiceButton: UIButton {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
		self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 0.2
	}

}
