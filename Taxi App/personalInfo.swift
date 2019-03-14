//
//  personalInfo.swift
//  PrestoRideDriver
//
//  Created by User on 19/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import Foundation
import UIKit


extension Profile
{
    func profileDidLoad()
    {
        disableAllText()
        deligatesDIdload()
        
      //  self.Spinner(Task: 1, tag: 98585)
        
    }
    
    func disableAllText()
    {
        self.textFieldPersonalInfo[0].isEnabled = false
        self.textFieldPersonalInfo[1].isEnabled = false
        self.textFieldPersonalInfo[2].isEnabled = false
        self.textFieldPersonalInfo[3].isEnabled = false
        gettingData()
    }
    
    func gettingData()
    {
        
        let parameters =
            [
                "id" : Global.driverCurrentId
            ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/driver/driverProfile".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = JSON(data : response.data!)

                    if json["result"].int == 1
                    {
                     //   self.Spinner(Task: 2, tag: 98585)
                        
                        self.textFieldPersonalInfo[0].text = String(describing : json["data"]["first_name"])
                        self.textFieldPersonalInfo[1].text = String(describing : json["data"]["last_name"])
                        self.textFieldPersonalInfo[2].text = String(describing : json["data"]["id"])
                        self.textFieldPersonalInfo[3].text = String(describing : json["data"]["email"])
                        self.textFieldPersonalInfo[4].text = String(describing : json["data"]["mob_no"])
                    
                        self.imageviewUserProfile.kf.indicatorType = .activity
                        self.imageviewUserProfile.kf.setImage(with: URL(string : String(describing : json["data"]["head_shot"])), completionHandler: {
                                        (image, error, cacheType, imageUrl) in
                                         
                                        if image == nil
                                            {
                                              self.imageviewUserProfile.image = #imageLiteral(resourceName: "user")                                              
                                            }
                                    })
                        
                    }
                    else
                    {
                       // self.Spinner(Task: 2, tag: 98585)
                    }
                }
                
            case .failure(_):
                print("Error in Getting personal info")
               // self.Spinner(Task: 2, tag: 98585)
                
            }
        }
    }
    
    
    func buttonUpdateFunc()
    {
        self.buttonUpdate.setTitle("Loading...", for: .normal)
        
        let parameters =
            [
                "id"        : Global.driverCurrentId,
                "first_name": self.textFieldPersonalInfo[0].text!,
                "last_name" : self.textFieldPersonalInfo[1].text!,
                "mobno"     : self.textFieldPersonalInfo[4].text!
            ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(UIImageJPEGRepresentation(self.imageviewUserProfile.image!, 0.1)!, withName: "driver_img", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
         
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
            }, to:"\(Global.DomainName)/driver/updateDriver")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON
                    {
                        response in
                        
                        let json = JSON(response.result.value)
                        
                        if json["result"].int == 1
                        {
                        self.presentAlertWithTitle(title: "Success", message: "UPDATED")
                            
                        self.buttonUpdate.setTitle("Update", for: .normal)

                        }
                        else
                        {
                        self.presentAlertWithTitle(title: "Error", message: "Issue in upadating. Try again later")
                            
                            self.buttonUpdate.setTitle("Update", for: .normal)
                        }
                }
                
            case .failure(_):
                print("error in final registration")
                
                self.buttonUpdate.setTitle("Update", for: .normal)
            }
        }
    }
    
}


// MARK: ImagePicking issue :-

extension Profile
{
    func loadFromLibrary()
    {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        self.imageviewUserProfile.image = chosenImage
        
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {dismiss(animated: true, completion: nil)
    }
}


// MARK: deligates :-

extension Profile : UITextFieldDelegate
{
    
   func deligatesDIdload()
   {
     NotificationCenter.default.addObserver(self, selector: #selector(Profile.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
     NotificationCenter.default.addObserver(self, selector: #selector(Profile.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
   }
    
   func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
   
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let notAllowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz€£¥|•~`!@#$%^&*()_+{}:<>?/.,;'[]=-'"
        
        let char = string.cString(using: String.Encoding.utf8)!
        
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
        }
        else
        {
            if textField.tag == 304
            {
                let set = NSCharacterSet(charactersIn:notAllowedCharacters)
                let inverted = set.inverted
                
                let filtered = string.components(separatedBy:inverted).joined(separator:"")
                
                return filtered != string
            }
        }
        return true
    }
}



