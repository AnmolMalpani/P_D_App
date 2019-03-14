//
//  PreBookingCell.swift
//  PrestoRideDriver
//
//  Created by User on 04/11/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import UIKit

class PreBookingCell: UITableViewCell {

    @IBOutlet weak var lblID : UILabel!
    
    @IBOutlet weak var lblPickupTime : UILabel!
    
    @IBOutlet weak var lblPassengerName : UILabel!
    
    @IBOutlet weak var lblPhoneNo : UILabel!
    
    @IBOutlet weak var lblEmail : UILabel!
    
    @IBOutlet weak var lblFrom : UILabel!
    
    @IBOutlet weak var lblTo : UILabel!
    
    @IBOutlet weak var lblPrice : UILabel!
    
    @IBOutlet var startRideButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
