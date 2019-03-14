//
//  SendMessages.swift
//  PrestoRideDriver
//
//  Created by User on 29/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import Foundation




class SendMessages
{
    static func sendMessage(message : String , completionHandler: @escaping (Int?) -> ())
    {
        
        let parameters =
            [
                "driver_id"   : Global.driverCurrentId,
                "message"     : message
           ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/driver/add_drivermessage".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = JSON(data : response.data!)
                    
                    if json["result"].int == 1
                    {
                        completionHandler(5)
                    }
                    else
                    {
                        completionHandler(0)
                    }
                    
                }
            case .failure(_):
                print("Error in Getting PreBookingRequest")
            }
        } 
    }
}
/*
class getAllMessages
{
  static func getAllMessages()
  {
    
    let parameters =
        [
          "driver_id"   : Global.driverCurrentId
        ]
    
    upload(multipartFormData: { (multipartFormData) in
        
        for (key, value) in parameters
        {
            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
        }
        }, to:"\(Global.DomainName)/driver/get_drivermessage".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
    { (result) in
        switch result {
        case .success(let upload, _, _):
            
            upload.responseJSON { response in
                
                let json = JSON(data : response.data!)
                
                if json["result"].int == 1
                {
                    
                }
            }
        case .failure(_):
            print("Error in Getting Messages")
        }
    }
    }
}
*/
