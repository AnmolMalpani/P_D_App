//
//  Recent Order.swift
//  Taxi App
//
//  Created by User on 10/12/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit

struct bookingValue
{
    var formattedId : String
    var time : String
    var pName : String
    var pEmail : String
    var Phone : String
    var pickLocation : String
    var dropLocation : String
    var price : String
    var status : String
    var bookingId : String
    var pickLat : String
    var pickLong : String
    var dropLat : String
    var dropLong : String
}

class Recent_Order: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableviewOutlet: UITableView!
    
    var data = [bookingValue]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = "Recent Orders"

        tableviewOutlet.estimatedRowHeight = 50
        tableviewOutlet.rowHeight          = UITableView.automaticDimension
        
        getData()
    }

    func getData()
    {
//        self.Spinner(Task: 1, tag: 98712)
        
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
                            if String(describing : i["type"]) == "instant booking"
                            {
                                var time = String(describing : i["pickup_time"])
                                
                                if time.replacingOccurrences(of: " ", with: "") == ""
                                {
                                    time = "Not Updated Yet"
                                }
                                
                                self.data.append(
                                    
                                bookingValue(
                                    
                                formattedId: String(describing : i["formated_id"]),
                                time: time,
                                pName: String(describing : i["first_name"]) + " " + String(describing : i["last_name"]),
                                pEmail: String(describing : i["email"]),
                                Phone: String(describing : i["phone"]),
                                pickLocation: String(describing : i["pick_location"]),
                                dropLocation: String(describing : i["drop_location"]),
                                price: String(describing : i["approximate_price"]),
                                status : String(describing: i["status"]),
                                bookingId: String(describing: i["id"]),
                                pickLat: String(describing: i["pick_latitude"]),
                                pickLong: String(describing: i["pick_longitude"]),
                                dropLat: String(describing: i["drop_latitude"]),
                                dropLong: String(describing: i["drop_langitude"])
                                
                                            )
                                                )
                            }
                        }
                        
//                        self.Spinner(Task: 2, tag: 98712)
                        self.tableviewOutlet.reloadData()
                        
                    }
                }
                else
                    if json["result"].int == 0
                    {
                        self.presentAlertWithTitle(title: "Error", message: "You Don't Have Any Order Yet")
//                        self.Spinner(Task: 2, tag: 98712)
                     }
                
                break
            case .failure(_):
                print("Error in getting Bookings details")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "cellRecentOrder", for: indexPath) as! RecentOrderCell
        
        
        if data[indexPath.row].status == "0" {
            cell.startRideButton.setTitle("Start Ride", for: .normal)
            cell.startRideButton.setTitleColor(UIColor.white, for: .normal)
            cell.startRideButton.backgroundColor = UIColor.init(red: 20/255, green:79/255, blue:84/255, alpha:1.0)
            cell.startRideButton.titleLabel?.font = UIFont.systemFont(ofSize: 10,weight: UIFont.Weight.semibold)
            cell.startRideButton.tag = indexPath.row
            cell.startRideButton.addTarget(self, action: #selector(RideNowClicked(_:)), for: .touchUpInside)
        }
        else if data[indexPath.row].status == "1"
        {
           cell.startRideButton.setTitle("Cancelled", for: .normal)
            cell.startRideButton.setTitleColor(UIColor.red, for: .normal)
            cell.startRideButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.semibold)
            cell.startRideButton.backgroundColor = UIColor.clear
        }
        else if data[indexPath.row].status == "2"
        {
            cell.startRideButton.setTitle("Running", for: .normal)
            cell.startRideButton.setTitleColor(UIColor.blue, for: .normal)
            cell.startRideButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.semibold)
            cell.startRideButton.backgroundColor = UIColor.clear
        }
        else if data[indexPath.row].status == "3"
        {
            cell.startRideButton.setTitle("Completed", for: .normal)
            cell.startRideButton.setTitleColor(UIColor.green, for: .normal)
            cell.startRideButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.semibold)
            cell.startRideButton.backgroundColor = UIColor.clear
        }
        
        cell.lblId.text = data[indexPath.row].formattedId
        cell.lblPickUpTime.text = data[indexPath.row].time
        cell.lblPassengerName.text = data[indexPath.row].pName
        cell.lblPhoneNum.text = data[indexPath.row].Phone
        cell.lblEmail.text = data[indexPath.row].pEmail
        cell.lblFrom.text = data[indexPath.row].pickLocation
        cell.lblTo.text = data[indexPath.row].dropLocation
        cell.lblPrice.text = "$" + data[indexPath.row].price
//        cell.lblStatus.text = data[indexPath.row].status
        
       return cell
     }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 5
    }
}

extension NSMutableAttributedString {

func bold(_ text:String) -> NSMutableAttributedString {
    
    let attrs:[String:AnyObject] = [convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont(name: "AvenirNext-Medium",   size: 15)!]
    
    let boldString = NSMutableAttributedString(string:"\(text)", attributes:convertToOptionalNSAttributedStringKeyDictionary(attrs))
    self.append(boldString)
    
    return self
    }
    
func normal(_ text:String)->NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        self.append(normal)
        return self
    }  
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
