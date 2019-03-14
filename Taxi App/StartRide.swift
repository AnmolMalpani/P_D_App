
//  StartRide.swift
//  PrestoRideDriver
//  Created by User on 27/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.

import Foundation

class RideNowClass
{
    static func RideNow()
    {
        var parameters = [String : String]()
        
        if PreBookingTask.isForPrebooking  == false && InstantBookingTask.isForInstantBooking == false
        {
            parameters =
            [
                "formated_id": mapTask.formattedID
            ]
        }
            else if PreBookingTask.isForPrebooking == true && InstantBookingTask.isForInstantBooking == false
        {
            parameters =
                [
                    "formated_id": PreBookingTask.formattedIdNeedToSend
                ]
        }
        else if InstantBookingTask.isForInstantBooking == true && PreBookingTask.isForPrebooking == false
        {
           parameters =
            [
                "formated_id": InstantBookingTask.formattedIdNeedToSend
            ]
        }
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/driver/startRide".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
            upload.responseJSON { response in
                    
                    let json = JSON(data : response.data!)
                    
                    if json["result"].int == 1
                    {
                      print("Booking Status Updated Sucessfully")
                      let vc = BaseViewController()
                      vc.calculateTime()
                    }
                }
                
            case .failure(_):
                print("Error in rideNow Class")
            }
        }
    }
}
