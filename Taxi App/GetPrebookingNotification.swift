//
//  GetPrebookingNotification.swift
//  PrestoRideDriver
//
//  Created by User on 29/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import Foundation
import UIKit

struct prebookHandler
{
  static var uniqueId = String()
}

class CheckPreBooking
{
    static var preBookingTimer = Timer()
    
    static func checkBooking( completionHandler: @escaping (Int? , String?) -> ())
    {
        prebookHandler.uniqueId = ""
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        
        let strForSend = formatter.string(from: date)
        
        let parameters =
            [
                "driver_id"   : Global.driverCurrentId,
                "current_date" : strForSend
            ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/driver/checkPrebooking".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON
                    {   response in
                        
                        let json = JSON(data : response.data!)
                        
                        if let result = json["result"].int
                        {
                            if result == 2
                            {
                                prebookHandler.uniqueId = String(describing : json["data"][0]["id"])
                                
                                let id : String = String(describing : json["data"][0]["formated_id"])
                                
                                completionHandler(result , id)
                                
                            }
                            else
                            if result == 1
                            {
                                completionHandler(0 , "error")
                            }
                        }
                }
            case .failure(_):
                print("Error in Getting PreBookingRequest")
            }
        }
    }
    
    static func sendToServer()
    {
        let parameters =
            [
                "id"   : prebookHandler.uniqueId
            ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/driver/confirmPrebooking".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON
                    {   response in
                        
                        let json = JSON(data : response.data!)
                        
                        if json["result"].int == 1
                        {
                           print("Status Updated")
                           prebookHandler.uniqueId = ""
                        }
                }
            case .failure(_):
                print("Error in updating prebook status")
            }
        }
    }
}
