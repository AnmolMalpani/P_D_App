//
//  ContactUs.swift
//  Taxi App
//
//  Created by User on 10/12/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit
import MessageUI

class ContactUs: UIViewController , MFMailComposeViewControllerDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Contact Us"
    }

    @IBAction func buttonCallUs(_ sender: AnyObject)
    {
        if let url : URL = URL(string : "tel://5103733022")
        {
            UIApplication.shared.openURL(url)
            print("Calling")
        }
    }
    
       // Mail WOrking :-

    @IBAction func buttonContactUs(_ sender: AnyObject)
    {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["support@prestoride.com"])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert()
    {
        self.presentAlertWithTitle(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method.
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
