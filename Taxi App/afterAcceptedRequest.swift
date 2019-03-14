//
//  afterAcceptedRequest.swift
//  PrestoRideDriver
//
//  Created by User on 20/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit
import MapKit
import CoreLocation

extension BaseViewController
{
    
    func getUserData()
    {
        afterAcceptedTask.timer.invalidate()
        afterAcceptedTask.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(showPassengerOnMap), userInfo: nil, repeats: true)
    }
    
    func showPassengerOnMap()
    {
        let parameters =
            [
                "formated_id": mapTask.formattedID
            ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/driver/get_bookingdetails".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    let json = JSON(data : response.data!)
                    
                    if json["result"].int == 1
                    {
                        afterAcceptedTask.customerPickLatlongName =
                            [
                                "P_lat" : String(describing : json["data"][0]["pick_latitude"]),
                                "P_lng" : String(describing : json["data"][0]["pick_longitude"]),
                                "P_name" : String(describing : json["data"][0]["pick_location"]),
                                "D_lat" : String(describing : json["data"][0]["drop_latitude"]),
                                "D_lng" : String(describing : json["data"][0]["drop_langitude"]),
                                "D_name" : String(describing : json["data"][0]["drop_location"]),
                                "FirstName" : String(describing : json["data"][0]["first_name"]),
                                "LastName" : String(describing : json["data"][0]["last_name"]),
                                "Phone" : String(describing : json["data"][0]["phone"])
                           ]
                        afterAcceptedTask.bookingId = String(describing : json["data"][0]["bid"])
                        afterAcceptedTask.phone = String(describing : json["data"][0]["phone"])
                      
                        self.checkingCancellation()
                        afterAcceptedTask.timer.invalidate()
//                        self.Spinner(Task: 2, tag: 78544)
                        self.CreatePolyline1()
                        self.createUIforCalling()
                    }
                }
                case.failure(_):
                print("Error in Getting Booking details")
            }
        }
    }
    
    func createUIforCalling()
    {
        buttonStartBreakOutlet.isHidden = true
        
        let ui = UIButton()
        ui.addTarget(self, action: #selector(call), for: UIControlEvents.touchUpInside)
        ui.tag = 98600
        ui.backgroundColor = UIColor.blue
        ui.setTitle("Call Passenger", for: .normal)
        ui.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)
        
        view.addSubview(ui)
        
        ui.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: ui, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: ui, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50))
        
        view.addConstraint(NSLayoutConstraint(item: ui, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: -1))
        
        view.addConstraint(NSLayoutConstraint(item: ui, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0))
        
        let ui2 = UIButton()
        ui2.addTarget(self, action: #selector(rideNowAction), for: UIControlEvents.touchUpInside)
        ui2.tag = 98601
        ui2.backgroundColor = UIColor.blue
        ui2.setTitle("Start Ride", for: .normal)
        ui2.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)
        
        view.addSubview(ui2)
        
        ui2.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: ui2, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: ui2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50))
        
        view.addConstraint(NSLayoutConstraint(item: ui2, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: -1))
        
        view.addConstraint(NSLayoutConstraint(item: ui2, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0))
        
        //MARK: Create Navigation Button
        
        self.addNavigationButton(true)
        
        afterAcceptedTask.isBeforeRideComplete = true
    }
    
    func call()
    {
        var Phone : String?
        
        if PreBookingTask.isForPrebooking
            
        {
            Phone = PreBookingTask.phone
        }
        else if InstantBookingTask.isForInstantBooking
        {
            Phone = InstantBookingTask.phone
        }
       else
            
       {
           Phone = afterAcceptedTask.phone
        }

       // Phone=afterAcceptedTask.phone
        Phone =   Phone!
        
        // call passenger menu....
        if let url = URL(string : "tel://\(Phone ?? "")")
        {
            UIApplication.shared.openURL(url)
           // print("Calling Passenger")
        }
    }
    
    func rideNowAction()
    {
        RideNowClass.RideNow()
        self.addNewButton()
        afterAcceptedTask.isBeforeRideComplete = false
    }
    
    func addNavigationButton(_ addButton : Bool)
    {
        if addButton
        {
            let item2 = UIBarButtonItem(title: "Navigate", style: .plain, target: self, action: #selector(navigate))
                  self.navigationItem.setRightBarButtonItems([item2], animated: true)
        }
        else
        {
            self.navigationItem.setRightBarButton(nil, animated: false)
        }
    }
        func navigate()
        {
        var lat = Double()
        var long = Double()
        
        var str : String?
        
        if afterAcceptedTask.isBeforeRideComplete
        {
            lat = afterAcceptedTask.passengerPickLocaion.position.latitude
           long = afterAcceptedTask.passengerPickLocaion.position.longitude
            str = "Passenger PickUp Location"
        }
        else
        {
            lat = afterAcceptedTask.passengerDropLocaion.position.latitude
            long = afterAcceptedTask.passengerDropLocaion.position.longitude
            str = "Passenger DropOff Location"
        }
        
        let coordinates = CLLocationCoordinate2DMake(lat,long)
        
        let place = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        
        let mapItem = MKMapItem (placemark: place)
        
        mapItem.name = str
        
        let options = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving , MKLaunchOptionsShowsTrafficKey : true ] as [String  : Any]
        
        MKMapItem.openMaps(with: [mapItem], launchOptions: options)
        }

    func CreatePolyline1()
    {
          requestManual("https://maps.googleapis.com/maps/api/directions/json?origin=\(mapTask.driverCurrentLocation.position.latitude),\(mapTask.driverCurrentLocation.position.longitude)&destination=\(afterAcceptedTask.customerPickLatlongName["P_lat"]!),\(afterAcceptedTask.customerPickLatlongName["P_lng"]!)&key=\(Global.googleDirectionApiKey)".replacingOccurrences(of: " ", with: "")).responseJSON
            { response in
                
                switch response.result
                {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    if json["routes"].array?.isEmpty == false
                    {
                        let path = GMSPath.init(fromEncodedPath: json["routes"][0]["overview_polyline"]["points"].string!)
                        
                        let singleLine = GMSPolyline.init(path: path)
                        
                        singleLine.strokeWidth = 4
                        singleLine.strokeColor = UIColor.blue
                        singleLine.map = self.googleMap
                        
                        self.CreatePolyline2()
                        
                        afterAcceptedTask.passengerPickLocaion.position = CLLocationCoordinate2D(latitude: Double(afterAcceptedTask.customerPickLatlongName["P_lat"]!)!, longitude: Double(afterAcceptedTask.customerPickLatlongName["P_lng"]!)!)
                        afterAcceptedTask.passengerPickLocaion.title = "Passenger pickUp Location"
                        afterAcceptedTask.passengerPickLocaion.icon = #imageLiteral(resourceName: "black icon")
                        afterAcceptedTask.passengerPickLocaion.snippet = afterAcceptedTask.customerPickLatlongName["P_name"]!
                        afterAcceptedTask.passengerPickLocaion.map = self.googleMap
                    }
                    case .failure(_):
                    print("Error in getting estimate cost")
                }
        }
    }
    
    fileprivate func CreatePolyline2()
    {
        requestManual("https://maps.googleapis.com/maps/api/directions/json?origin=\(afterAcceptedTask.customerPickLatlongName["P_lat"]!),\(afterAcceptedTask.customerPickLatlongName["P_lng"]!)&destination=\(afterAcceptedTask.customerPickLatlongName["D_lat"]!),\(afterAcceptedTask.customerPickLatlongName["D_lng"]!)&key=\(Global.googleDirectionApiKey)".replacingOccurrences(of: " ", with: ""), method: .get).responseJSON
            { response in
                
                switch response.result
                {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    if json["routes"].array?.isEmpty == false
                    {
                        
                        let path = GMSPath.init(fromEncodedPath: json["routes"][0]["overview_polyline"]["points"].string!)
                
                        let singleLine = GMSPolyline.init(path: path)
                        singleLine.strokeWidth = 4
                        singleLine.strokeColor = UIColor.red
                        singleLine.map = self.googleMap
                        afterAcceptedTask.passengerDropLocaion.position = CLLocationCoordinate2D(latitude: Double(afterAcceptedTask.customerPickLatlongName["D_lat"]!)!, longitude: Double(afterAcceptedTask.customerPickLatlongName["D_lng"]!)!)
                        afterAcceptedTask.passengerDropLocaion.title = "Passenger dropOff Location"
                        afterAcceptedTask.passengerDropLocaion.icon = #imageLiteral(resourceName: "green icon")
                        afterAcceptedTask.passengerDropLocaion.snippet = afterAcceptedTask.customerPickLatlongName["D_name"]!
                        afterAcceptedTask.passengerDropLocaion.map = self.googleMap
                                  }
                case .failure(_):
                    print("Error in getting estimate cost")
                }
        }
    }
}
