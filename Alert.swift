
//  Alert.swift
//  PrestoRideDriver
//  Created by User on 07/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.

import Foundation
import UIKit
import AVFoundation
import AudioToolbox

class roundLabelPickUpAlert: UILabel
{
    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 60
    }
}
    extension BaseViewController
    {
    func alertDidLoad()
    {
        mapTask.timerForGettingResponse.invalidate()
        mapTask.timerForGettingResponse = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(gettingResponse), userInfo: nil, repeats: true)
        mapTask.responseStopper = 0
    }
    
    func gettingResponse()
    {
        ///ANK
        requestManual("\(Global.DomainName)/booking/getrequest/driver/\(Global.driverCurrentId)/\(mapTask.driverCurrentLocation.position.latitude)/\(mapTask.driverCurrentLocation.position.longitude)", method: .get).responseJSON{ response in
            
            switch response.result
            {
            case .success(let value):
                if mapTask.responseStopper == 0
                {
                    let json = JSON(value)    
                    
                    if json["result"].int == 1
                    {
                         LocalNotification.dispatchlocalNotification(with: "Presto Driver", body: "Yoy have a ride request", at: Date().addingTimeInterval(5))
                      
                        scheduleNotifications()
                        registerForRichNotifications()
//                        self.playSound()
                        mapTask.timerForGettingResponse.invalidate()
                        mapTask.responseStopper = 5
                        
                        if let dataArray = json["data"].array?[0]
                        {
                            mapTask.pickUpAddress = String(describing: dataArray["pick_location"])
                            mapTask.dropAddress = String(describing: dataArray["drop_location"])
                            mapTask.distance      = String(describing : dataArray["distance"])
                            mapTask.idForGetSend  = String(describing : dataArray["id"])
                            mapTask.passengerID   = String(describing : dataArray["passenger_id"])
                            mapTask.formattedID   = String(describing : dataArray["formated_id"] )
                            
                            //MARK: Adjust After new req
                            
                            self.labelPassengerPopUp.text = dataArray["passengers"].string ?? "1"
                            self.labelLaguage.text = dataArray["luggage"].string ?? "0"
                            self.textfare.text = "$" + String(describing : dataArray["approximate_price"])
                           
                            //END
                           if String(describing : dataArray["booking_type"]) == "instant booking"
                            {
                                self.dropAddress.isHidden = true
                                self.textdropAddress.isHidden = true
                                self.fare.isHidden          = true
                                self.textfare.isHidden   = true
                                
                                self.dropAddress.text = nil
                                self.textdropAddress.text = nil
                                self.fare.text = nil
                                self.textfare.text = nil
                                
                                self.Labeltitle.text = "Distance to Pickup"
                                self.labelDistance.text = "\(mapTask.distance) Miles"
                                mapTask.isInstantBooking = true
                            }
                            else
                            {
                                self.dropAddress.isHidden = false
                                self.fare.isHidden = false
                                self.textdropAddress.isHidden    = false
                                self.textfare.isHidden = false
                            
                                mapTask.isInstantBooking = false
                                self.Labeltitle.text = "Pickup Time"
                                self.labelDistance.text = "\(mapTask.distance)"
                            }
                            self.ifResponseGett()
                        }
                    }
                }
            case .failure(_):
                print("Error in getting request for driver")
            }
        }
    }
        
        // audioPlayer Method...
        
        func playSound() {
            var player: AVAudioPlayer?
            guard let url = Bundle.main.url(forResource: "carina (1).mp3", withExtension: "mp3") else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
            
                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3)
                
                /* iOS 10 and earlier require the following line:
                 player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
                
                guard let player = player else { return }
                
                player.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }

        func ifResponseGett()
        {
            mapTask.intForHandleTimer = 30
            textPickUpAddress.text = mapTask.pickUpAddress
            textdropAddress.text = mapTask.dropAddress
            textPickUpAddress.textAlignment = .center
            textPickUpAddress.textColor = UIColor.white
            textdropAddress.textAlignment = .center
            textdropAddress.textColor = UIColor.white
            
            viewPickUpAlert.isHidden = false
            mapTask.timerForHandleLabelInt.invalidate()
            mapTask.timerForHandleLabelInt = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ShowPopUp), userInfo: nil, repeats: true)
        }
    
    func ShowPopUp()
    {
        labelTimer.text = String(mapTask.intForHandleTimer)
        if labelTimer.text != "0"
        {
            mapTask.intForHandleTimer = mapTask.intForHandleTimer - 1
        }
        else
        {
            mapTask.timerForHandleLabelInt.invalidate()
            viewPickUpAlert.isHidden = true
            mapTask.statusForUpload = "1"
            self.updateStatusToServer()
        }
    }
    
    // After Alert Working :-
    
    func funcButtonAccept()
    {
        mapTask.timerForHandleLabelInt.invalidate()
        viewPickUpAlert.isHidden = true
        mapTask.statusForUpload = "2"
        updateStatusToServer()
    }
    
    func updateStatusToServer()
    {
        mapTask.responseStopper = 0
        
        let parameters =
            [
                "id": mapTask.idForGetSend,
                "status" : mapTask.statusForUpload
            ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/booking/editrequest".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = JSON(data : response.data!)
                    
                    if json["result"].int == 1
                    {
                        if mapTask.statusForUpload == "1"
                        {
                            endTripWorking.DEINIT()
                            afterAcceptedTask.DEINIT()
                            mapTask.DEINIT()
                            self.alertDidLoad()
                        }
                        else
                            if mapTask.statusForUpload == "2"
                            {
                             if mapTask.isInstantBooking == true
                            {
//                                    self.Spinner(Task: 1, tag: 78544)
                                    self.getUserData()
                            }
                            else
                            {
                                    print("This is a prebooking")
                                    endTripWorking.DEINIT()
                                    afterAcceptedTask.DEINIT()
                                    mapTask.DEINIT()
                                    self.alertDidLoad()
                            }
                            }
                            }
                      else
                      {
                        endTripWorking.DEINIT()
                        afterAcceptedTask.DEINIT()
                        mapTask.DEINIT()
                        self.alertDidLoad()
                      }
                      }
             case .failure(_):
            print("Error in updating data")
      }
        }
    }   
    
}

