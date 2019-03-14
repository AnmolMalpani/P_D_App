

import GoogleMaps
                                    // MARK: AfterAccepted.
struct afterAcceptedTask
{
    static var timer = Timer()
    static var timer2 = Timer()
    static var customerPickLatlongName = [String : String]()
    static var bookingId =  String()
    static var passengerPickLocaion = GMSMarker()
    static var passengerDropLocaion = GMSMarker()
    static var passengerPickUpTime = String()
    static var phone = String()
    static var pPhone = String()
    
          // MARK: ND
    
    static var isBeforeRideComplete = Bool()
    
    static func DEINIT()
    {
        timer.invalidate()
        timer2.invalidate()
        customerPickLatlongName = [:]
        bookingId = ""
        passengerPickUpTime = ""
    }
}
                // MARK: MapTask :-

struct mapTask
{
    static var driverCurrentLocation = GMSMarker()
    
    // MARK: PickUpAlertWorking -
    
    static var formattedID   = String()  // Getting by request And used to get data.
    static var isInstantBooking  = Bool() //
    
    static var pickUpAddress = String()
    // CollectingData
    static var dropAddress = String()
    static var distance      = String()                   // CollectingData
    static var passengerID   = String()                   // CollectingData
    static var idForGetSend = String()                   // CollectingData
    
    static var timerForGettingResponse = Timer()          // Getting Reponse Working
    static var responseStopper          = Int()            // Getting Reponse Working
    
    static var timerForHandleLabelInt = Timer()           // PopUpTimerWorking
    static var intForHandleTimer = Int()                  // PopUpTimerWorking
    
    static var statusForUpload   = String()               // SendingRequestWorking
    
    static func DEINIT()
    {
        pickUpAddress  = ""
        dropAddress    = ""
        distance       = ""
        passengerID    = ""
        idForGetSend   = ""
        timerForGettingResponse.invalidate()
        responseStopper          = 0
        timerForHandleLabelInt.invalidate()
        intForHandleTimer = 0
        statusForUpload   = ""
        
        // MARK:- Driver Current Location Cordinates :-
    }
}

struct endTripWorking
{
    static var tripTime               =  Timer()
    static var minutes                =  Int()
    static var hour                   =  Int()
    static var getEstimateByBooking   =  String()
    
    static func DEINIT()
    {
        tripTime.invalidate()
        minutes      = 0
        hour         = 0
    }
}

// MARK: Messages :-

struct messagesWorking
{
    static var isForInbox    = Bool()
    static var timerMessages = Timer()
    static var messageData   = [[String : String]]()
}

// MARK: PreBooking Working :-

struct PreBookingTask
{
  static var isForPrebooking       = false         // For Ride From Orders.
  static var formattedIdNeedToSend = ""       // For Ride From Orders.
  static var bookingIdNeedToSend   = ""       // For Ride From Orders.
  static var phone = ""               // MARK: ND
  static var pPhone = ""
  static var passengerPickUpLocation = GMSMarker()  // MARK: ND
  static var passengerDropOffLocation = GMSMarker() // MARK: ND
  static var latLongAll            = [String : String]()
    
  static func DEINIT()
  {
    isForPrebooking       = false
    formattedIdNeedToSend = ""
    latLongAll            = [:]
    pPhone                = ""
  }
}
// Mark : InstantBooking Working :-

struct InstantBookingTask
{
    static var isForInstantBooking  = false
    static var formattedIdNeedToSend = ""
    static var bookingIdNeedToSend = ""
    static var phone = ""
    static var passengerPickUpLocation = GMSMarker()
    static var passengerDropOffLocation = GMSMarker()
    static var latLongAll = [String : String]()
    static func DEINIT()
    {
        isForInstantBooking = false
        formattedIdNeedToSend = ""
        latLongAll = [:]
        phone = ""
    }
}
