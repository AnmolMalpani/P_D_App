
//  AppDelegate.swift
//  Taxi App
//  Created by User on 08/12/16.
//  Copyright © 2016 User. All rights reserved.

import UIKit
import CoreData
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import UserNotifications
import CoreLocation
import IQKeyboardManagerSwift

var locationManager:CLLocationManager?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        locationManager=CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        URLCache.shared = {
            URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        }()
        
        URLCache.shared.removeAllCachedResponses()
        
        // MARK: Google Maps
        
        GMSPlacesClient.provideAPIKey(Global.googleMapApiKey)
        GMSServices.provideAPIKey(Global.googleMapApiKey)
        
        ReachabilityManager.shared.startMonitoring()
        
        IQKeyboardManager.shared.enable = true
        //MARK: Disable Sleep Mode
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        // MARK: Local Notification.
        
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
    }
    func applicationDidEnterBackground(_ application: UIApplication)
    {
    }
    func applicationWillEnterForeground(_ application: UIApplication)
    {
    }
    func applicationDidBecomeActive(_ application: UIApplication)
    {
    }
    func applicationWillTerminate(_ application: UIApplication)
    {
        let parameters =
            [
                "status": "0",
                "driver_id" : Global.driverCurrentId
        ]
        upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:"\(Global.DomainName)/driver/driverbreak".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                }
            case .failure(_):
                print("Error in login")
            }
        }
        
        sleep(15)
    }
}

//mark - local notification   CLOSE

class LocalNotification: NSObject, UNUserNotificationCenterDelegate {
    
    class func registerForLocalNotification(on application:UIApplication) {
        if (UIApplication.instancesRespond(to: #selector(UIApplication.registerUserNotificationSettings(_:)))) {
            let notificationCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
            notificationCategory.identifier = "NOTIFICATION_CATEGORY"
            
            //registerting for the notification.
            application.registerUserNotificationSettings(UIUserNotificationSettings(types:[.sound, .alert, .badge], categories: nil))
        }
    }
    class func dispatchlocalNotification(with title: String, body: String, userInfo: [AnyHashable: Any]? = nil, at date:Date) {
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.categoryIdentifier = "Fechou"
            content.sound = UNNotificationSound(named:convertToUNNotificationSoundName("carina.mp3"))
            let comp    = Calendar.current.dateComponents([.hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
        else
        {
            let notification = UILocalNotification()
            notification.fireDate = date
            notification.alertTitle = title
            notification.alertBody = body
            
            if let info = userInfo {
                notification.userInfo = info
            }
            
            notification.soundName = "carina.mp3"
            UIApplication.shared.scheduleLocalNotification(notification)
        }
        print("WILL DISPATCH LOCAL NOTIFICATION AT ", date)
    }
}

extension Date {
    func addedBy(seconds:Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self)!
    }
}

//mark - notification AS NEW

extension ViewController: UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert, .badge, .sound])
    }
    
    // For handling tap and user actions
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler()
    }
}

@available(iOS 10.0, *)
func scheduleNotifications() {
    
    let content = UNMutableNotificationContent()
    let requestIdentifier = "rajanNotification"
    
    content.badge = 1
    content.title = "Presto Driver"
    content.subtitle = "You have a ride request"
    //    content.body = "Hello body"
    content.categoryIdentifier = "actionCategory"
    content.sound = UNNotificationSound(named: convertToUNNotificationSoundName("carin.mp3"))
    
    // If you want to attach any image to show in local notification
    
    let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.1, repeats: false)
    
    let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request) { (error:Error?) in
        
        if error != nil {
            print(error?.localizedDescription)
        }
        print("Notification Register Success")
    }
}

func registerForRichNotifications() {
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted:Bool, error:Error?) in
        if error != nil {
            print(error?.localizedDescription)
        }
        if granted {
            print("Permission granted")
        } else {
            print("Permission not granted")
        }
    }
    
    //actions defination
    let action1 = UNNotificationAction(identifier: "action1", title: "Action First", options: [.foreground])
    let action2 = UNNotificationAction(identifier: "action2", title: "Action Second", options: [.foreground])
    
    let category = UNNotificationCategory(identifier: "actionCategory", actions: [action1,action2], intentIdentifiers: [], options: [])
    
    UNUserNotificationCenter.current().setNotificationCategories([category])
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUNNotificationSoundName(_ input: String) -> UNNotificationSoundName {
    return UNNotificationSoundName(rawValue: input)
}
