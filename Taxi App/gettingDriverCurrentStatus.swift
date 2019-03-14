
//  gettingDriverCurrentStatus.swift
//  PrestoRideDriver
//  Created by User on 20/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.


import Foundation

extension BaseViewController
{
    func gettingCurrentStatus()
    {
        requestManual("\(Global.DomainName)/latlong/get/one/\(Global.driverCurrentId)", method: .get).responseJSON{ response in
            
            switch response.result
            {
            case .success(let value):
                
                let json = JSON(value)
                
                if String(describing : json["result"]) == "1"
                {
                    if json["data"].array?.isEmpty == false
                    {
                        if String(describing : json["data"][0]["status"]) != ""
                        {
                            if String(describing : json["data"][0]["status"]) == "0"
                            {
                                self.buttonStartBreakOutlet.setTitle("END BREAK", for: .normal)
                            }
                            else
                            {
                                self.buttonStartBreakOutlet.setTitle("START BREAK", for: .normal)
                            }
                        }
                    }
                }
                break
            case .failure(_):
                print("Error in getting current status")
                self.gettingCurrentStatus()
            }
        }
    }
}

