//
//  Profile.swift
//  Taxi App
//
//  Created by User on 10/12/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit

class Profile: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

// MARK: Defaults Funtions :-
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        extensionDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
// END.
 
    
    
// Extension Working :-
    
    func extensionDidLoad()
    {
     self.profileDidLoad()
    }
    
    
    // Personal info :-
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var imageviewUserProfile: roundImageProfile!
    
    @IBOutlet var textFieldPersonalInfo: [UITextField]!
    
    @IBAction func cameraButton(_ sender: AnyObject)
    {
        loadFromLibrary()
    }
    
    @IBOutlet weak var buttonUpdate: UIButton!
    
    @IBAction func buttonUpdate(_ sender: AnyObject)
    {
        self.buttonUpdateFunc()
    }
  
    @IBAction func buttonVehicleUpdate(_ sender: AnyObject)
    {
        self.openViewControllerBasedOnIdentifier("vehicleUpdate")
    }
    
}
