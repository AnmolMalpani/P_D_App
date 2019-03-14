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
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : colorNormal,
            convertFromNSAttributedStringKey(NSAttributedString.Key.font) : titleFontAll
        ]
        
        let attributesSelected = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : colorSelected,
            convertFromNSAttributedStringKey(NSAttributedString.Key.font) : titleFontAll
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary(attributesNormal), for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary(attributesSelected), for: .selected)
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
