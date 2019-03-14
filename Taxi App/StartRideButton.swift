//
//  StartRideButton.swift
//  PrestoRideDriver
//
//  Created by User on 05/11/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import Foundation
import UIKit


import GoogleMaps

// MARK: Flow

// FLow Getting data from here and when user click back button we have a funtion on viewDidAppear which allow us when prebooking is enable create a polyline and a button with time calculatio help to work in a flow.


extension Pre_Order
{
    @objc func RideNowClicked(_ sender : UIButton)
    {
        PreBookingTask.isForPrebooking = true
        PreBookingTask.formattedIdNeedToSend = data[sender.tag].formattedId
        PreBookingTask.bookingIdNeedToSend   = data[sender.tag].bookingId
        PreBookingTask.phone = data[sender.tag].pPhone
        PreBookingTask.latLongAll =
            [
                "pickLat" : data[sender.tag].pickLat,
                "pickLong": data[sender.tag].pickLong,
                "dropLat" : data[sender.tag].dropLat,
                "dropLong" : data[sender.tag].dropLong,
        ]
        if PreBookingTask.formattedIdNeedToSend != "" && PreBookingTask.bookingIdNeedToSend != "" && PreBookingTask.latLongAll != [:]
        {
            NotificationCenter.default.post(name: NSNotification.Name("RAMBAAN"), object: nil)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

extension Recent_Order
{
    @objc func RideNowClicked(_ sender: UIButton)
    {
        InstantBookingTask.isForInstantBooking = true
        InstantBookingTask.formattedIdNeedToSend = data[ sender.tag].formattedId
        InstantBookingTask.bookingIdNeedToSend = data[sender.tag].bookingId
        InstantBookingTask.phone = data[sender.tag].Phone
        InstantBookingTask.latLongAll =
            [
                "pickLat" : data[sender.tag].pickLat,
                "pickLong": data[sender.tag].pickLong,
                "dropLat" : data[sender.tag].dropLat,
                "dropLong" : data[sender.tag].dropLong,
        ]
        if InstantBookingTask.formattedIdNeedToSend != "" && InstantBookingTask.bookingIdNeedToSend != "" && InstantBookingTask.latLongAll != [:] {
            NotificationCenter.default.post(name: NSNotification.Name("RAMBAAN"), object: nil)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
extension BaseViewController
{
    func CreatePreBookingPolyline()
    {
        requestManual("https://maps.googleapis.com/maps/api/directions/json?origin=\(Double(PreBookingTask.latLongAll["pickLat"]!)!),\(Double(PreBookingTask.latLongAll["pickLong"]!)!)&destination=\(Double(PreBookingTask.latLongAll["dropLat"]!)!),\(Double(PreBookingTask.latLongAll["dropLong"]!)!)&key=\(Global.googleDirectionApiKey)".replacingOccurrences(of: " ", with: "")).responseJSON
            { response in
                
                switch response.result
                {
                case .success(let value):
                    
                    let json = JSON(value)
                    if json["routes"].array?.isEmpty == false
                    {
                        var selectedRoute = json["routes"][0]
                        let routeOverviewPolyline = selectedRoute["overview_polyline"]
                        let points = routeOverviewPolyline["points"].string
                        let path = GMSPath.init(fromEncodedPath: points!)
                        let polyline = GMSPolyline.init(path: path)
                        polyline.strokeColor = UIColor.blue
                        polyline.strokeWidth = 4

                        polyline.map = self.googleMap
                        if let long = selectedRoute["legs"][0]["start_location"]["lng"].rawValue as? Double {
                            if let lat = selectedRoute["legs"][0]["start_location"]["lat"].rawValue as? Double {
                                self.googleMap.moveCamera(GMSCameraUpdate.setTarget(CLLocationCoordinate2D(latitude: lat, longitude: long), zoom: 11))
                            }
                        }
                    }
                    
                case .failure(_):
                    print("Error in create polyline 1")
                }
        }
    }
    
    func CreatePreBookingPolyline1()
    {
        requestManual("https://maps.googleapis.com/maps/api/directions/json?origin=\(Double(InstantBookingTask.latLongAll["pickLat"]!)!),\(Double(InstantBookingTask.latLongAll["pickLong"]!)!)&destination=\(Double(InstantBookingTask.latLongAll["dropLat"]!)!),\(Double(InstantBookingTask.latLongAll["dropLong"]!)!)&key=\(Global.googleDirectionApiKey)".replacingOccurrences(of: " ", with: "")).responseJSON
            { response in
                
                switch response.result
                {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    if json["routes"].array?.isEmpty == false
                    {
                        var selectedRoute = json["routes"][0]
                        let routeOverviewPolyline = selectedRoute["overview_polyline"]
                        let points = routeOverviewPolyline["points"].string
                        let path = GMSPath.init(fromEncodedPath: points!)
                        let polyline = GMSPolyline.init(path: path)
                        polyline.strokeColor = UIColor.blue
                        polyline.strokeWidth = 4
                        
                        polyline.map = self.googleMap
                        if let long = selectedRoute["legs"][0]["start_location"]["lng"].rawValue as? Double {
                            if let lat = selectedRoute["legs"][0]["start_location"]["lat"].rawValue as? Double {
                                self.googleMap.moveCamera(GMSCameraUpdate.setTarget(CLLocationCoordinate2D(latitude: lat, longitude: long), zoom: 11))
                            }
                        }
                    }
                    
                case .failure(_):
                    print("Error in create polyline 1")
                }
        }
    }
}
