
import Foundation
import UIKit


struct RewardsData
{
    var month : String
    var year  : String
    var trip  : String
    var total : Int
}

class Rewards : UIViewController , UITableViewDelegate , UITableViewDataSource
{
    var RewardsArray = [RewardsData]()
    var TotalTrips   = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad()
    {
        self.navigationItem.title = "Rewards"
        GettingAllData()
    }
    
    func GettingAllData()
    {
       // self.Spinner(Task: 1, tag: 98717)
        
        let parameters =
            [
                "driver_id": Global.driverCurrentId
        ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/driver/rewards".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = JSON(data : response.data!)
                    
                    if json["result"].int == 1
                    {
                        if json["data"].array?.isEmpty == false
                        {
                            self.RewardsArray = []
                            self.TotalTrips   = 0
                            
                            var tmp = self.RewardsArray
                            
                            for i in json["data"].array!.reversed()
                            {
                                //------------------------
                                // MARK :- Calulate Total
                                //------------------------
                                
                                self.TotalTrips = self.TotalTrips + Int(String(describing : i["trip"]))!
                                
                                tmp.append(
                                    RewardsData(month : String(describing : i["month"]),
                                                year : String(describing : i["year"]),
                                                trip : String(describing : i["trip"]),
                                                total  : self.TotalTrips
                                    )
                                )
                            }
                            
                            self.RewardsArray = tmp.reversed()
                            
                          //  self.Spinner(Task: 2, tag: 98717)
                            self.tableView.reloadData()
                        }
                    }
                    else
                    {
                      //  self.Spinner(Task: 2, tag: 98717)
                    }
                }
                
            case .failure(_):
                print("Error in Getting Rewards")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RewardsArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRewards") as! RewardsCell
        
        if indexPath.row == 0
        {
            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.alignment = .left
            
            let titleFont = UIFont.boldSystemFont(ofSize: 15)
            let title = NSMutableAttributedString(string: "Month",
                                                  attributes: [NSFontAttributeName:titleFont,
                                                               NSForegroundColorAttributeName:UIColor.black,
                                                               NSParagraphStyleAttributeName: titleParagraphStyle])
            
            cell.textAllRewards[0].attributedText = title
            
            let titleParagraphStyle1 = NSMutableParagraphStyle()
            titleParagraphStyle1.alignment = .center
            
            let title1 = NSMutableAttributedString(string: "Trips",
                                                   attributes: [NSFontAttributeName:titleFont,
                                                                NSForegroundColorAttributeName:UIColor.black,
                                                                NSParagraphStyleAttributeName: titleParagraphStyle1])
            
            cell.textAllRewards[1].attributedText = title1
            
            let titleParagraphStyle2 = NSMutableParagraphStyle()
            titleParagraphStyle2.alignment = .center
            
            let title2 = NSMutableAttributedString(string: "Total",
                                                   attributes: [NSFontAttributeName:titleFont,
                                                                NSForegroundColorAttributeName:UIColor.black,
                                                                NSParagraphStyleAttributeName: titleParagraphStyle2])
            
            cell.textAllRewards[2].attributedText = title2
            
            let vc = UIView()
            vc.backgroundColor = UIColor.darkGray
            vc.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(vc)
            
            cell.addConstraint(NSLayoutConstraint(item: vc, attribute: .right, relatedBy: .equal, toItem: cell.textAllRewards[1], attribute: .left, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: vc, attribute: .centerY, relatedBy: .equal, toItem: cell.textAllRewards[1], attribute: .centerY, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: vc, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 1))
            cell.addConstraint(NSLayoutConstraint(item: vc, attribute: .height, relatedBy: .equal, toItem: cell, attribute: .height, multiplier: 1.0, constant: 0))
            
            let vc1 = UIView()
            vc1.backgroundColor = UIColor.darkGray
            vc1.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(vc1)
            
            cell.addConstraint(NSLayoutConstraint(item: vc1, attribute: .right, relatedBy: .equal, toItem: cell.textAllRewards[2], attribute: .left, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: vc1, attribute: .centerY, relatedBy: .equal, toItem: cell.textAllRewards[2], attribute: .centerY, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: vc1, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 1))
            cell.addConstraint(NSLayoutConstraint(item: vc1, attribute: .height, relatedBy: .equal, toItem: cell, attribute: .height, multiplier: 1.0, constant: 0))
            
            let vc2 = UIView()
            vc2.backgroundColor = UIColor.darkGray
            vc2.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(vc2)
            
            cell.addConstraint(NSLayoutConstraint(item: vc2, attribute: .bottom, relatedBy: .equal, toItem: cell, attribute: .bottom, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: vc2, attribute: .centerX, relatedBy: .equal, toItem: cell, attribute: .centerX, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: vc2, attribute: .width, relatedBy: .equal, toItem: cell, attribute: .width, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: vc2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 1))
        }
        else
        {
            cell.textAllRewards[0].text = RewardsArray[indexPath.row - 1].month + " " + RewardsArray[indexPath.row - 1].year
            cell.textAllRewards[1].text = RewardsArray[indexPath.row - 1].trip
            cell.textAllRewards[2].text = String(RewardsArray[indexPath.row - 1].total)
            
            let vc = UIView()
            vc.backgroundColor = UIColor.lightGray
            vc.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(vc)
            
            cell.addConstraint(NSLayoutConstraint(item: vc, attribute: .right, relatedBy: .equal, toItem: cell.textAllRewards[1], attribute: .left, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: vc, attribute: .centerY, relatedBy: .equal, toItem: cell.textAllRewards[1], attribute: .centerY, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: vc, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 1))
            cell.addConstraint(NSLayoutConstraint(item: vc, attribute: .height, relatedBy: .equal, toItem: cell, attribute: .height, multiplier: 1.0, constant: 0))
            
            
            let vc1 = UIView()
            vc1.backgroundColor = UIColor.lightGray
            vc1.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(vc1)
            
            cell.addConstraint(NSLayoutConstraint(item: vc1, attribute: .right, relatedBy: .equal, toItem: cell.textAllRewards[2], attribute: .left, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: vc1, attribute: .centerY, relatedBy: .equal, toItem: cell.textAllRewards[2], attribute: .centerY, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: vc1, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 1))
            cell.addConstraint(NSLayoutConstraint(item: vc1, attribute: .height, relatedBy: .equal, toItem: cell, attribute: .height, multiplier: 1.0, constant: 0))
            
            let vc2 = UIView()
            vc2.backgroundColor = UIColor.darkGray
            vc2.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(vc2)
            
            cell.addConstraint(NSLayoutConstraint(item: vc2, attribute: .bottom, relatedBy: .equal, toItem: cell, attribute: .bottom, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: vc2, attribute: .centerX, relatedBy: .equal, toItem: cell, attribute: .centerX, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: vc2, attribute: .width, relatedBy: .equal, toItem: cell, attribute: .width, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: vc2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 1))
        }
        
        return cell
    }
}

class RewardsCell: UITableViewCell
{
    @IBOutlet var textAllRewards: [UITextView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }
}
