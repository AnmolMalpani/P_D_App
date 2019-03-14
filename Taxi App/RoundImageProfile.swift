//
//  RoundImageProfile.swift
//  PrestoRideDriver
//
//  Created by User on 19/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import Foundation
import UIKit

class roundImageProfile: UIImageView
{
    override func awakeFromNib()
    {
     self.layer.cornerRadius = 70
     self.layer.masksToBounds = true
    }
}
