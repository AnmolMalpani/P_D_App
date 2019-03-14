
//  File.swift
//  PrestoRideDriver
//  Created by User on 19/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.


import Foundation
extension BaseViewController
{
func startBreak(_ status : String = "") // Send status only when driver press cancel at the end
    {
        let parameters =
            [
                "status": statusStartEndBreak,
                "driver_id" : Global.driverCurrentId
            ]
           upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/driver/driverbreak".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                          upload.responseJSON { response in
                     let json = JSON(data : response.data!)
                     if json["result"].int == 1
                    {
                        if self.statusStartEndBreak == "0"
                        {
                         self.buttonStartBreakOutlet.setTitle("END BREAK", for: .normal)
                         }
                        else
                        if self.statusStartEndBreak == "1" 
                        {
                        self.buttonStartBreakOutlet.setTitle("START BREAK", for: .normal)
                        }
                    }
                }
                case .failure(_):
                print("Error in login")
            }
        }
    }
    
}
