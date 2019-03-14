
//  ChekingPassenger.swift
//  PrestoRideDriver
//  Created by User on 21/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.

import Foundation
import UIKit

extension BaseViewController
{
    func checkingCancellation()
    {
        afterAcceptedTask.timer2.invalidate()
        afterAcceptedTask.timer2 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkingCancellation2), userInfo: nil, repeats: true)
    }
    
    func checkingCancellation2()
    {
        requestManual("\(Global.DomainName)/driver/bookingStatus/\(afterAcceptedTask.bookingId)".replacingOccurrences(of: " ", with: "")).responseJSON
            { response in
                
                switch response.result
                {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    if json["result"].int == 1
                    {
                        if json["data"].array?.isEmpty == false
                        {
                            if String(describing : json["data"][0]["status"]) == "0"
                            {
                                //print("Status is 0")
                            }
                            else
                            if String(describing : json["data"][0]["status"]) == "1"
                            {
                               afterAcceptedTask.timer2.invalidate()
                               self.diaapearButtons()
                            }
                            else
                            {
                                afterAcceptedTask.timer2.invalidate()
                            }
                        }
                    }
                    
                case .failure(_):
                    print("Error in getting cancelation of passenger")
                }
          }
    }
    
    func diaapearButtons()
    {
     self.googleMap.clear()
        
     let alertController = UIAlertController(title: "Update", message: "Ride request cancelled by passenger", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) {
                  (action: UIAlertAction) in
                
                afterAcceptedTask.DEINIT()
                mapTask.DEINIT()
                
                self.buttonStartBreakOutlet.isHidden = false
                
                if let v1 : UIButton = self.view.viewWithTag(98600) as? UIButton
                {
                    v1.removeFromSuperview()
                }
                
                if let v2 : UIButton = self.view.viewWithTag(98601) as? UIButton
                {
                    v2.removeFromSuperview()
                }
                
                self.navigationItem.setRightBarButtonItems(nil, animated: true)
                
                self.alertDidLoad()
                                                                         }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
    }
}
