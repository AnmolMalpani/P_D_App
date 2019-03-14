//
//  Global.swift
//  Taxi App
//
//  Created by User on 09/12/16.
//  Copyright © 2016 User. All rights reserved.
//

import Foundation
import UIKit


var isFinishedBooking = false

struct Global
{
    static var DomainName = "https://prestoridebooking.com/index.php"
    static var googleMapApiKey = "AIzaSyBJdHv9pzv2U1QchOdfRHlIHpQ3gjAEnqE"
    static var googleDirectionApiKey = "AIzaSyA6H-HEC4I8TEuROKmW6F9y7mVIlaab4HQ"

    static var driverCurrentId = String()
    static var driverCarName = String()

    //static var driverCurrentId = "37"
    //static var driverCarName = "MINIVAN"
    static var isOnLocation  =  Bool()
}

//MARK: UserInfo for offline login

fileprivate let DiverIdKey = "DirverId"

fileprivate let DriverCarKey = "DriverCar"

struct offlineLogin {
    
    static let shared = offlineLogin()
    
    func isAlerdyLogin() -> Bool
    {
        if let userId = UserDefaults.standard.string(forKey: DiverIdKey) , let driverCarName = UserDefaults.standard.string(forKey: DriverCarKey)
        {
            Global.driverCurrentId = userId
            
            Global.driverCarName =  driverCarName
            
            return true
        }
        
        return false
    }
    
    func setLoginId(_ driverId : String,_ driverCarName : String)
    {
        UserDefaults.standard.set(driverId, forKey: DiverIdKey)
        UserDefaults.standard.set(driverCarName, forKey: DriverCarKey)
    }
    
    func deleteUserInfo()
    {
        UserDefaults.standard.removeObject(forKey: DiverIdKey)
        UserDefaults.standard.removeObject(forKey: DriverCarKey)
    }
}



// SppinnerTask :- // 98585  , 98586 , 78544 , 98600 , 98601 , 98700 , 98702 , 98703 , 98704 , 98705 , 98706
//                98707  , 98709  , 98710, 98711 , 98712 , 98713 , 98714 , 98715 , 98720
// 98717



// TextFieldTagInfo :-


// view 1 registration :- 200 -- 211

// view 2 reg :- 212 - 223

// view 3 final button tag :- 225 -- 231

// Refer Driver :- 320,  330

// ReviewTrip :-  350 , 351

// PROFILE EDITING VIEW :-


// VIEW 1 Main :-  300 - 305

// VehicleUpdate : -  310 , 311 , 312 , 313 , 314 , 315 , 316




