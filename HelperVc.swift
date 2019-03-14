//
//  HelperVc.swift
//  PrestoRideDriver
//
//  Created by User on 29/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import UIKit

class HelperVc: UITableViewController , UITextFieldDelegate
{
    
    @IBOutlet var textAll: [UITextField]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        getEstimateData()
        
        endTripWorking.tripTime.invalidate()
        
        self.textAll[0].text = "\(endTripWorking.hour) hours & \(endTripWorking.minutes) minutes"
        
        self.textAll[1].text = "Loading.."
        
        self.textAll[1] .isUserInteractionEnabled = false
        
         self.textAll[2] .isUserInteractionEnabled = false
        
        self.textAll[2].text = "Loading.."
    }
    
    func getEstimateData()
    {
        var parameters = [String : String]()
        
        if PreBookingTask.isForPrebooking == false && InstantBookingTask.isForInstantBooking == false
        {
            parameters =
                [
                    "booking_id"       : afterAcceptedTask.bookingId
            ]
        }
        else if PreBookingTask.isForPrebooking == true && InstantBookingTask.isForInstantBooking == false
        {
            parameters =
                [
                    "booking_id"       : PreBookingTask.bookingIdNeedToSend,
                ]
        }
        else if InstantBookingTask.isForInstantBooking == true && PreBookingTask.isForPrebooking == false
        {
            parameters =
                [
                    "booking_id"       : InstantBookingTask.bookingIdNeedToSend
                ]
        }
        else
        {
            
        }
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/driver/get_estimateprice_duration")
        { (result) in
            
            switch result {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = JSON(data : response.data!)
                    
                    if json["result"].int == 1
                    {
                        self.textAll[1].text = String(describing : json["data"]["distance"]) + " " + "Miles"
                        self.textAll[2].text = String(describing : json["data"]["price"])
                    }
                    else
                    {
                        self.textAll[1].text = "Error in Loading."
                        self.textAll[2].text = "Error in Loading."
                    }
                }
            case .failure(_):
                print("Error in Getting Estimate cost End trip")
            }
        }
        }
     @IBAction func calcelTrip(_ sender: AnyObject)
     {
        self.goToHome()
        
        BaseViewController().startBreak("1")
        PreBookingTask.isForPrebooking = false
        InstantBookingTask.isForInstantBooking = false
     }
    
    @IBAction func buttonConfirm(_ sender: AnyObject)
    {
        sendEndTripDataToServer()
    }
    
    func sendEndTripDataToServer()
    {
        if  textAll[1].text! == "" || textAll[2].text! == ""
        {
            self.presentAlertWithTitle(title: "Error", message: "Fill All Details")
        }
        else
        {
            self.createFakeBackground(create: true)
//            self.Spinner(Task: 1, tag: 0)
            
            var parameters = [String : String]()
            
            let distance = textAll[1].text!.replacingOccurrences(of: "Miles", with: "").replacingOccurrences(of: " ", with: "")
            
            if PreBookingTask.isForPrebooking == false && InstantBookingTask.isForInstantBooking == false
            {
                parameters =   [
                    "id"       : afterAcceptedTask.bookingId,
                    "price"    : textAll[2].text!,
                    "distance" : distance,
                    "duration" : textAll[0].text!
                               ]
            }
            else if PreBookingTask.isForPrebooking == true && InstantBookingTask.isForInstantBooking == false
            {
                parameters =   [
                    "id"       : PreBookingTask.bookingIdNeedToSend,
                    "price"    : textAll[2].text!,
                    "distance" : distance,
                    "duration" : textAll[0].text!
                   ]
            }
            else if InstantBookingTask.isForInstantBooking == true && PreBookingTask.isForPrebooking == false
            {
                parameters =   [
                    "id"       : InstantBookingTask.bookingIdNeedToSend,
                    "price"    : textAll[2].text!,
                    "distance" : distance,
                    "duration" : textAll[0].text!
                    ]
            }
            else
            {
            }
            upload(multipartFormData: { (multipartFormData) in
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                }, to:"\(Global.DomainName)/driver/bookingConfirm".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        
                        let json = JSON(data : response.data!)
                        
                        if json["result"].int == 1
                        {
                            self.payNow()
                        }
                        else
                        {
//                          self.Spinner(Task: 2, tag: 0)
                            self.createFakeBackground(create: false)
                            self.presentAlertWithTitle(title: "Error", message: "Error in sending data try again")
                        }
                    }
                    break
                case .failure(_):
                    print("Error in Sending Booking Details")
                }
            }
        }
    }
    private func payNow()
    {
        var parameters = [String : String]()
        
        if PreBookingTask.isForPrebooking == false && InstantBookingTask.isForInstantBooking == false
        {
            parameters =
                [
                    "booking_id"       : afterAcceptedTask.bookingId
                ]
        }
        else if PreBookingTask.isForPrebooking == true && InstantBookingTask.isForInstantBooking == false
        {
            parameters =
                [
                    "booking_id"       : PreBookingTask.bookingIdNeedToSend,
                ]
        }
        else if InstantBookingTask.isForInstantBooking == true && PreBookingTask.isForPrebooking == false
        {
            parameters =
                [
                    "booking_id"       : InstantBookingTask.bookingIdNeedToSend,
                ]
        }
        else
        {
            
        }
        upload(multipartFormData: { (multipartFormData) in
            
        for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/driver/pay".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = JSON(data : response.data!)
                    
                    var title   = ""
                    var message = ""
                    
                    if json["result"].int == 1
                    {
//                        self.Spinner(Task: 2, tag: 0)
                        self.createFakeBackground(create: false)
                        
                        title   = "Success"
                        message = "Payment Completed Successfully"
                        
                        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default)
                        {
                            (action: UIAlertAction) in
                            
                            endTripWorking.DEINIT()
                            afterAcceptedTask.DEINIT()
                            mapTask.DEINIT()
                            PreBookingTask.DEINIT()
                            InstantBookingTask.DEINIT()
                            
                            for i in self.textAll
                            {
                                i.text = ""
                            }
                            self.goToHome()
                        }
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion: nil)
                        }
                        else
                       {
//                        self.Spinner(Task: 2, tag: 0)
                        self.createFakeBackground(create: false)
                        title = "Error"
                        message = "Payment Failed"
                        
                        if json["result"].int == 2
                        {
                            message = String(describing : json["massage"])
                        }
                        
                        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "Try Again", style: .default)
                        {
                            (action: UIAlertAction) in
                            self.payNow()
                        }
                        let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction) in
                            
                            endTripWorking.DEINIT()
                            afterAcceptedTask.DEINIT()
                            mapTask.DEINIT()
                            PreBookingTask.DEINIT()
                            InstantBookingTask.DEINIT()
                            for i in self.textAll
                            {
                                i.text = ""
                            }
                            self.goToHome()
                        
                        })
                        alertController.addAction(OKAction)
                        alertController.addAction(Cancel)
                        self.present(alertController, animated: true, completion: nil)
                        }
                        }
                
                case .failure(_):
                print("Error in Payment")
            }
        }
    }
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let notAllowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz€£¥|•~`!@#$%^&*()_+{}:<>?/.,;'[]=-'"
        
        let char = string.cString(using: String.Encoding.utf8)!
        
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
        }
        else
        {
            switch textField.tag
            {
                
            case 350 , 351  :          // Only Allow Number
                
                let set = NSCharacterSet(charactersIn:notAllowedCharacters)
                let inverted = set.inverted
                
                let filtered = string.components(separatedBy:inverted).joined(separator:"")
                
                return filtered != string
                
            default :
                print("")
            }
            
        }
        return true
    }
}
//arun
extension HelperVc
{
    func goToHome()
    {
        if let vcs = self.navigationController?.viewControllers
        {
            for i in vcs
            {
                if i.isKind(of: ViewController.self)
                {
                    if let vc = i as? ViewController
                    {
                        _ = self.navigationController?.popToViewController(vc, animated: false)
                        
                        vc.loadAfterRideCompletion = true
                        
                        break
                    }
                }
            }
        }
    }
}


