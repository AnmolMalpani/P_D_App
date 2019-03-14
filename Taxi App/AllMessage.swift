//
//  AllMessage.swift
//  PrestoRideDriver
//
//  Created by User on 29/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import UIKit



class AllMessage: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.Spinner(Task: 1, tag: 98704)
        
        messagesWorking.messageData = []
        
        if !messagesWorking.isForInbox
        {
            self.navigationItem.title = "Sent"
        }
        else
        {
            self.navigationItem.title = "Inbox"
        }
        
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        getData()
    }
    
    func getData()
    {
        
        let parameters =
            [
                "driver_id"   : Global.driverCurrentId
            ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/driver/get_drivermessage".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = JSON(data : response.data!)
                    
                    messagesWorking.messageData = []
                    
                    if json["result"].int == 1
                    {
                        if json["data"].array?.isEmpty == false
                        {
                            for i in json["data"].array!
                            {
                                if messagesWorking.isForInbox == true
                                {
                                    if String(describing : i["send_by"]) == "admin"
                                    {
                                        messagesWorking.messageData.append(
                                            [
                                                "created_date" : String(describing : i["created"]),
                                                "message"      : String(describing : i["message"])
                                            ])
                                    }
                                }
                                else
                                {
                                    if String(describing : i["send_by"]) == "driver"
                                    {
                                        messagesWorking.messageData.append(
                                            [
                                                "created_date" : String(describing : i["created"]),
                                                "message"      : String(describing : i["message"])
                                            ])
                                    }
                                }
                            }
//                            self.Spinner(Task: 2, tag: 98704)
                            self.tableView.reloadData()
                        }
                        else
                        {
//                            self.Spinner(Task: 2, tag: 98704)
                            self.presentAlertWithTitle(title: "Error", message: "You dont have message yet")
                        }
                    }
                    
                    if messagesWorking.messageData.isEmpty
                    {
//                        self.Spinner(Task: 2, tag: 98704)
                        
                        self.AlertpopUp(title: "Note:", message: "You don't have any message yet.")
                    }
                    
                }
            case .failure(_):
                print("Error in Getting Messages")
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
        return messagesWorking.messageData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! messageCell
        
        cell.textViewaAll[0].text = "Date: \(messagesWorking.messageData[indexPath.row]["created_date"]!)"
        cell.textViewaAll[1].text = messagesWorking.messageData[indexPath.row]["message"]!
        
        
        return cell
    }
 
}
