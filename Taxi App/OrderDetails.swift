//
//  OrderDetails.swift
//  PrestoRideDriver
//
//  Created by User on 01/11/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import UIKit




class OrderDetails: UITableViewController {

    var allData = [String]()
    var staticData = ["Order Number","Passenger Name","Passenger Email","Driver Name","Driver Email","Pickup Address","Dropoff Address","Pickup Time","Dropoff Time","Status","Final Fare"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Order Details"
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension

        self.getData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        self.Spinner(Task: 2, tag: 98711)
        
    }
    
    func getData()
    {
//        self.Spinner(Task: 1, tag: 98711)
        
        let parameters =
            [
                "order_id"          : earningData.bookingId,
            ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/revenue/order_info".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
//                    self.Spinner(Task: 2, tag: 98711)
                    
                    let json = JSON(data : response.data!)
                    
                    if json["result"].int == 1
                    {
                        self.allData = []
                        
                        let dataArray = json["data"].array!
                        
                        if dataArray.isEmpty == false
                        {
                                var status = "NotDefine"
                                
                                if String(describing : dataArray[0]["status"]) == "0"
                                {
                                    status = "Pending"
                                }
                                else
                                if String(describing : dataArray[0]["status"]) == "1"
                                {
                                    status = "Cancelled"
                                }
                                else
                                if String(describing : dataArray[0]["status"]) == "2"
                                {
                                    status = "Running"
                                }
                                else
                                if String(describing : dataArray[0]["status"]) == "3"
                                {
                                    status = "Completed"
                                }
                             
                            self.allData.append(String(describing : dataArray[0]["formated_id"]))
                            self.allData.append(String(describing : dataArray[0]["pfnm"]) +  " " + String(describing : dataArray[0]["plnm"]))
                            self.allData.append(String(describing : dataArray[0]["email"]))
                            self.allData.append(String(describing : dataArray[0]["dfnm"]) + " " + String(describing : dataArray[0]["dlnm"]))
                            self.allData.append(String(describing : dataArray[0]["deid"]))
                            self.allData.append(String(describing : dataArray[0]["pick_location"]))
                            self.allData.append(String(describing : dataArray[0]["drop_location"]))
                            self.allData.append(String(describing : dataArray[0]["pickup_time"]))
                            self.allData.append(String(describing : dataArray[0]["drop_time"]))
                            self.allData.append(status)
                            
                            let price = String(describing: Double(dataArray[0]["price"].string!)!.roundTo(places: 2))
                            
                            self.allData.append("$ " + price)                                                        
                            
                            self.tableView.reloadData()
                        }
                    }
                }
                
            case .failure(_):
                print("Error in getting Order Details")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsCell", for: indexPath) as! OrderDetailsCell

        cell.textSortedOrderListAll[0].text = staticData[indexPath.row]
        
        cell.textSortedOrderListAll[1].text = allData[indexPath.row]

        return cell
    }

}
