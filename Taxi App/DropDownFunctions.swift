//
//  DropDownFunctions.swift
//  PrestoRideDriver
//
//  Created by User on 06/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import Foundation
import UIKit



extension UIViewController
{
    
    struct selectedCountry
    {
     static var stringCountry = String()
    }
    
    func CountryDropDownFunction(dropdownName : DropDown , outlet : NiceButton , array : [String] )
    {
        dropdownName.anchorView = outlet
        
        dropdownName.bottomOffset = CGPoint(x: 0, y: outlet.bounds.height)
        
        dropdownName.dataSource = array
        
        dropdownName.selectionAction = { [] (index: Int, item: String) in
            
        outlet.setTitle(item, for: .normal)
          
        selectedCountry.stringCountry = item
            
        }
    }
    func getSelectedCountry() -> String
    {
        if selectedCountry.stringCountry == ""
        {
            return ""
        }
        else
        {
            return selectedCountry.stringCountry
        }
    }
}
