//
//  MyMethodOfDropDown.swift
//  Stealth Care
//
//  Created by Saurabh Sawla on 27/02/17.
//  Copyright © 2017 Mayank Jain. All rights reserved.
//

import Foundation
import UIKit

func DropdownShow(dName : DropDown ,toItem : Any? , B_TF_TV : String , data : [String] , selectAtIndex : @escaping(String) ->())
{
    
    if B_TF_TV == "B"
    {
     if let anchor = toItem as? UIButton
     {
        dName.anchorView = anchor
        dName.bottomOffset = CGPoint(x: 0, y: anchor.bounds.height)
     }
    }
    else
    if B_TF_TV == "TF"
    {
        if let anchor = toItem as? UITextField
        {
             dName.anchorView = anchor
             dName.bottomOffset = CGPoint(x: 0, y: anchor.bounds.height)
        }
    }
    else
    {
        if let anchor = toItem as? UITextView
        {
            dName.anchorView = anchor
            dName.bottomOffset = CGPoint(x: 0, y: anchor.bounds.height)
        }
    }
    
    dName.backgroundColor = UIColor.white
    dName.separatorColor =  .lightGray
    dName.dataSource = data
    dName.show()
    dName.selectionAction =
        {
            [] (dropDownIndex: Int, item: String) in
            
            selectAtIndex(item)
        }
    
}
