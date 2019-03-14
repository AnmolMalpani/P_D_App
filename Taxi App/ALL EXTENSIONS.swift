import UIKit

fileprivate let v = UIView(frame: UIScreen.main.bounds)

fileprivate var alertPopUp = UIAlertController()

extension UIViewController
{
    
    func AlertpopUp(title: String, message : String)
    {
        alertPopUp = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        self.present(alertPopUp, animated: true, completion: nil)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(1.5), target: self, selector: #selector(AlertpopUpDismiss(_:)), userInfo: nil, repeats: false)
    }
    
    func AlertpopUpDismiss(_ sender : UIButton)
    {
        alertPopUp.dismiss(animated: true, completion: nil)
    }
    
    func convertDateFormat(dateString : String) -> String
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        
        var finalDate = " "
        
        if dateObj != nil
        {
            finalDate = dateFormatter.string(from: dateObj!)
        }
        
        return finalDate
    }
    
    func presentAlertWithTitle(title: String, message : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
        func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func bounds(yourView : UIView , integer : CGFloat)
    {
        yourView.layer.cornerRadius  = integer
        yourView.layer.masksToBounds = true
    }
    
    func addShadow(yourView : UIView)
    {
        yourView.layer.shadowOpacity = 1.0
        yourView.layer.shadowOffset = CGSize(width: 10, height: 10)
    }
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: testStr)
    }
    
    // MARK: Deligates funtions :-
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(UIViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
    
    // Universal Activity indicator :-
    
//    func Spinner(Task : Int , tag : Int)
//    {
//        if Task == 1
//        {
//            FTProgressIndicator.dismiss()
//            
//            FTProgressIndicator.showProgressWithmessage("Please wait...!!!", userInteractionEnable: false)
//            
//        }
//        else if Task == 2
//        {
//            FTProgressIndicator.dismiss()
//            
//        }
//    }
    
    // Reachebility Task :-
    
    func networkStatusChanged(_ notification: Notification)
    {
        let _ = (notification as NSNotification).userInfo
    }
    
    func AddToFirstVC()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
    }
    
    func netcheckker() -> Int
    {
        var task = 0
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            
            let alertController = UIAlertController(title: "Check your connection", message: "You don't seem to have an active internet connection.Please check your connection and try again", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        case .online(.wwan):
            
            task = 1
            
        case .online(.wiFi):
            
            task = 2
                      }
        return task
    }
    
    func showServerError(hanlder : @escaping(Bool)->())
    {
        let alertController = UIAlertController(title: "Error" , message: "Having trouble in getting data.", preferredStyle: .alert)
        let Cancel = UIAlertAction(title: "Cancel", style: .default)
        {
            (action: UIAlertAction) in
            
            hanlder(false)
        }
        
        let TryAgain =  UIAlertAction(title: "Try Again", style: .default)
        {
            (action: UIAlertAction) in
            
            hanlder(true)
        }
        
        alertController.addAction(TryAgain)
        alertController.addAction(Cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createFakeBackground(create : Bool)
    {
        if create == true
        {
            let blur : UIView = UIView()
            blur.backgroundColor = UIColor.clear
            blur.tag = 745
            blur.frame = self.view.bounds
            
            self.view.addSubview(blur)
        }
        else
        {
            if let myVc : UIView = self.view.viewWithTag(745)
            {
                myVc.removeFromSuperview()
            }
        }
    }
    
    func userInteraction(_ enable : Bool)
    {
        if !enable
        {
            self.view.addSubview(v)
        }
        else
        {
            v.removeFromSuperview()
        }
    }
}

extension Double
{
    func roundTo(places:Int) -> Double
    {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UITextView
{
    func centerVertically()
    {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
