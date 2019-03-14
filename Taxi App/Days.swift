//
//  Days.swift
//  PrestoRideDriver
//
//  Created by User on 30/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import UIKit

class Days: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    var allData = [[String : String]]()
    
    override func viewDidDisappear(_ animated: Bool) {
//        self.Spinner(Task: 2, tag: 98715)
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        getData()
    }
    
    func getData()
    {
//        self.Spinner(Task: 1, tag: 98715)
        
        let parameters =
            [
                "id"     : Global.driverCurrentId,
                "action" : "all"
           ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/revenue/day".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = JSON(data : response.data!)
                    
                    if json["result"].int == 1
                    {
                        self.allData = []
                        
                        if json["data"].array?.isEmpty == false
                        {
                            for i in json["data"].array!
                            {
                                self.allData.append(
                                    [
                                        "day"  : String(describing : i["day"]),
                                        "price" : String(describing : i["price"])
                                    ])
                            }
                            
                            self.tableView.reloadData()
                        }
                        else
                        {
                            self.AlertpopUp(title: "Error", message: "You don't have earnings yet")
                        }
                    }
                    
//                    self.Spinner(Task: 2, tag: 98715)
                }
                
            case .failure(_):
                print("Error in getting All Days")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30))
        
        headerView.backgroundColor = UIColor.white
        
        let label = UILabel()
        
        label.font          = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        label.textAlignment = NSTextAlignment.center
        label.textColor     = UIColor.black
        label.text          = "Day"
        
        headerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addConstraint(NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: headerView, attribute: .left, multiplier: 1.0, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: headerView, attribute: .width, multiplier: 0.5, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: headerView, attribute: .height, multiplier: 0.8, constant: 0))
        
        
        let label1 = UILabel()
        
        label1.font          = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        label1.textAlignment = NSTextAlignment.center
        label1.textColor     = UIColor.black
        label1.text          = "Amount"
        
        headerView.addSubview(label1)
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addConstraint(NSLayoutConstraint(item: label1, attribute: .right, relatedBy: .equal, toItem: headerView, attribute: .right, multiplier: 1.0, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: label1, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: label1, attribute: .width, relatedBy: .equal, toItem: headerView, attribute: .width, multiplier: 0.5, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: label1, attribute: .height, relatedBy: .equal, toItem: headerView, attribute: .height, multiplier: 0.8, constant: 0))
        
        
        let views = UIView()
        
        views.backgroundColor   = UIColor.black
        
        headerView.addSubview(views)
        
        views.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addConstraint(NSLayoutConstraint(item: views, attribute: .centerX, relatedBy: .equal, toItem: headerView, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: views, attribute: .bottom, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: views, attribute: .width, relatedBy: .equal, toItem: headerView, attribute: .width, multiplier: 1.0, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: views, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 2))
        
        
        let views2 = UIView()
        
        views2.backgroundColor   = UIColor.black
        
        headerView.addSubview(views2)
        
        views2.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addConstraint(NSLayoutConstraint(item: views2, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: views2, attribute: .centerX, relatedBy: .equal, toItem: headerView, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: views2, attribute: .height, relatedBy: .equal, toItem: headerView, attribute: .height, multiplier: 1.0, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: views2, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 2))
        
        
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return allData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "daysCell", for: indexPath) as! daysCell
        
        cell.textAll[0].text = allData[indexPath.row]["day"]!
        
        let price = String(describing: Double(allData[indexPath.row]["price"]!)!.roundTo(places: 2))
        
        cell.textAll[1].text = "$" + " " + price
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        earningData.date = " "
        
        earningData.date = self.allData[indexPath.row]["day"]!
        
        if earningData.date != " "
        {
            self.openViewControllerBasedOnIdentifier("SortedOrderList")
        }
    }
    
}