//
//  uiManagement.swift
//  PrestoRideDriver
//
//  Created by User on 06/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import Foundation
import UIKit

class roundLabel: UILabel
{
    override func awakeFromNib()
    {
       self.layer.cornerRadius =  15
       self.layer.masksToBounds = true
    }
}
