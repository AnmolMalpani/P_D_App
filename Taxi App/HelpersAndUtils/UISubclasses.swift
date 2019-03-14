//
//  UISubclasses.swift
//  PrestoRideDriver
//
//  Created by Hp on 24/08/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import UIKit

class customTextField : UITextField , UITextFieldDelegate
{
    @IBInspectable open var task : Int = 0
    @IBInspectable open var limit : Bool = false
    @IBInspectable var limitSize : Int = 0
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let notAllowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz€£¥|•~`!@#$%^&*()_+{}:<>?/.,;'[]=-'"
        
        let notAllowedNumbers = "1234567890€£¥|•~`!@#$%^&*()_+{}:<>?/.,;'[]=-'"
        
        
        let char = string.cString(using: String.Encoding.utf8)!
        
        let isBackSpace = strcmp(char, "\\b")
        
        if limit
        {
            if isBackSpace == -92
            {
                
            }
            else
                if (self.text?.characters.count)! >= limitSize
                {
                    return false
            }
        }
        
        if (isBackSpace == -92)
        {
            print("Backspace was pressed")
        }
        else
        {
            switch task
            {
            case 0 :
                
                return true
                
            case 1 :  // Mobile Number
                
                var isValid = false
                
                for i in 0...9
                {
                    if String(i) == string
                    {
                        isValid = true
                    }
                }
                
                return isValid
                
            case 2  :          // Only Allow Number
                
                let set = NSCharacterSet(charactersIn:notAllowedCharacters)
                let inverted = set.inverted
                
                let filtered = string.components(separatedBy:inverted).joined(separator:"")
                
                return filtered != string
                
                
            case 3   :         // Only Allow Character
                
                let set = NSCharacterSet(charactersIn:notAllowedNumbers)
                
                let inverted = set.inverted
                
                let filtered = string.components(separatedBy: inverted).joined(separator: "")
                
                return filtered != string
                
            case 4 :   // Postal Code
                
                let number = [1,2,3,4,5,6,7,8,9,0]
                
                let charcter = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
                
                for i in number
                {
                    if i == Int(string)
                    {
                        return true
                    }
                }
                
                for j in charcter
                {
                    let s = string.capitalized
                    
                    if s == j
                    {
                        return true
                    }
                }
                
                return   false
                
            default :
                print("")
            }
        }
        return true
    }
}
