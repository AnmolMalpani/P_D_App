////  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//
import UIKit
import MapKit
import GoogleMaps
import CoreLocation
import AVFoundation
import AudioToolbox

class BaseViewController: UIViewController, SlideMenuDelegate
{
    func slideMenuItemSelectedAtIndex(_ index: Int32)
    {
        let _ : UIViewController = self.navigationController!.topViewController!
        switch(index){
        case 0:
            self.openViewControllerBasedOnIdentifier("Profile")
            break
        case 1:
            let alertController = UIAlertController(title: "Please Select", message: "", preferredStyle: .alert)
            let InstantBooking = UIAlertAction(title: "Instant Booking", style: .default){
                (action: UIAlertAction) in
                self.openViewControllerBasedOnIdentifier("Recent Orders")
            }
            let PreBooking = UIAlertAction(title: "Pre-Booking", style: .default){
                (action: UIAlertAction) in
                self.openViewControllerBasedOnIdentifier("Pre-Orders")
            }
            alertController.addAction(InstantBooking)
            alertController.addAction(PreBooking)
            self.present(alertController, animated: true, completion: nil)
            break
        case 2:
            self.openViewControllerBasedOnIdentifier("Earnings")
            break
        case 3:
            self.openViewControllerBasedOnIdentifier("Messages")
            break
        case 4:
            self.openViewControllerBasedOnIdentifier("Ratings")
            break
        case 5:
            self.openViewControllerBasedOnIdentifier("Refer Driver")
            break
        case 6:
            self.openViewControllerBasedOnIdentifier("Rewards")
            break
        case 7:
            self.openViewControllerBasedOnIdentifier("Contact Us")
            break
        case 8:
            self.logoutWorking()
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func logoutWorking()
    {
        // self.Spinner(Task: 1, tag: 98720)
        
        let parameters =
            [
                "driver_id": Global.driverCurrentId
        ]
        
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
               to:"\(Global.DomainName)/driver/logout".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        {   (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = JSON(data : response.data!)
                    
                    print("This is logout result \(json)")
                    func resetLocationFromUserDefault() {
                        let userD = UserDefaults.standard
                        userD.set(nil, forKey: "latitude")
                        userD.set(nil, forKey: "longitude")
                        userD.synchronize()
                    }
                    if json["result"].int == 1
                    {
                        resetLocationFromUserDefault()
                        updateLatLong.timer.invalidate()
                        CheckPreBooking.preBookingTimer.invalidate()
                        updateLatLong.DEINT()
                        mapTask.DEINIT()
                        self.stopUpdatingLocation()
                        
                        offlineLogin.shared.deleteUserInfo()
                        
                        _ = self.navigationController?.popToRootViewController(animated: true)
                        
                        //self.openViewControllerBasedOnIdentifier("Login")
                    }
                    
                    //   self.Spinner(Task: 2, tag: 98720)
                }
                
            case .failure(_):
                // self.Spinner(Task: 2, tag: 98720)
                self.showServerError(hanlder:
                    { (a) in
                        if a == true
                        {
                            self.logoutWorking()
                        }
                })
            }
        }
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControl.State())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 22, height: 22), false, 0.0)
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 22, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 22, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 22, height: 1)).fill()
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 22, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 22, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 22, height: 1)).fill()
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return defaultMenuImage;
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            return
        }
        sender.isEnabled = false
        sender.tag = 10
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        //  menuVC.view.layoutIfNeeded()
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
    }
    
    // MARK: Main Working Started :-
    
    
    // Only Show Driver In This Panel :-
    
    func stopUpdatingLocation()
    {
        locationManager.stopUpdatingLocation()
    }
    
    @IBOutlet var googleMap: GMSMapView!
    var Phone = String ()
    
    let locationManager = CLLocationManager()
    
    // MARK:-  Defaults Funtions :-
    override func viewDidLoad(){
        super.viewDidLoad()
        findMyLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        hitMethod()
    }
    
    @objc func hitMethod() {
        if PreBookingTask.isForPrebooking == true {
            afterAcceptedTask.passengerPickLocaion.position = CLLocationCoordinate2D(
                latitude: Double(PreBookingTask.latLongAll["pickLat"]!)! ,
                longitude: Double(PreBookingTask.latLongAll["pickLong"]! )!
            )
            afterAcceptedTask.passengerPickLocaion.title = "Passenger pickUp Location"
            afterAcceptedTask.passengerPickLocaion.map = self.googleMap
            
            afterAcceptedTask.passengerDropLocaion.position = CLLocationCoordinate2D(
                latitude: Double(PreBookingTask.latLongAll["dropLat"]!)! ,
                longitude: Double(PreBookingTask.latLongAll["dropLong"]!)!
            )
            afterAcceptedTask.passengerDropLocaion.title = "Passenger Drop Location"
            afterAcceptedTask.passengerDropLocaion.map = self.googleMap
            
            self.Phone = PreBookingTask.phone
            
            self.call()
            self.createUIforCalling()
            self.CreatePreBookingPolyline()
        } else if InstantBookingTask.isForInstantBooking == true {
            afterAcceptedTask.passengerPickLocaion.position = CLLocationCoordinate2D(
                latitude: Double(InstantBookingTask.latLongAll["pickLat"]!)! ,
                longitude: Double(InstantBookingTask.latLongAll["pickLong"]! )!
            )
            afterAcceptedTask.passengerPickLocaion.title = "Passenger pickUp Location"
            afterAcceptedTask.passengerPickLocaion.map = self.googleMap
            
            afterAcceptedTask.passengerDropLocaion.position = CLLocationCoordinate2D(
                latitude: Double(InstantBookingTask.latLongAll["dropLat"]!)! ,
                longitude: Double(InstantBookingTask.latLongAll["dropLong"]!)!
            )
            afterAcceptedTask.passengerDropLocaion.title = "Passenger Drop Location"
            afterAcceptedTask.passengerDropLocaion.map = self.googleMap
            
            self.Phone = InstantBookingTask.phone
            self.call()
            self.createUIforCalling()
            self.CreatePreBookingPolyline1()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        self.stopUpdatingLocation()
    }
    
    func viewDidAfterCheck()
    {
        self.checkPrebookingDidLoad()
        
        // for start break and End Break.
        
        self.gettingCurrentStatus()
        
        // END.
        
        showGoogleMap()
        
        // Extensions :-
        
        extensionDiDload()
    }
    var currnetLocationMarker : GMSMarker?
    func showGoogleMap()
    {
        googleMap.settings.myLocationButton = true
        GMSMarker.markerImage(with: UIColor .black)
        
        googleMap.isMyLocationEnabled = true
    }
    
    func findMyLocation()
    {
        print("my location")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        currnetLocationMarker?.icon = UIImage(named: "marker_image")
        locationManager.startUpdatingLocation()
    }
    
    //-----------------------------------\\
    //  MARK: Main Extension Working :-  \\
    //-----------------------------------\\
    
    func extensionDiDload()
    {
        alertDidLoad()
        forClassAdjustmentDriverLatLongUpdate()
    }
    
    var player: AVAudioPlayer?
    var playerr: AVPlayer?
    
    // MARK: Alert Working :-
    
    @IBOutlet weak var Labeltitle: UILabel!
    
    @IBOutlet weak var viewPickUpAlert: UIView!
    
    @IBOutlet weak var labelTimer: UILabel!
    
    @IBOutlet weak var textPickUpAddress: UILabel!
    
    @IBOutlet weak var textfare: UILabel!
    
    @IBOutlet weak var fare: UILabel!
    
    @IBOutlet weak var dropAddress: UILabel!
    
    @IBOutlet weak var textdropAddress: UILabel!
    
    @IBOutlet weak var labelDistance: UILabel!
    
    @IBOutlet weak var labelPassengerPopUp: UILabel!
    
    @IBOutlet weak var labelLaguage: UILabel!
    
    @IBAction func buttonAccept(_ sender: AnyObject) {
        self.funcButtonAccept()
        guard let _ = player else { return }
        if (player?.isPlaying)! {
            player?.stop()
        }
    }
    
    @IBAction func buttonReject(_ sender: AnyObject) {
        mapTask.timerForHandleLabelInt.invalidate()
        viewPickUpAlert.isHidden = true
        mapTask.statusForUpload = "1"
        self.updateStatusToServer()
        guard let _ = player else { return }
        if (player?.isPlaying)! {
            player?.stop()
        }
    }
    
    // BreakTask :-
    
    @IBOutlet weak var buttonStartBreakOutlet: UIButton!
    var statusStartEndBreak = String()
    
    @IBAction func buttonStartBreak(_ sender: AnyObject)
    {
        if buttonStartBreakOutlet.titleLabel?.text == "START BREAK"
        {
            statusStartEndBreak = "0"
            print("welcome sheenu")
            self.startBreak()
        }
        else
            if buttonStartBreakOutlet.titleLabel?.text == "END BREAK"
            {
                statusStartEndBreak = "1"
                self.startBreak()
        }
    }
}

extension BaseViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.last
        {
            /**
             Animate user to current location
             */
            
            func saveLocationToUserDefault() {
                let userD = UserDefaults.standard
                userD.set(location.coordinate.latitude, forKey: "latitude")
                userD.set(location.coordinate.longitude, forKey: "longitude")
                userD.synchronize()
            }
            
            func animateToCurrentLocation() {
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude ,longitude: location.coordinate.longitude , zoom: 16)
                
                self.googleMap.animate(to: camera)
                saveLocationToUserDefault()
                mapTask.driverCurrentLocation.position = location.coordinate
                mapTask.driverCurrentLocation.appearAnimation = GMSMarkerAnimation.none
                
                mapTask.driverCurrentLocation.title = "Current Location"
                mapTask.driverCurrentLocation.icon = UIImage(named: "marker_image")
                mapTask.driverCurrentLocation.map = googleMap
                ///aaaaaa
            }
            if mapTask.driverCurrentLocation.position.latitude != location.coordinate.latitude || mapTask.driverCurrentLocation.position.longitude != location.coordinate.longitude
            {
                animateToCurrentLocation()
            }
            
            // MARK: Current Place Name :-
            
            let geoCoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                var Name = String()
                var Street = String()
                var City = String()
                
                if placeMark != nil
                {
                    // Location name
                    if let locationName = placeMark.addressDictionary!["Name"] as? String
                    {
                        Name = locationName
                    }
                    
                    // Street address
                    if let street = placeMark.addressDictionary!["Thoroughfare"] as? String
                    {
                        Street = street
                    }
                    
                    // City
                    if let city = placeMark.addressDictionary!["City"] as? String
                    {
                        City = city
                    }
                    
                    if Name == Street
                    {
                        mapTask.driverCurrentLocation.snippet = "Near By :- \(Name) \(City)"
                    }
                    else
                    {
                        mapTask.driverCurrentLocation.snippet = "Near By :- \(Name) \(Street) ,\(City)"
                    }
                }
            })
        }
    }
    
    @objc(locationManager:didChangeAuthorizationStatus:) func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            
            askForAuthentication()
            
        case .denied:
            
            askForAuthentication()
            
        case .notDetermined:
            
            print("determining")
            
        case .authorizedAlways:
            
            locationManager.startUpdatingLocation()
            
            self.viewDidAfterCheck()
            
        case .authorizedWhenInUse:
            
            locationManager.startUpdatingLocation()
            currnetLocationMarker?.icon = UIImage(named: "marker_image")
            
            self.viewDidAfterCheck()
        }
    }
}

extension BaseViewController
{
    func askForAuthentication()
    {
        let alertController = UIAlertController(title: "Error", message: "Please goto settings then select PrestoRide & Enable Location", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in
            
            exit(0)
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
