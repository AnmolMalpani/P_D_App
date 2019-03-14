//
//  RecentOrderCell.swift
//  Taxi App
//
//  Created by User on 10/12/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit

class RecentOrderCell: UITableViewCell {

    @IBOutlet weak var lblId : UILabel!
    
    @IBOutlet weak var lblPickUpTime : UILabel!
    
    @IBOutlet weak var lblPassengerName : UILabel!
    
    @IBOutlet weak var lblPhoneNum : UILabel!
    
    @IBOutlet weak var lblEmail : UILabel!
    
    @IBOutlet weak var lblFrom : UILabel!
    
    @IBOutlet weak var lblTo : UILabel!
    
    @IBOutlet weak var lblStatus : UILabel!
    
    @IBOutlet weak var lblPrice  : UILabel!
    
     @IBOutlet var startRideButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
