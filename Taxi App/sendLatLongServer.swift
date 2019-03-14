
//  sendLatLongServer.swift
//  PrestoRideDriver
//  Created by User on 20/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.

import Foundation
extension BaseViewController
{
    struct updateLatLong
    {
        static var timer = Timer()
        
        static func DEINT()
        {
            timer.invalidate()
        }
    }
       func forClassAdjustmentDriverLatLongUpdate()
      {
        updateLatLong.timer.invalidate()
        updateLatLong.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
      }
    
      func update()
      {
        DispatchQueue.global(qos: .background).async {
        let parameters =
                [
                    "driver_id" : String(Global.driverCurrentId),
                    "latitude"  : String(describing: mapTask.driverCurrentLocation.position.latitude),
                    "longitude" : String(describing: mapTask.driverCurrentLocation.position.longitude),
                    "car_type"  : Global.driverCarName
                ]
             upload(multipartFormData: { (multipartFormData) in
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                }, to:"\(Global.DomainName)/latlong/insert1".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON {
                        response in
                     }
                    break
                case .failure(_):
                    print("Error in updating LatLong")
                }
            }
        }
    }
}
