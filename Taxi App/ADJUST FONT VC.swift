//
//  ADJUST FONT VC.swift
//  PrestoRideDriver
//
//  Created by User on 30/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import UIKit

class ADJUST_FONT_VC: UITabBarController
{
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Earnings"
        
        let colorNormal : UIColor = UIColor.black
        let colorSelected : UIColor = UIColor.blue
        let titleFontAll : UIFont = UIFont(name: "American Typewriter", size: 13.0)!
        
        let attributesNormal = [
            NSForegroundColorAttributeName : colorNormal,
            NSFontAttributeName : titleFontAll
        ]
        
        let attributesSelected = [
            NSForegroundColorAttributeName : colorSelected,
            NSFontAttributeName : titleFontAll
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
        
    }
}
