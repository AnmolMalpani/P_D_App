//
//  EndTripWorking.swift
//  PrestoRideDriver
//
//  Created by User on 27/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import Foundation
import UIKit



extension BaseViewController
{
    func calculateTime()          // Calling from button Ride Now. Func :- RideNow
    {
        endTripWorking.tripTime = Timer.scheduledTimer(timeInterval: TimeInterval(60), target: self, selector: #selector(calculationOfTime), userInfo: nil, repeats: true)
    }
    
    func calculationOfTime()
    {
        endTripWorking.minutes = endTripWorking.minutes + 1
       
        if  endTripWorking.minutes == 60
        {
            endTripWorking.hour = endTripWorking.hour + 1

            endTripWorking.minutes = 0
        }
    }
}
