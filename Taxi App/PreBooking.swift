
//  Recent Order.swift
//  Taxi App
//  Created by User on 10/12/16.
//  Copyright © 2016 User. All rights reserved.

import UIKit
import CoreLocation
import MapKit
import GoogleMaps

struct PrebookingValue
{
    var pickLat       : String
    var pickLong      : String
    var dropLat       : String
    var dropLong      : String
    var formattedId   : String
    var time          : String
    var pName         : String
    var pEmail        : String
    var pPhone        : String
    var pickLocation  : String
    var dropLocation  : String
    var price         : String
    var bookingId     : String
    var status        : String
}

class Pre_Order: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableviewOutletPreOrder: UITableView!
    
    var data = [PrebookingValue]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = "Pre_Booking Orders"
        
        tableviewOutletPreOrder.estimatedRowHeight = 50
        tableviewOutletPreOrder.rowHeight          = UITableViewAutomaticDimension
        getData()
    }
    
    func getData()
    {
//        self.Spinner(Task: 1, tag: 98713)
        
        requestManual("\(Global.DomainName)/driver/getbooking/\(Global.driverCurrentId)", method: .get).responseJSON{ response in
            
            switch response.result
            {
            case .success(let value):
                
                let json = JSON(value)
                
                if json["result"].int == 1
                {
                    if json["data"].array?.isEmpty == false
                    {
                        self.data = []
                        
                        for i in json["data"].array!
                        {
                            if String(describing : i["type"]) == "pre-booking"
                            {
                                let time = String(describing : i["pre_bookingtime"])
                                let pPhone
                                    = String(describing : i["phone"])
                                
                                self.data.append(
                                    
                    PrebookingValue(
                                        pickLat : String(describing : i["pick_latitude"]),
                                        pickLong : String(describing : i["pick_longitude"]),
                                        dropLat : String(describing : i["drop_latitude"]),
                                        dropLong : String(describing : i["drop_langitude"]),
                                        formattedId: String(describing : i["formated_id"]),
                                        time: time,
                                        pName: String(describing : i["first_name"]) + " " + String(describing : i["last_name"]),
                                        pEmail: String(describing : i["email"]),
                                        pPhone: pPhone ,
                                        pickLocation: String(describing : i["pick_location"]),
                                        dropLocation: String(describing : i["drop_location"]),
                                        price: String(describing : i["approximate_price"]),
                                        bookingId : String(describing : i["id"]),
                                        status    : String(describing : i["status"])
                                    )  
                                )
                            }
                        }
//                        self.Spinner(Task: 2, tag: 98713)
                        self.tableviewOutletPreOrder.reloadData()
                    }
                }
                else
                if json["result"].int == 0
                {
                        self.presentAlertWithTitle(title: "Error", message: "You Don't Have Any Order Yet")
//                        self.Spinner(Task: 2, tag: 98713)
                }
                
            case .failure(_):
                print("Error in getting Pre_Bookings details")
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreBookingCell", for: indexPath) as! PreBookingCell
        
        if data[indexPath.row].status == "0"
        {
           cell.startRideButton.setTitle("Start Ride", for: .normal)
           cell.startRideButton.setTitleColor(UIColor.white, for: .normal)
           cell.startRideButton.backgroundColor = UIColor.init(red: 20/255, green: 79/255, blue: 84/255, alpha: 1.0)
           cell.startRideButton.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightSemibold)
           cell.startRideButton.tag = indexPath.row
           cell.startRideButton.addTarget(self, action: #selector(RideNowClicked(_:)), for: .touchUpInside)
        }
        else
        if data[indexPath.row].status == "1"
        {
           cell.startRideButton.setTitle("Cancelled", for: .normal)
           cell.startRideButton.setTitleColor(UIColor.red, for: .normal)
           cell.startRideButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
           cell.startRideButton.backgroundColor = UIColor.clear
        }
        else
        if data[indexPath.row].status == "2"
        {
            cell.startRideButton.setTitle("Running", for: .normal)
            cell.startRideButton.setTitleColor(UIColor.blue, for: .normal)
            cell.startRideButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
            cell.startRideButton.backgroundColor = UIColor.clear
        }
        else
        if data[indexPath.row].status == "3"
        {
            cell.startRideButton.setTitle("Completed", for: .normal)
            cell.startRideButton.setTitleColor(UIColor.green, for: .normal)
            cell.startRideButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
            cell.startRideButton.backgroundColor = UIColor.clear
        }
        cell.lblID.text = data[indexPath.row].formattedId
        cell.lblPickupTime.text = data[indexPath.row].time
        cell.lblPassengerName.text = data[indexPath.row].pName
        cell.lblPhoneNo.text = data[indexPath.row].pPhone
        cell.lblEmail.text = data[indexPath.row].pEmail
        cell.lblFrom.text = data[indexPath.row].pickLocation
        cell.lblTo.text = data[indexPath.row].dropLocation
        cell.lblPrice.text = "$" + data[indexPath.row].price
        return cell
    }
}

