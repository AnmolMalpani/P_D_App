//
//  PrebookingChecking.swift
//  PrestoRideDriver
//
//  Created by User on 29/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import Foundation
import UIKit

extension BaseViewController
{
    func checkPrebookingDidLoad()
    {
        CheckPreBooking.preBookingTimer.invalidate()
        CheckPreBooking.preBookingTimer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(checkMain), userInfo: nil, repeats: true)
    }
    
    func checkMain()
    {
        CheckPreBooking.checkBooking(completionHandler: {
            ( status , id ) in
            
            if let status = status
            {
                if let id = id
                {
                  if status == 2
                  {
                    let alertController = UIAlertController(title: "Alert", message: "You have to pickup a passenger in 30 minutes.\n Go to Recent Orders -> Pre-Booking to Start Ride. \n Look for Booking\(id)", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    {
                        (action: UIAlertAction) in
                        
                        CheckPreBooking.sendToServer()
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                  }
               }
            }
        })
    }    
}
