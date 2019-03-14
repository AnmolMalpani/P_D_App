
//  ViewController.swift
//  Taxi App
//  Created by User on 08/12/16.
//  Copyright © 2016 User. All rights reserved.
/// Arun Saini
import UIKit
let mainVC = UIApplication.shared.keyWindow?.rootViewController
public enum HTTPMethod: String
{
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}
class ViewController: UIViewController , UITextFieldDelegate {
    // MARK: All Outlets Main
    
    @IBOutlet weak var textfieldEmail: UITextField!
    
    @IBOutlet weak var pin1: UITextField!
    
    @IBOutlet weak var pin2: UITextField!
    
    @IBOutlet weak var pin3: UITextField!
    
    @IBOutlet weak var pin4: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var registration_button: UIButton!
    
    //MARK: Variables
    
    var loadAfterRideCompletion = false
    
    @IBAction func registration_button(_ sender: AnyObject)
    {
        if netcheckker() != 0
        {
            self.openViewControllerBasedOnIdentifier("Register1")
        }
    }

    @IBAction func LoginButton(_ sender: AnyObject)
    {
//         self.openViewControllerBasedOnIdentifier("Home")
        
        if netcheckker() != 0
        {
            if isValidEmail(testStr: textfieldEmail.text!) == false
            {
                self.presentAlertWithTitle(title: "Error", message: "Please enter a valid email")
            }
            else if pin1.text! != "" && pin1.text! != "" && pin1.text! != "" && pin1.text! != ""
            {
                LoginButton.setTitle("Loading...", for: .normal)
                LoginButtonWorking()
            }
            else
            {
                presentAlertWithTitle(title: "Error", message: "Please enter pin")
            }
        }
    }
    
    func LoginButtonWorking()
    {
        self.userInteraction(false)
        
        let parameters = [
            "email": textfieldEmail.text!,
            "password" : pin1.text! + pin2.text! + pin3.text! + pin4.text!
        ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:"\(Global.DomainName)/driver/login".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = JSON(data : response.data!)
                    
                    if json["result"].int == 1
                    {
                        if json["data"].array?.isEmpty == false
                        {
                            Global.driverCurrentId = String(describing: json["data"][0]["id"])
                            Global.driverCarName = String(describing: json["data"][0]["type"])
                            
                            offlineLogin.shared.setLoginId(Global.driverCurrentId, Global.driverCarName)
                            
                            self.openViewControllerBasedOnIdentifier("Home")
                            
                            for i in self.view.subviews
                            {
                                if let txt = i as? UITextField
                                {
                                    txt.text = ""
                                }
                            }
                        }
                    }
                    else
                    {
                        self.presentAlertWithTitle(title: "Error", message: "Invalid email or pin")
                    }
                    self.LoginButton.setTitle("Login", for: .normal)
                    
                    self.userInteraction(true)
                }
            case .failure(_):
                self.LoginButton.setTitle("Login", for: .normal)
                self.userInteraction(true)
                print("Error in login")
            }
        }
    }
    
    // MARK: Defaults Funtions.
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Offline login work
        
        if offlineLogin.shared.isAlerdyLogin()
        {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            {
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        self.navigationItem.title = "Presto Driver"
        
        self.AddToFirstVC()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {  super.viewWillAppear(animated)
        
        self.LoginButton.setTitle("Login", for: .normal)
        
        navigationItem.hidesBackButton = true
        
        // BoundsWorking.
        
        bounds(yourView: LoginButton, integer: 5)
        bounds(yourView: registration_button, integer: 5)
        self.registration_button.layer.borderColor = UIColor.white.cgColor
        self.registration_button.layer.borderWidth = 1.0
        self.registration_button.titleShadowColor(for: .normal)
        
               // Keyboard Working :-
        
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //MARK: ViewControllers Management
        
        if loadAfterRideCompletion
        {
            self.openHomeWithoutAnimation()
            
            loadAfterRideCompletion = true
        }
    }
    
    // MARK: Deligates :-
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
        case 101 , 102 , 103 , 104 :
            if (textField.text?.characters.count)! < 1 && string.characters.count > 0
            {
                if textField.tag != 104
                {
                    let nexttag = textField.tag + 1
                    
                    var nextResponder = textField.superview?.viewWithTag(nexttag)
                    
                    if (nextResponder != nil)
                    {
                        nextResponder?.becomeFirstResponder()
                    }
                    else
                    {
                        nextResponder = textField.superview?.viewWithTag(101)
                    }
                    textField.text = string
                    
                    return false
                }
            }
            else
                if (textField.text?.characters.count)! > 0 && string.characters.count == 0
                {
                    
                    let nexttag = textField.tag - 1
                    
                    var nextResponder = textField.superview?.viewWithTag(nexttag)
                    
                    if (nextResponder != nil)
                    {
                        nextResponder?.becomeFirstResponder()
                    }
                    else
                    {
                        nextResponder = textField.superview?.viewWithTag(101)
                    }
                    textField.text = string
                    
                    return false
                }
                else
                {
                    if (textField.text?.characters.count)! >= 1
                    {
                        let char = string.cString(using: String.Encoding.utf8)!
                        
                        let isBackSpace = strcmp(char, "\\b")
                        
                        let notAllowed = "1234567890€£¥|•~`!@#$%^&*()_+{}:<>?/.,;'[]=-'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz€£¥|•~`!@#$%^&*()_+{}:<>?/.,;'[]=-'"
                        
                        if (isBackSpace == -92)
                        {
                        }
                        else
                        {
                            let set = NSCharacterSet(charactersIn:notAllowed)
                            let inverted = set.inverted
                            
                            let filtered = string.components(separatedBy:inverted).joined(separator:"")
                            
                            return filtered != string
                        }
                    }
            }
            break
            
        default:
            print("On that field")
        }
        return true
    }
}

//MARK: ViewControllers Management

extension ViewController
{
    func openHomeWithoutAnimation()
    {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as? HomeVC
        {
            vc.fromEndRide = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
