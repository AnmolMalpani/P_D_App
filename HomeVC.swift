//
//  HomeVC.swift
//  AKSwiftSlideMenu
//
//  Created by MAC-186 on 4/8/16.
//  Copyright © 2016 Kode. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class HomeVC: BaseViewController {
    
    var fromEndRide: Bool = false
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        

        locationManager .requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        addSlideMenuButton()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if fromEndRide {
            animateToCurrentLocation()
        }
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(super.hitMethod), name: NSNotification.Name("RAMBAAN"), object: nil)
    }
  
    override func viewDidAppear(_ animated: Bool) {
        
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateToCurrentLocation() {
        guard let lat: Double = UserDefaults.standard.value(forKey: "latitude") as? Double else {
            return
        }
        guard let long: Double = UserDefaults.standard.value(forKey: "longitude") as? Double else {
            return
        }
        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: long , zoom: 16)
        self.googleMap.animate(to: camera)
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: long))
        marker.appearAnimation = GMSMarkerAnimation.none
        marker.title = "Current Location"
        marker.icon = UIImage(named: "marker_image")
        marker.map = googleMap
    }
}
