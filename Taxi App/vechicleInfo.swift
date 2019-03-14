//
//  vechicleInfo.swift
//  PrestoRideDriver
//  Created by User on 19/10/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.

import Foundation
import UIKit

class vechileUpdate: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate
{
 
// MARK: Default funtions :-
    
    override func viewDidLoad()
    {
        getData()
//        self.Spinner(Task: 1, tag: 98586)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
    }
    
// END.
    
    var tagss = 0
    
    let picker = UIImagePickerController()
    
    @IBOutlet var textFIeldVehileInfo: [UITextField]!

    @IBOutlet var imageViewVehicleImages: [UIImageView]!
    
    func getData()
    {
        DispatchQueue.global(qos: .background).async {
            () -> Void in
        
        let parameters =
            [
                "driver_id" : Global.driverCurrentId
            ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, to:"\(Global.DomainName)/driver/vehicleDetail".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = JSON(data : response.data!)
                    
                    if json["result"].int == 1
                    {
                        DispatchQueue.main.async {
                        
//                        self.Spinner(Task: 2, tag: 98586)
                        
                        self.textFIeldVehileInfo[0].text = String(describing : json["data"]["type"])
                            
                            self.textFIeldVehileInfo[0].isUserInteractionEnabled = false
                            
                        self.textFIeldVehileInfo[1].text = String(describing : json["data"]["vehicle_make"])
                            
                             self.textFIeldVehileInfo[1].isUserInteractionEnabled = false
                            
                        self.textFIeldVehileInfo[2].text = String(describing : json["data"]["model"])
                            
                             self.textFIeldVehileInfo[2].isUserInteractionEnabled = false
                            
                        self.textFIeldVehileInfo[3].text = String(describing : json["data"]["color"])
                            
                             self.textFIeldVehileInfo[3].isUserInteractionEnabled = false
                            
                        self.textFIeldVehileInfo[4].text = String(describing : json["data"]["manufacture_year"])
                            
                             self.textFIeldVehileInfo[4].isUserInteractionEnabled = false
                            
                        self.textFIeldVehileInfo[5].text = String(describing : json["data"]["plate_number"])
                            
                             self.textFIeldVehileInfo[5].isUserInteractionEnabled = false
                        
                        self.imageViewVehicleImages[0].kf.indicatorType = .activity
                        self.imageViewVehicleImages[1].kf.indicatorType = .activity
                        self.imageViewVehicleImages[2].kf.indicatorType = .activity
                        self.imageViewVehicleImages[3].kf.indicatorType = .activity
                        self.imageViewVehicleImages[4].kf.indicatorType = .activity

                            self.imageViewVehicleImages[0].kf.setImage(with: URL(string : String(describing : json["data"]["image"])), completionHandler: {
                                (image, error, cacheType, imageUrl) in
                                
                                if image == nil
                                {
                                    self.imageViewVehicleImages[0].image = #imageLiteral(resourceName: "user")
                                }
                            
                        self.imageViewVehicleImages[1].kf.setImage(with: URL(string : String(describing : json["data"]["permit"])), completionHandler: {
                            (image, error, cacheType, imageUrl) in
                            
                            if image == nil
                            {
                                self.imageViewVehicleImages[1].image = #imageLiteral(resourceName: "user")
                            }
                            
                            self.imageViewVehicleImages[2].kf.setImage(with: URL(string : String(describing : json["data"]["registration"])), completionHandler: {
                                (image, error, cacheType, imageUrl) in
                                
                                if image == nil
                                {
                                    self.imageViewVehicleImages[2].image = #imageLiteral(resourceName: "user")
                                }
                                
                                self.imageViewVehicleImages[3].kf.setImage(with: URL(string : String(describing : json["data"]["insurance"])), completionHandler: {
                                    (image, error, cacheType, imageUrl) in
                                    
                                    if image == nil
                                    {
                                        self.imageViewVehicleImages[3].image = #imageLiteral(resourceName: "user")
                                    }
                                    
                                    self.imageViewVehicleImages[4].kf.setImage(with: URL(string : String(describing : json["data"]["license_image"])), completionHandler: {
                                        (image, error, cacheType, imageUrl) in
                                        
                                        if image == nil
                                        {
                                            self.imageViewVehicleImages[4].image = #imageLiteral(resourceName: "user")
                                        }
                                    })
                                })
                            })
                        })
                    })
                      }
                    }
                    else
                    {
//                        self.Spinner(Task: 2, tag: 98586)
                    }
                }
                
            case .failure(_):
                print("Error in Getting personal info")
//                self.Spinner(Task: 2, tag: 98586)
                
            }
            }
        }
    }
    
    
    
    
    @IBAction func buttonChangeImages(_ sender: AnyObject)
    {
        switch sender.tag {
        case 310:
            tagss = 0
        case 311:
            tagss = 1
        case 312:
            tagss = 2
        case 313:
            tagss = 3
        case 314:
            tagss = 4
        default:
            break
        }
        
        loadFromLibrary()
    }
   
    @IBAction func buttonMain(_ sender: AnyObject)
    {
        for i in imageViewVehicleImages
        {
            if i.image == nil
            {
                return
            }
        }
        
        progressBar(task : 1)
        
        let parameters =
            [
                "driver_id" :         Global.driverCurrentId,
                "type" :              textFIeldVehileInfo[0].text!,
                "vehicle_make" :      textFIeldVehileInfo[1].text! ,
                "model" :             textFIeldVehileInfo[2].text!,
                "color" :             textFIeldVehileInfo[3].text!,
                "manufacture_year" :  textFIeldVehileInfo[4].text!,
                "plate_number" :      textFIeldVehileInfo[5].text!,
 
            ]
        
        upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(self.imageViewVehicleImages[0].image!.jpegData(compressionQuality: 0.1)! , withName: "vehicle_img", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
           multipartFormData.append(self.imageViewVehicleImages[1].image!.jpegData(compressionQuality: 0.1)! , withName: "permit", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
            multipartFormData.append(self.imageViewVehicleImages[2].image!.jpegData(compressionQuality: 0.1)! , withName: "registration", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
            multipartFormData.append(self.imageViewVehicleImages[3].image!.jpegData(compressionQuality: 0.1)! , withName: "insurance", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
            multipartFormData.append(self.imageViewVehicleImages[4].image!.jpegData(compressionQuality: 0.1)! , withName: "license_image", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
            }, to:"\(Global.DomainName)/driver/updateVehicleDetail")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                    if let check = self.view.viewWithTag(12159) as? UIProgressView
                    {
                        check.progress = Float(progress.fractionCompleted)
                    }
                })
                
                upload.responseJSON
                    {
                        response in
                        
                        let json = JSON(response.result.value)
                        
                        
                        if json["result"].int == 1
                        {
                          self.progressBar(task : 2)
                          self.presentAlertWithTitle(title: "Success", message: "Updated Successfully")
                        }
                        else
                        {
                          self.progressBar(task : 2)
                          self.presentAlertWithTitle(title: "Error", message: "Not Updated")
                        }
                }
                
            case .failure(_):
                print("error in vehicle editing")
            }
        }
    }
    
    @IBOutlet weak var mainButton: UIButton!
    
}

// MARK: ImagePicking issue :-

extension vechileUpdate
{
    func loadFromLibrary()
    {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        var chosenImage = UIImage()
        chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        imageViewVehicleImages[tagss].image = chosenImage
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {dismiss(animated: true, completion: nil)
    }
}

extension vechileUpdate
{
    func progressBar(task : Int)
    {
        if task == 1
        {
            let views = UIView()
            views.bounds.size = view.bounds.size
            views.center = view.center
            views.tag = 12158
            views.backgroundColor = UIColor.black
            views.alpha = 0.7
            
            let progrogesBar = UIProgressView()
            progrogesBar.progressViewStyle = .default
            progrogesBar.trackTintColor = UIColor.white
            progrogesBar.tag = 12159
            progrogesBar.bounds.size.width = view.bounds.size.width
            progrogesBar.center = self.view.center
            view.addSubview(views)
            views.addSubview(progrogesBar)
            
            let label = UILabel(frame: CGRect(x: Int(view.bounds.width/2), y: Int(view.bounds.size.height/2), width: Int(view.bounds.size.width), height: 20))
            
            label.tag = 12160
            label.bounds.size.width = view.bounds.size.width
            label.text = " Uploading..."
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.center = CGPoint(x: view.bounds.size.width/2, y: UIScreen.main.bounds.maxY * 0.3)
            views.addSubview(label)
            
        }
        else
        {
            if let check = self.view.viewWithTag(12159) as? UIProgressView
            {
                check.removeFromSuperview()
            }
            if let check = self.view.viewWithTag(12158)
            {
                check.removeFromSuperview()
            }
            if let check = self.view.viewWithTag(12160) as? UILabel
            {
                check.removeFromSuperview()
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
