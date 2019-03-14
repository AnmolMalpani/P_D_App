//
//  Message.swift
//  PrestoRideDriver
//
//  Created by User on 29/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import UIKit


class Message: UIViewController
{
    
var  dropDownMenu = DropDown()
var  optionMasseges =
    [
      "I'll be late for Pickup",
      "Stuck in traffic",
      "My car has broken down",
      "I'm done for the day",
      "I can't process payment"
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationButton()
    }
    
    func navigationButton()
    {
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(#imageLiteral(resourceName: "send"), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        btnShowMenu.addTarget(self, action: #selector(sendMessage), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.rightBarButtonItem = customBarItem;
    }
    
    func sendMessage()
    {
        if textMessageSent.text == "" || textMessageSent.text == " "
        {
         self.presentAlertWithTitle(title: "Error", message: "Please enter a message")   
        }
        else
        {
            SendMessages.sendMessage(message: textMessageSent.text!) { (a) in
                
                if let status = a
                {
                    if status == 5
                    {
                        self.presentAlertWithTitle(title: "Success", message: "Your message has been sent successfully")
                        self.textMessageSent.text = ""
                    }
                    else
                    {
                        self.presentAlertWithTitle(title: "Error", message: "Try again Later")
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var textMessageSent: UITextField!
    
    @IBAction func buttonSent(_ sender: AnyObject)
    {
        messagesWorking.isForInbox = false
        self.openViewControllerBasedOnIdentifier("Message")
    }

    @IBAction func buttonInbox(_ sender: AnyObject)
    {
        messagesWorking.isForInbox = true
        self.openViewControllerBasedOnIdentifier("Message")
    }
    
    @IBAction func DropDownButton(_ sender: AnyObject)
    {
        DropDownFunction(dropdownName: dropDownMenu, outlet: textMessageSent, array: optionMasseges)
    }
}


// MARK DropDown 

extension Message
{
    func DropDownFunction(dropdownName : DropDown , outlet : UITextField , array : [String] )
    {
        dropdownName.backgroundColor = UIColor.white
        dropdownName.anchorView = outlet
        dropdownName.bottomOffset = CGPoint(x: 0, y: outlet.bounds.height)
        dropdownName.dataSource = array
        dropdownName.reloadAllComponents()
        dropdownName.show()
        
        dropdownName.selectionAction =
            {
                [] (index: Int, item: String) in
                
               outlet.text = item
            }
    }
}
