//
//  Registration.swift
//  Taxi App
//
//  Created by User on 11/12/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit

class Registration1: UITableViewController
{
    // MARK: Variables
    
    // UI Related
    
    /**
     Terms and condition validator
     */
    var isTermsAndConditionAccepted = false
    
    // Data Related
    
    let dropdown = DropDown()
    let vehicleDropdown = DropDown()
    var arrayForCountry = [String]()
    
       //MARK: Defaults
    
    override func viewDidLoad(){
        super.viewDidLoad()
        CountryDropdownDidLoad()
    }
        override func viewDidDisappear(_ animated: Bool){
        super.viewDidAppear(animated)
      }
      // Mark : Custom Funtions
    
        func setUpUI()  {
        /**
         Setting up UI here
         */
        self.btnTermsOfServices.layer.borderColor = btnTermsOfServices.titleLabel!.textColor.cgColor
        self.btnTermsOfServices.layer.borderWidth = 1
    }
    
    
      func CountryDropdownDidLoad()
       {
        dropdown.backgroundColor = UIColor.white
        
        if let path = Bundle.main.path(forResource: "Country", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null
                {
                    arrayForCountry = []
                    
                    for i in jsonObj["response"]["data"].array!
                    {
                        arrayForCountry.append(String(describing : i["country_name"] ))
                    }
                    
                    let array = arrayForCountry
                    
                    arrayForCountry = []
                    
                    arrayForCountry = array.reversed()
                    
                    arrayForCountry.remove(at: 226)
                    
                    arrayForCountry.insert("United States of America", at: 0)
                    
                    CountryDropDownFunction(dropdownName: dropdown, outlet: buttonOutletCountry, array : arrayForCountry)
                }
                else
                {
                    print("Could not get json from file, make sure that file contains valid json.")
                }
            }
            catch let error
            {
                print(error.localizedDescription)
            }
        }
            else
          {
            print("Invalid filename/path.")
          }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var buttonOutletCountry: NiceButton!
    
    @IBOutlet weak var txtFirstName: customTextField!
    
    @IBOutlet weak var txtLastName: customTextField!
    
    @IBOutlet weak var txtEmail: customTextField!
    
    @IBOutlet weak var txtPhnNumber: customTextField!
    
    @IBOutlet weak var txtVechileType: customTextField!
    
    @IBOutlet weak var txtVehicleMake: customTextField!
    
    @IBOutlet weak var txtVehicleModel: customTextField!
    
    @IBOutlet weak var txtLicenseNumber: customTextField!
    
    @IBOutlet weak var btnTick: UIButton!
    
    @IBOutlet weak var btnTermsOfServices: UIButton!
    
    //MARK: Actions
    
    @IBAction func btnVehicleType(_ sender: Any) {
        
        vehicleDropdown.anchorView = self.txtVechileType
        
        vehicleDropdown.dataSource = ["Business Class","SUV","First Class"]
        
        vehicleDropdown.selectionAction = { [] (index: Int, item: String) in
            
            self.txtVechileType.text = item
        }
        
        vehicleDropdown.reloadAllComponents()
        vehicleDropdown.show()
    }
    
    @IBAction func btnCountry(_ sender: Any)
    {
        dropdown.show()
        dropdown.reloadAllComponents()
    }
    
    @IBAction func btnTick(_ sender: UIButton)
    {
        let img = self.btnTick.imageView!.image == #imageLiteral(resourceName: "circle blank") ? #imageLiteral(resourceName: "circle Full") : #imageLiteral(resourceName: "circle blank")
        
        self.btnTick.setImage(img, for: .normal)
       self.isTermsAndConditionAccepted = img == #imageLiteral(resourceName: "circle Full")
    }
    
    @IBAction func buttonContinue(_ sender: AnyObject)
    {
        checkValidEmailOrPassword()
    }
    
    func checkValidEmailOrPassword() {
        
        let arrTextField = [ txtFirstName,
                             txtLastName,
                             txtEmail,
                             txtPhnNumber,
                             txtVechileType,
                             txtVehicleMake,
                             txtVehicleModel,
                             txtLicenseNumber]
            for i in arrTextField
            {
            if i!.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            {
                self.AlertpopUp(title: "Error", message: "All fields are mandatory")
                return;
            }
        }
        if !self.isValidEmail(testStr: txtEmail.text!)
        {
        self.AlertpopUp(title: "Error", message: "Please enter a valid email")
            
            return
        }
        
        if !isTermsAndConditionAccepted
        {
            self.AlertpopUp(title: "Error", message: "Please accept terms and condition")
            
            return
        }
        
        if buttonOutletCountry.titleLabel!.text!.lowercased() == "Select Country".lowercased()
        {
            self.AlertpopUp(title: "Error", message: "Please Select Country")
            
            return
        }
        
//        self.Spinner(Task: 1, tag: 454545)
        
        let parameters =
            [
                "email": txtEmail.text!,
                "mob_no" : txtPhnNumber.text!
        ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:"\(Global.DomainName)/driver/checkuser".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    //print response.result
                    
                    let json = JSON(data : response.data!)
                    
//                    self.Spinner(Task: 2, tag: 0)
                    
                    if json["result"].int == 0
                    {
//                        self.Spinner(Task: 2, tag: 454545)
                        self.presentAlertWithTitle(title: "Error", message: "Email is already taken. Try another.")
                    }
                    else if json["result"].int == 1
                    {
//                        self.Spinner(Task: 2, tag: 454545)
                        self.presentAlertWithTitle(title: "Error", message: "Mobile no. is already taken. Try another.")
                    }
                    else if json["result"].int == 2
                    {
                        self.regiterByService()
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func regiterByService()  {
        
        if netcheckker() != 0
        {
            
            let parameters =
                [
                    "first_name" : txtFirstName.text!,
                    "last_name" : txtLastName.text!,
                    "email" : txtEmail.text!,
                    "mob_no" : txtPhnNumber.text! ,
                    "united_state" : buttonOutletCountry.titleLabel!.text! ,
                    "type" : txtVechileType.text!,
                    "vehicle_make" : txtVehicleMake.text!,
                    "model" : txtVehicleModel.text!,
                    "plate_number" : txtLicenseNumber.text!
               ]
            
            upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, to:"\(Global.DomainName)/driver/registration")
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        
                        if let check = self.view.viewWithTag(12154) as? UIProgressView
                        {
                            check.progress = Float(progress.fractionCompleted)
                        }
                    })
                    
                    upload.responseJSON
                        {
                            response in
                            
                            let json = JSON( data : response.data!)
                            
                            if String(describing : json["result"]) == "1"
                            {
                                let alertController = UIAlertController(title: "Success",message:"Registered Successfully" , preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default)
                                {
                                    (action: UIAlertAction) in
                                    
                                    _ = self.navigationController?.popToRootViewController(animated: true)
                                    
                                }
                                alertController.addAction(OKAction)
                                self.present(alertController, animated: true, completion: nil)
                                
                            }
                            else
                            {
                                self.presentAlertWithTitle(title: "Note", message: json["massage"].string!)
                            }
                    }
                    
                case .failure(_):
                    print("error in final registration")
                }
            }
        }
        
        
    }
}
