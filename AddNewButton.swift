//
//  AddNewButton&RemoveOld.swift
//  PrestoRideDriver
//
//  Created by User on 27/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import Foundation
import UIKit

extension  BaseViewController
{
    func addNewButton()
    {
        if let v1 : UIButton = self.view.viewWithTag(98600) as? UIButton
        {
            v1.removeFromSuperview()
        }
        
        if let v2 : UIButton = self.view.viewWithTag(98601) as? UIButton
        {
            v2.removeFromSuperview()
        }                
        
        let ui = UIButton()

        ui.addTarget(self, action: #selector(EndTripButtonWorking(sender:)), for: .touchUpInside)
        
        ui.tag = 98700
        ui.backgroundColor = UIColor.blue
        ui.setTitle("END TRIP", for: .normal)
        ui.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)
        
        self.view.addSubview(ui)
        
        ui.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: ui, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: ui, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50))
        
        view.addConstraint(NSLayoutConstraint(item: ui, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: ui, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0))
    }
    
    
    func EndTripButtonWorking(sender : UIButton)
    {
        if let EndTripButton = view.viewWithTag(98700)
        {
            EndTripButton.removeFromSuperview()
        }
        
        self.openViewControllerBasedOnIdentifier("endTrip")
        
        self.addNavigationButton(false)
    }
    
    
}
