//
//  Ratings.swift
//  PrestoRideDriver
//
//  Created by User on 30/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import UIKit

class Ratings: UITableViewController {
    
    //-------------------------------//
    //      MARK: All Variables      //
    //-------------------------------//
    
    var allData         = [[String : String]]()
    var sumOfAllRatings = 0.0
    var average         = Double()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = "Ratings & Reviews"
        
//        self.Spinner(Task: 1, tag: 98703)
        
        allData = []
        getData()
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func getData()
    {
        let parameters =
            [
                "driver_id" : Global.driverCurrentId
        ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to:"\(Global.DomainName)/driver/get_review")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON
                    {
                        response in
                        
                        let json = JSON(data : response.data!)
                        
                        if String(describing : json["result"]) == "1"
                        {
                            if json["data"].array?.isEmpty == false
                            {
                                self.sumOfAllRatings = 0.0
                                
                                for i in json["data"].array!
                                {
                                    self.allData.append(
                                        [
                                            "date" :  String(describing : i["created"]) ,
                                            "pid" : String(describing : i["pid"]),
                                            "review" : String(describing : i["review"]),
                                            "rating" : String(describing : i["rating"])
                                        ])
                                    
                                    if String(describing : i["rating"]) != ""
                                    {
                                        self.sumOfAllRatings = self.sumOfAllRatings + Double(String(describing : i["rating"]))!
                                    }
                                    
                                }
                                self.calculateAverage()
                                self.tableView.reloadData()
                            }
                            else
                            {
                                self.AlertpopUp(title: "Error", message: "You don't have ratings yet")
                            }
                        }
                        
//                        self.Spinner(Task: 2, tag: 98703)
                }
                
            case .failure(_):
                print("error in getting Review")
            }
        }
    }
    
    func calculateAverage()
    {
        self.average = self.sumOfAllRatings / Double(allData.count)
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingsCell", for: indexPath) as! RatingsCell
        
        
        cell.textViewAll[0].text = allData[indexPath.row]["rating"]!
        cell.textViewAll[1].text = allData[indexPath.row]["date"]!
        cell.textViewAll[2].text = allData[indexPath.row]["pid"]!
        cell.textViewAll[3].text = allData[indexPath.row]["review"]!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        
        headerView.backgroundColor = UIColor.white
        
        let label = UILabel()
        
        label.font          = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        label.textAlignment = NSTextAlignment.center
        label.textColor     = UIColor.white
        label.backgroundColor = UIColor.darkGray
        label.text          = "Average : " + String(self.average.roundTo(places: 2))
        
        headerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addConstraint(NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: headerView, attribute: .left, multiplier: 1.0, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: headerView, attribute: .width, multiplier: 1.0, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: headerView, attribute: .height, multiplier: 0.8, constant: 0))
        
        
        return headerView
    }
}
