//
//  ReferDriverClass.swift
//  PrestoRideDriver
//
//  Created by User on 28/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import UIKit
class ReferDriverClass: UITableViewController {
    
    
    @IBOutlet var txty_fname: NextResponderTextField!
    
    @IBOutlet var txty_lname: NextResponderTextField!
    
    @IBOutlet var txty_email: NextResponderTextField!
    
    @IBOutlet var txty_phone: NextResponderTextField!
    
    @IBOutlet var txtr_fname: NextResponderTextField!
    
    @IBOutlet var txtr_lname: NextResponderTextField!
    
    @IBOutlet var txtr_email: NextResponderTextField!
    
    @IBOutlet var txtr_phone: NextResponderTextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = "Refer Driver"
    }
    
    @IBAction func buttonRefer(_ sender: AnyObject)
    {
//        self.Spinner(Task: 1, tag: 98702)
        
        var showAlert = false
        
        if txty_fname.text == "" { showAlert = true }
        if txty_lname.text == "" { showAlert = true }
        if txty_email.text == "" { showAlert = true }
        if txty_phone.text == "" { showAlert = true }
        if txtr_fname.text == "" { showAlert = true }
        if txtr_lname.text == "" { showAlert = true }
        if txtr_email.text == "" { showAlert = true }
        if txtr_phone.text == "" { showAlert = true }
        
        if showAlert
        {
            self.presentAlertWithTitle(title: "Error", message: "You left any field")
//            self.Spinner(Task: 2, tag: 98702)
            
            return
        }
        
        if isValidEmail(testStr: txty_email.text!) == false || isValidEmail(testStr: txtr_email.text!) == false
        {
            self.presentAlertWithTitle(title: "Error", message: "Enter a valid Email Id")
//            self.Spinner(Task: 2, tag: 98702)
        }
        else
        {
            self.SendData()
        }
    }
    
    
    func SendData()
    {
        
        let parameters =
            [
                "y_fname"    : self.txty_fname.text!,
                "y_lname"    : self.txty_lname.text!,
                "y_email"    : self.txty_email.text!,
                "y_phone"    : self.txty_phone.text!,
                "r_fname"    : self.txtr_fname.text!,
                "r_lname"    : self.txtr_lname.text!,
                "r_email"    : self.txtr_email.text!,
                "r_phone"    : self.txtr_phone.text!,
                ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/driver/add_driverreferral".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = JSON(data : response.data!)
                    
                    if json["result"].int == 1
                    {
                        self.presentAlertWithTitle(title: "Success", message: "Submitted")
                        self.emptytextFromtextField()
//                        self.Spinner(Task: 2, tag: 98702)
                    }
                    else
                    {
                        self.presentAlertWithTitle(title: "Error", message: "Try Again")
//                        self.Spinner(Task: 2, tag: 98702)
                    }
                }
            case .failure(_):
                print("Error in Referral Driver")
//                self.Spinner(Task: 2, tag: 98702)
            }
        }
    }
    @IBAction func buttonReset(_ sender: AnyObject)
    {
        self.emptytextFromtextField()
    }
    func emptytextFromtextField()
    {
        self.txty_fname.text = ""
        self.txty_lname.text = ""
        self.txty_email.text = ""
        self.txty_phone.text = ""
        self.txtr_fname.text = ""
        self.txtr_lname.text = ""
        self.txtr_email.text = ""
        self.txtr_phone.text = ""
    }
    
}



// For keyboard adjustment and limitation :-


extension ReferDriverClass : UITextFieldDelegate
{
    
    // limitation
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let notAllowedNumbers = "1234567890€£¥|•~`!@#$%^&*()_+{}:<>?/.,;'[]=-'"
        
        let char = string.cString(using: String.Encoding.utf8)!
        
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
        }
        else
        {
            switch textField.tag
            {
            case 327 , 329 , 323 , 328 :  // Mobile Number
                
                let notAllowedCharacters1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz€£¥|•~`!@#$%^&*()_{}:<>?/.,;'[]=-'"
                let set = NSCharacterSet(charactersIn:notAllowedCharacters1)
                let inverted = set.inverted
                let filtered = string.components(separatedBy:inverted).joined(separator:"")
                return filtered != string
                case 320 , 321 ,324 , 325   :         // Only Allow Character
                
                let set = NSCharacterSet(charactersIn:notAllowedNumbers)
                
                let inverted = set.inverted
                let filtered = string.components(separatedBy: inverted).joined(separator: "")
                    return filtered != string
                
            default :
                print("")
            }
            
        }
        return true
    }
    
}
