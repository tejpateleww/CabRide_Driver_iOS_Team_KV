//
//  ContentViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 11/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SideMenuController
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import CoreLocation
import SocketIO
import SRCountdownTimer
import NVActivityIndicatorView
import MarqueeLabel

//-------------------------------------------------------------
// MARK: - Protocol
//-------------------------------------------------------------

@objc protocol ReceiveRequestDelegate {
    func didAcceptedRequest()
    func didRejectedRequest()
}

protocol CompleterTripInfoDelegate {
    func didRatingCompleted()
}

// ------------------------------------------------------------

class HomeViewController: ParentViewController, CLLocationManagerDelegate,ARCarMovementDelegate, SRCountdownTimerDelegate, ReceiveRequestDelegate,GMSMapViewDelegate,CompleterTripInfoDelegate,UITabBarControllerDelegate
{
    
    
    //-------------------------------------------------------------
    // MARK: - Global Decelaration
    //-------------------------------------------------------------
    
    var window: UIWindow?
    
    
    var moveMent: ARCarMovement!
    
    
    let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    var oldCoordinate: CLLocationCoordinate2D!
    var placesClient: GMSPlacesClient!
    let manager = CLLocationManager()
    var mapView : GMSMapView!
    var originMarker = GMSMarker()
    var zoomLevel: Float = 15
    var defaultLocation = CLLocation()
    var aryPassengerData = NSArray()
    var bookingID = String()
    var advanceBookingID = String()
    var driverID = String()
    
    var selectedRoute: Dictionary<String, AnyObject>!
    var overviewPolyline: Dictionary<String, AnyObject>!
    
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    
    var sumOfFinalDistance = Double()
    var dictCompleteTripData = NSDictionary()
    
    weak var delegateOfRequest: ReceiveRequestDelegate!
    
    var strPickupLocation = String()
    var strDropoffLocation = String()
    var strPassengerName = String()
    var strPassengerMobileNo = String()
    
    var aryBookingData = NSArray()
    
    var driverMarker: GMSMarker!
    var isAdvanceBooking = Bool()
    
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet weak var btnCurrentlocation: UIButton!
    
    @IBOutlet weak var BottomButtonView: UIView!
    @IBOutlet var lblLocationOnMap: MarqueeLabel!
    @IBOutlet var subMapView: UIView!
    @IBOutlet var viewLocationDetails: UIView!
    @IBOutlet weak var StartTripView: UIView!
    

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        btnCurrentlocation.layer.cornerRadius = 5
        btnCurrentlocation.layer.masksToBounds = true
        
        BottomButtonView.isHidden = true
        StartTripView.isHidden = true
        
        isAdvanceBooking = false
        Singletons.sharedInstance.isFirstTimeDidupdateLocation = true;
        moveMent = ARCarMovement()
        moveMent.delegate = self
        
        
        setCar()
        UtilityClass.showACProgressHUD()
        
        self.tabBarController?.delegate = self
        
        let profile: NSMutableDictionary = NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as? NSDictionary)!)
        let Vehicle: NSMutableDictionary = NSMutableDictionary(dictionary: profile.object(forKey: "Vehicle") as! NSDictionary)
        
        driverID = Vehicle.object(forKey: "DriverId") as! String
        
        placesClient = GMSPlacesClient.shared()
        
        manager.delegate = self
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if (manager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) || manager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)))
            {
                if manager.location != nil
                {
                    manager.startUpdatingLocation()
                    manager.desiredAccuracy = kCLLocationAccuracyBest
                    manager.activityType = .automotiveNavigation
//                    manager.distanceFilter = //
                }
                
            }
        }
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 40), camera: camera)
        
        
        mapView.isHidden = true
        subMapView.addSubview(mapView)
        
        
        getCurrentPlace()
        
        
        if let reqAccepted: Bool = UserDefaults.standard.bool(forKey: tripStatus.kisRequestAccepted) as? Bool {
            Singletons.sharedInstance.isRequestAccepted = reqAccepted
        }
        
        if let holdingTrip: Bool = UserDefaults.standard.bool(forKey: holdTripStatus.kIsTripisHolding) as? Bool {
            Singletons.sharedInstance.isTripHolding = holdingTrip
        }
        
        if Singletons.sharedInstance.isTripHolding {
            
            btnWaiting.setTitle("Stop (Waiting)",for: .normal)
        }
        else {
            btnWaiting.setTitle("Hold (Waiting)",for: .normal)
        }
        //TODO: uncomment in production
        self.webserviceOfCurrentBooking()
        
        
        
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return false
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        print(viewController)
        if(viewController.isKind(of: PayViewController.self))
        {
            if(Singletons.sharedInstance.isPasscodeON)
            {
                if Singletons.sharedInstance.setPasscode == ""
                {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
                    viewController.modalPresentationStyle = .formSheet
                    self.present(viewController, animated: false, completion: nil)
                }
                else
                {

                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
                    self.present(viewController, animated: false, completion: nil)
                    
                }
            }
            
        }
    }
    
    // MARK:-
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // print ("\(#function) -- \(self)")
    }
    
    func presentAction() {
        present(ViewController.fromStoryboard, animated: true, completion: nil)
    }
    // ------------------------------------------------------------
    
    //MARK:- Location delegate methods
    
    var driverIDTimer : String!
    var passengerIDTimer : String!
     var timerToGetDriverLocation : Timer!
    func sendPassengerIDAndDriverIDToGetLocation(driverID : String , passengerID: String) {
        
        
        driverIDTimer = driverID
        passengerIDTimer = passengerID
        if timerToGetDriverLocation == nil {
            timerToGetDriverLocation = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(HomeViewController.getDriverLocation), userInfo: nil, repeats: true)
        }
        
        
        
    }
    
    func stopTimer() {
        if timerToGetDriverLocation != nil {
            timerToGetDriverLocation.invalidate()
            timerToGetDriverLocation = nil
        }
    }
    
    @objc func getDriverLocation()
    {
//        let myJSON = ["PassengerId" : passengerIDTimer,  "DriverId" : driverIDTimer] as [String : Any]
//        socket.emit(SocketData.kSendDriverLocationRequestByPassenger , with: [myJSON])
    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location: CLLocation = locations.last!
        
        defaultLocation = location
        
        if(Singletons.sharedInstance.isFirstTimeDidupdateLocation == true)
        {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: 17)
            mapView.camera = camera
            Singletons.sharedInstance.isFirstTimeDidupdateLocation = false
        }
        
        Singletons.sharedInstance.latitude = defaultLocation.coordinate.latitude
        Singletons.sharedInstance.longitude = defaultLocation.coordinate.longitude
        if(Singletons.sharedInstance.isRequestAccepted)
        {
            if(oldCoordinate == nil)
            {
                oldCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            }
            
            if(driverMarker == nil)
            {
                driverMarker = GMSMarker(position: oldCoordinate)
                //                driverMarker.position = oldCoordinate
                driverMarker.icon = UIImage(named: Singletons.sharedInstance.strSetCar)
                driverMarker.map = mapView
            }
            
            let newCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(Singletons.sharedInstance.latitude), CLLocationDegrees(Singletons.sharedInstance.longitude))
            self.moveMent.ARCarMovement(marker: driverMarker, oldCoordinate: oldCoordinate, newCoordinate: newCoordinate, mapView: mapView, bearing: Float(Singletons.sharedInstance.floatBearing))
            oldCoordinate = newCoordinate
        }
    
        
        if mapView.isHidden {
            mapView.isHidden = false
            
            self.socketMethods()
            
        }
        else
        {
                if(oldCoordinate == nil)
                {
                    oldCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                }
                
                
                if(driverMarker == nil)
                {
                    driverMarker = GMSMarker(position: oldCoordinate)
                    //                driverMarker.position = oldCoordinate
                    driverMarker.icon = UIImage(named: Singletons.sharedInstance.strSetCar)
                    driverMarker.map = mapView
                }
                
                let newCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(Singletons.sharedInstance.latitude), CLLocationDegrees(Singletons.sharedInstance.longitude))
                self.moveMent.ARCarMovement(marker: driverMarker, oldCoordinate: oldCoordinate, newCoordinate: newCoordinate, mapView: mapView, bearing: Float(Singletons.sharedInstance.floatBearing))
                oldCoordinate = newCoordinate
            
            if(Singletons.sharedInstance.driverDuty == "1")
            {
                self.UpdateDriverLocation()
            }
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted: break
        case .denied:
            mapView.isHidden = false
        case .notDetermined: break
        case .authorizedAlways:
            manager.startUpdatingLocation()
            
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // print (error)
    }
    
    // ------------------------------------------------------------
    
    var nameLabel = String()
    var addressLabel = String()
    
    
    func getCurrentPlace()
    {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if error != nil {
                // print ("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel = "No current place"
            self.addressLabel = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel = place.name
                    self.addressLabel = (place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n"))!
                }
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
                    
                    self.lblLocationOnMap.text = place.formattedAddress
                    
                }
            }
            
        })
        
    }
    
    // ------------------------------------------------------------
    //-------------------------------------------------------------
    // MARK: - Socket Methods
    //-------------------------------------------------------------
    
    var strTempBookingId = String()
    
    func socketMethods()
    {
        
        socket.on(clientEvent: .disconnect) { (data, ack) in
            print ("socket is disconnected please reconnect")
        }
        
        socket.on(clientEvent: .reconnect) { (data, ack) in
            print ("socket is reconnected please reconnect")
        }
        
        socket.on(clientEvent: .connect) {data, ack in
            print ("socket connected")
            
            self.methodsAfterConnectingToSocket()
            
            self.socket.on(socketApiKeys.kReceiveBookingRequest, callback: { (data, ack) in
                // print ("data is \(data)")
                print ("kReceiveBookingRequest : \(data)")
                
                if let bookingType = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingType") as? String {
                    
                    Singletons.sharedInstance.passengerType = bookingType
                    Singletons.sharedInstance.strBookingType = bookingType
                }
                
                if Singletons.sharedInstance.firstRequestIsAccepted == true {
                    
                    self.strTempBookingId = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingId") as! String
                    
                    self.BookingRejected()
                    return
                }
                
                self.isAdvanceBooking = false
                self.bookingID = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingId") as! String
                
                
                let next = self.storyboard?.instantiateViewController(withIdentifier: "ReceiveRequestViewController") as! ReceiveRequestViewController
                next.delegate = self
                
                if let grandTotal = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "GrandTotal") as? String {
                    if grandTotal == "" {
                        next.strGrandTotal = "0"
                    }
                    else {
                        next.strGrandTotal = grandTotal
                    }
                    
                }
                else {
                    next.strGrandTotal = "0"
                }
                if let PickupLocation = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "PickupLocation") as? String {
                    next.strPickupLocation = PickupLocation
                }
                
                if let DropoffLocation = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DropoffLocation") as? String {
                    next.strDropoffLocation = DropoffLocation
                }
                self.playSound(strName: "ringTone")
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: { ACTION in
                    Singletons.sharedInstance.firstRequestIsAccepted = true
                    
                })
                
            })
        }
        
        socket.connect()
    }
    
    func methodsAfterConnectingToSocket()
    {
        if defaultLocation.coordinate.latitude == 0 || defaultLocation.coordinate.longitude == 0 {
            UtilityClass.showAlert("Missing", message: "Latitude or Longitude", vc: self)
        }
        else {
            
            self.UpdateDriverLocation()
            self.ReceiveBookLaterBookingRequest()
            self.CancelBookLaterTripByCancelNotification()
            self.GetAdvanceBookingDetailsAfterBookingRequestAccepted()
            self.cancelTripByPassenger()
            self.NewBookLaterRequestArrivedNotification()
            self.getNotificationForReceiveMoneyNotify()
            self.onSessionError()
        }
        
    }
    
    
    func UpdateDriverLocation()
    {
        let myJSON = [profileKeys.kDriverId : driverID, socketApiKeys.kLat: defaultLocation.coordinate.latitude, socketApiKeys.kLong: defaultLocation.coordinate.longitude, "Token": Singletons.sharedInstance.deviceToken] as [String : Any]
        
        socket.emit(socketApiKeys.kUpdateDriverLocation, with: [myJSON])
        print ("UpdateDriverLocation : \(myJSON)")
    }
    // ------------------------------------------------------------
    
    func onSessionError() {
        
        self.socket.on("SessionError", callback: { (data, ack) in
            
            
            
            UtilityClass.showAlertWithCompletion("Multiple login", message: "Please Re-Login", vc: self, completionHandler: { ACTION in
                
                self.webserviceOFSignOut()
            })
            
        })
        
    }
    
    func NewBookLaterRequestArrivedNotification() {
        
        self.socket.on(socketApiKeys.kBookLaterDriverNotify, callback: { (data, ack) in
            
            print ("Book Later Driver Notify : \(data)")
            
            let msg = (data as NSArray)
            
//            UtilityClass.showAlert("Future Booking Request Arrived.", message: (msg.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
            
            let alert = UIAlertController(title: "Future Booking Request Arrived.",
                                          message: (msg.object(at: 0) as! NSDictionary).object(forKey: "message") as? String,
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            
            
            let okAction = UIAlertAction(title: "Open", style: .default, handler: { (action) in
                
                Singletons.sharedInstance.isFromNotification = true
                self.tabBarController?.selectedIndex = 2
            })

            
            let cancelAction = UIAlertAction(title: "Dismiss",
                                             style: .destructive, handler: nil)
            
            alert.addAction(cancelAction)
            alert.addAction(okAction)

            if(self.presentedViewController != nil)
            {
                self.dismiss(animated: true, completion: nil)
            }
            //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
            self.present(alert, animated: true, completion: nil)
            
        })
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Get Booking Details After Booking Request Accepted
    //-------------------------------------------------------------
    func GetBookingDetailsAfterBookingRequestAccepted() {
        
        self.socket.on(socketApiKeys.kGetBookingDetailsAfterBookingRequestAccepted, callback: { (data, ack) in
            
            print("GetBookingDetailsAfterBookingRequestAccepted() : \(data)")
            
            if let PassengerType = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingType") as? String {
                
                Singletons.sharedInstance.passengerType = PassengerType
            }
            
            Singletons.sharedInstance.isRequestAccepted = true
            UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
            
            DispatchQueue.main.async {
                
                self.methodAfterDidAcceptBooking(data: data as NSArray)
                
                UtilityClass.hideACProgressHUD()
                
            }
        })
    }
    
    func zoomoutCamera(PickupLat: CLLocationDegrees, PickupLng: CLLocationDegrees, DropOffLat : String, DropOffLon: String)
    {
        let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: Double(PickupLat), longitude: Double(PickupLng)), coordinate: CLLocationCoordinate2D(latitude: Double(DropOffLat)!, longitude: Double(DropOffLon)!))
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(150))
        
        self.mapView.animate(with: update)
        
        self.mapView.moveCamera(update)
        
        
    }
    func methodAfterDidAcceptBooking(data : NSArray)
    {
        
        let getBookingAndPassengerInfo = self.getBookingAndPassengerInfo(data: data)
        self.BottomButtonView.isHidden = false
        let BookingInfo = getBookingAndPassengerInfo.0
        let PassengerInfo = getBookingAndPassengerInfo.1
        
        if let paymentType = BookingInfo.object(forKey: "PaymentType") as? String {
            Singletons.sharedInstance.passengerPaymentType = paymentType
        }
        
        if let passengerType = BookingInfo.object(forKey: "PassengerType") as? String {
            Singletons.sharedInstance.passengerType = passengerType
        }
        if let pasengerFlightNumber = BookingInfo.object(forKey: "FlightNumber") as? String {
            Singletons.sharedInstance.pasengerFlightNumber = pasengerFlightNumber
        }
        if let passengerNote = BookingInfo.object(forKey: "Notes") as? String {
            Singletons.sharedInstance.passengerNote = passengerNote
        }
        
        
        let DropOffLat = BookingInfo.object(forKey: "PickupLat") as! String
        let DropOffLon = BookingInfo.object(forKey: "PickupLng") as! String
        
        self.lblLocationOnMap.text = BookingInfo.object(forKey: "PickupLocation") as? String
        self.strPickupLocation = BookingInfo.object(forKey: "PickupLocation") as! String
        self.strDropoffLocation = BookingInfo.object(forKey: "DropoffLocation") as! String
        self.strPassengerName = PassengerInfo.object(forKey: "Fullname") as! String
        
        var imgURL = String()
        
        self.strPassengerMobileNo = PassengerInfo.object(forKey: "MobileNo") as! String
        imgURL = PassengerInfo.object(forKey: "Image") as! String
        
        let PickupLat = self.defaultLocation.coordinate.latitude
        let PickupLng = self.defaultLocation.coordinate.longitude
        
        let dummyLatitude = Double(PickupLat) - Double(DropOffLat)!
        let dummyLongitude = Double(PickupLng) - Double(DropOffLon)!
        
        let waypointLatitude = self.defaultLocation.coordinate.latitude - dummyLatitude
        let waypointSetLongitude = self.defaultLocation.coordinate.longitude - dummyLongitude
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        zoomoutCamera(PickupLat: PickupLat, PickupLng: PickupLng, DropOffLat: DropOffLat, DropOffLon: DropOffLon)
        
        
        self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PassengerInfoViewController") as! PassengerInfoViewController
        next.strPickupLocation = self.strPickupLocation
        next.strDropoffLocation = self.strDropoffLocation
        next.imgURL = imgURL
        if((PassengerInfo.object(forKey: "FlightNumber")) != nil)
        {
            next.strFlightNumber = PassengerInfo.object(forKey: "FlightNumber") as! String
        }
        if((PassengerInfo.object(forKey: "Notes")) != nil)
        {
            next.strNotes = PassengerInfo.object(forKey: "Notes") as! String
        }
        next.strPassengerName =  self.strPassengerName
        next.strPassengerMobileNumber =  self.strPassengerMobileNo
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
        
        
    }
    
    
    func getBookingAndPassengerInfo(data : NSArray) -> (NSMutableDictionary,NSMutableDictionary)
    {
        self.aryBookingData = data as NSArray
        Singletons.sharedInstance.aryPassengerInfo = data as NSArray
        
        UserDefaults.standard.set(data, forKey: "BookNowInformation")
        UserDefaults.standard.synchronize()
        
        self.aryPassengerData = NSArray(array: data)
        //
        oldCoordinate = CLLocationCoordinate2DMake(Singletons.sharedInstance.latitude ,Singletons.sharedInstance.longitude)
        var BookingInfo = NSMutableDictionary()
        var PassengerInfo = NSMutableDictionary()
        
        if((((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) == nil)
        {
            // print ("Yes its  array ")
            BookingInfo = NSMutableDictionary(dictionary: (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary)
            
            let PassengerType = BookingInfo.object(forKey: "PassengerType") as? String
            
            if PassengerType == "" || PassengerType == nil{
                Singletons.sharedInstance.passengerType = ""
            }
            else {
                Singletons.sharedInstance.passengerType = PassengerType!
            }
            
            
            if Singletons.sharedInstance.passengerType == "other" || Singletons.sharedInstance.passengerType == "others" {
                
                let Fullname = BookingInfo.object(forKey: "PassengerName")
                
                let FlightNumber = BookingInfo.object(forKey: "FlightNumber")
                let PaymentType = BookingInfo.object(forKey: "PaymentType")
                let Notes = BookingInfo.object(forKey: "Notes")
                
                var MobileNo = String()
                if let mobileNumber = BookingInfo.object(forKey: "MobileNo") as? String {
                    
                    if mobileNumber == "" {
                        
                        if let contacoNo = BookingInfo.object(forKey: "PassengerContact") as? String {
                            MobileNo = contacoNo
                        }
                        else {
                            MobileNo = ""
                        }
                    }
                    else {
                        MobileNo = mobileNumber
                    }
                }
                
                var dictPassengerInfo = [String:AnyObject]()
                dictPassengerInfo["Fullname"] = Fullname as AnyObject
                dictPassengerInfo["MobileNo"] = MobileNo as AnyObject
                dictPassengerInfo["PassengerType"] = PassengerType as AnyObject
                dictPassengerInfo["FlightNumber"] = FlightNumber as AnyObject
                dictPassengerInfo["PaymentType"] = PaymentType as AnyObject
                dictPassengerInfo["Notes"] = Notes as AnyObject
                
                PassengerInfo = NSMutableDictionary(dictionary: dictPassengerInfo)
                
            }
            else {
                PassengerInfo = NSMutableDictionary(dictionary: (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "PassengerInfo") as! NSArray).object(at: 0) as! NSDictionary)
                PassengerInfo.setObject(BookingInfo.object(forKey: "Notes") ?? "", forKey: "Notes" as NSCopying)
            }
            
            
            // ----------------------------------------------------------------------
        }
        else
        {
            // print ("Yes its dictionary")
            BookingInfo = NSMutableDictionary(dictionary: (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSDictionary))  //.object(at: 0) as! NSDictionary
            
            
            let PassengerType = self.dictCurrentBookingInfoData.object(forKey: "PassengerType") as? String
            
            if PassengerType == "" || PassengerType == nil{
                Singletons.sharedInstance.passengerType = ""
            }
            else {
                Singletons.sharedInstance.passengerType = PassengerType!
            }
        
            
            if Singletons.sharedInstance.passengerType == "other" || Singletons.sharedInstance.passengerType == "others" {
                
                let Fullname = BookingInfo.object(forKey: "PassengerName")
                
                let FlightNumber = BookingInfo.object(forKey: "FlightNumber")
                let PaymentType = BookingInfo.object(forKey: "PaymentType")
                let Notes = BookingInfo.object(forKey: "Notes")
                
                var MobileNo = String()
                if let mobileNumber = BookingInfo.object(forKey: "MobileNo") as? String {
                    
                    if mobileNumber == "" {
                        
                        if let contacoNo = BookingInfo.object(forKey: "PassengerContact") as? String {
                            MobileNo = contacoNo
                        }
                        else {
                            MobileNo = ""
                        }
                    }
                    else {
                        MobileNo = mobileNumber
                    }
                }
                
                var dictPassengerInfo = [String:AnyObject]()
                dictPassengerInfo["Fullname"] = Fullname as AnyObject
                dictPassengerInfo["MobileNo"] = MobileNo as AnyObject
                dictPassengerInfo["PassengerType"] = PassengerType as AnyObject
                dictPassengerInfo["FlightNumber"] = FlightNumber as AnyObject
                dictPassengerInfo["PaymentType"] = PaymentType as AnyObject
                dictPassengerInfo["Notes"] = Notes as AnyObject
                
                PassengerInfo = NSMutableDictionary(dictionary: dictPassengerInfo)
                
            }
            else {
                PassengerInfo = NSMutableDictionary(dictionary: ((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "PassengerInfo")  as! NSDictionary)
                PassengerInfo.setObject(BookingInfo.object(forKey: "Notes") ?? "", forKey: "Notes" as NSCopying)
            }
            
        }
        return (BookingInfo,PassengerInfo)
    }
    
    
    
    
    func PickupPassengerByDriverInBookLaterRequest() {
        
        let myJSON = [socketApiKeys.kBookingId : advanceBookingID,  profileKeys.kDriverId : driverID] as [String : Any]
        socket.emit(socketApiKeys.kAdvancedBookingPickupPassenger, with: [myJSON])
    }
    
    func StartHoldTrip() {
        
        let myJSON = [socketApiKeys.kBookingId : advanceBookingID] as [String : Any]
        socket.emit(socketApiKeys.kAdvancedBookingStartHoldTrip, with: [myJSON])
    }
    
    func EndHoldTrip() {
        
        let myJSON = [socketApiKeys.kBookingId : advanceBookingID] as [String : Any]
        socket.emit(socketApiKeys.kAdvancedBookingEndHoldTrip, with: [myJSON])
    }
    
    func CompletedBookLaterTrip() {
        
        
        let BookingInfo : NSDictionary!
        if((((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) == nil)
        {
            BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        }
        else
        {
            BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
        }
        
        let strPassengerID = BookingInfo.object(forKey: "PassengerId") as! String
        
        let myJSON = ["PassengerId" : strPassengerID, socketApiKeys.kBookingId : advanceBookingID,  profileKeys.kDriverId : driverID] as [String : Any]
        socket.emit(socketApiKeys.kAdvancedBookingCompleteTrip, with: [myJSON])
    }
    
    
    
    
    func GetAdvanceBookingDetailsAfterBookingRequestAccepted() {
        
        self.socket.on(socketApiKeys.kAdvancedBookingInfo, callback: { (data, ack) in
            print ("GetAdvanceBookingDetails is :  \(data)")
            
            
            Singletons.sharedInstance.isRequestAccepted = true
            UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
            
            DispatchQueue.main.async {
                
                // print ("GetAdvanceBookingDetailsAfterBookingRequestAccepted()")
                
                self.methodAfterDidAcceptBookingLaterRequest(data: data as NSArray)
                
                UtilityClass.hideACProgressHUD()
                
            }
            
        })
        
    }
    
    func getNotificationForReceiveMoneyNotify() {
        
        self.socket.on(socketApiKeys.kReceiveMoneyNotify, callback: { (data, ack) in
            
            print("ReceiveMoneyNotify: \(data)")
            
            UtilityClass.showAlert(appName.kAPPName, message: ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
            
        })
    }
    
    func methodAfterDidAcceptBookingLaterRequest(data: NSArray)
    {
        
        
        // print ("methodAfterDidAcceptBookingLaterRequest")
        self.aryPassengerData = NSArray(array: data)
        self.BottomButtonView.isHidden = false
        
        self.aryBookingData = data as NSArray
        Singletons.sharedInstance.aryPassengerInfo = data as NSArray
        
        self.isAdvanceBooking = true
        
        let getBookingAndPassengerInfo = self.getBookingAndPassengerInfo(data: data)
        
        let BookingInfo = getBookingAndPassengerInfo.0
        let PassengerInfo = getBookingAndPassengerInfo.1
        
        if let paymentType = BookingInfo.object(forKey: "PaymentType") as? String {
            Singletons.sharedInstance.passengerPaymentType = paymentType
        }
        
        if let bookingType = BookingInfo.object(forKey: "BookingType") {
            Singletons.sharedInstance.strBookingType = bookingType as! String
        }
        
        if let passengerType = BookingInfo.object(forKey: "PassengerType") as? String {
            Singletons.sharedInstance.passengerType = passengerType
        }
        if let pasengerFlightNumber = BookingInfo.object(forKey: "FlightNumber") as? String {
            Singletons.sharedInstance.pasengerFlightNumber = pasengerFlightNumber
        }
        if let passengerNote = BookingInfo.object(forKey: "Notes") as? String {
            Singletons.sharedInstance.passengerNote = passengerNote
        }
        
        
        let DropOffLat = BookingInfo.object(forKey: "PickupLat") as! String
        let DropOffLon = BookingInfo.object(forKey: "PickupLng") as! String
        let strID = BookingInfo.object(forKey: "Id") as AnyObject
        
        self.advanceBookingID = String(describing: strID)
        
        self.lblLocationOnMap.text = BookingInfo.object(forKey: "PickupLocation") as? String
        self.strPickupLocation = BookingInfo.object(forKey: "PickupLocation") as! String
        self.strDropoffLocation = BookingInfo.object(forKey: "DropoffLocation") as! String
        
        self.mapView.clear()
        
        
        self.strPassengerName = PassengerInfo.object(forKey: "Fullname") as! String
        self.strPassengerMobileNo = PassengerInfo.object(forKey: "MobileNo") as! String
        //         imgURL = PassengerInfo.object(forKey: "Image") as! String
        let PickupLat = self.defaultLocation.coordinate.latitude
        let PickupLng = self.defaultLocation.coordinate.longitude
        
        let dummyLatitude = Double(PickupLat) - Double(DropOffLat)!
        let dummyLongitude = Double(PickupLng) - Double(DropOffLon)!
        
        let waypointLatitude = self.defaultLocation.coordinate.latitude - dummyLatitude
        let waypointSetLongitude = self.defaultLocation.coordinate.longitude - dummyLongitude
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        zoomoutCamera(PickupLat: PickupLat, PickupLng: PickupLng, DropOffLat: DropOffLat, DropOffLon: DropOffLon)
        self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PassengerInfoViewController") as! PassengerInfoViewController
        next.strPickupLocation = self.strPickupLocation
        next.strDropoffLocation = self.strDropoffLocation
        if((PassengerInfo.object(forKey: "FlightNumber")) != nil)
        {
            next.strFlightNumber = PassengerInfo.object(forKey: "FlightNumber") as! String
        }
        if((PassengerInfo.object(forKey: "Notes")) != nil)
        {
            next.strNotes = PassengerInfo.object(forKey: "Notes") as! String
        }
        next.strPassengerName =  self.strPassengerName
        next.strPassengerMobileNumber =  self.strPassengerMobileNo
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Accept and Reject Request
    //-------------------------------------------------------------
    
    
    func didAcceptedRequest() {
        
        /*
         DispatchQueue.main.async {
         let activityData = ActivityData()
         NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
         }
         */
        
        UtilityClass.showACProgressHUD()
        
        if isAdvanceBooking {
            
            self.AcceptBookLaterBookingRequest()
        }
        else {
            BookingAcceped()
        }
        
    }
    
    func didRejectedRequest() {
        self.stopSound()
        if isAdvanceBooking {
            self.RejectBookLaterBookingRequest()
        }
        else {
            BookingRejected()
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Accept Book Later Request
    //-------------------------------------------------------------
    
    func AcceptBookLaterBookingRequest() {
        
        self.resetMapView()
        //        self.mapView.selectedMarker = nil
        
        
        let myJSON = [socketApiKeys.kBookingId : advanceBookingID,  profileKeys.kDriverId : driverID, "Lat" : defaultLocation.coordinate.latitude,"Long" : defaultLocation.coordinate.longitude] as [String : Any]
        socket.emit(socketApiKeys.kAcceptAdvancedBookingRequest, with: [myJSON])
        
        GetAdvanceBookingDetailsAfterBookingRequestAccepted()
        
        
        playSound(strName: "RequestConfirm")
        
    }
    
    
    // ------------------------------------------------------------
    //-------------------------------------------------------------
    // MARK: - Receive Book Later Request
    //-------------------------------------------------------------
    func ReceiveBookLaterBookingRequest() {
        
        self.socket.on(socketApiKeys.kAriveAdvancedBookingRequest, callback: { (data, ack) in
            print ("ReceiveBookLater is \(data)")
            
            self.advanceBookingID = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingId") as! String
            self.isAdvanceBooking = true
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ReceiveRequestViewController") as! ReceiveRequestViewController
            next.delegate = self
            
            if let grandTotal = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "GrandTotal") as? String {
                if grandTotal == "" {
                    next.strGrandTotal = "0"
                }
                else {
                    next.strGrandTotal = grandTotal
                }
            }
            else {
                next.strGrandTotal = "0"
            }
            if let PickupLocation = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "PickupLocation") as? String {
                next.strPickupLocation = PickupLocation
            }
            
            if let DropoffLocation = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DropoffLocation") as? String {
                next.strDropoffLocation = DropoffLocation
            }
            
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
            
            //            self.performSegue(withIdentifier: "segueReceiveRequest", sender: nil)
        })
    }
    
    //
    
    //-------------------------------------------------------------
    // MARK: - Accept Booking Request
    //-------------------------------------------------------------
    func BookingAcceped() {
        
        self.resetMapView()
        
        
        if bookingID == "" || driverID == "" {
            UtilityClass.showAlert("Missing", message: "Booking ID or Driver ID", vc: self)
        }
        else {
            let myJSON = [socketApiKeys.kBookingId : bookingID,  profileKeys.kDriverId : driverID, "Lat" : defaultLocation.coordinate.latitude,"Long": defaultLocation.coordinate.longitude] as [String : Any]
            socket.emit(socketApiKeys.kAcceptBookingRequest, with: [myJSON])
            
            GetBookingDetailsAfterBookingRequestAccepted()
        }
    }
    
    //
    //-------------------------------------------------------------
    // MARK: - Reject Booking Request
    //-------------------------------------------------------------
    func BookingRejected() {
        if bookingID == "" || driverID == "" {
            UtilityClass.showAlert("Missing", message: "Booking ID or Driver ID", vc: self)
        }
        else {
            
            if (Singletons.sharedInstance.firstRequestIsAccepted && self.strTempBookingId.count != 0){
                let myJSON = [socketApiKeys.kBookingId : strTempBookingId,  profileKeys.kDriverId : driverID] as [String : Any]
                socket.emit(socketApiKeys.kRejectBookingRequest, with: [myJSON])
                Singletons.sharedInstance.firstRequestIsAccepted = false
                
            }
            else {
                let myJSON = [socketApiKeys.kBookingId : bookingID,  profileKeys.kDriverId : driverID] as [String : Any]
                socket.emit(socketApiKeys.kRejectBookingRequest, with: [myJSON])
                Singletons.sharedInstance.firstRequestIsAccepted = false
                
            }
            
        }
    }
    
    func RejectBookLaterBookingRequest() {
        
        let myJSON = [socketApiKeys.kBookingId : advanceBookingID,  profileKeys.kDriverId : driverID] as [String : Any]
        socket.emit(socketApiKeys.kForwardAdvancedBookingRequestToAnother, with: [myJSON])
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Cancel Trip
    //-------------------------------------------------------------
    
    
    func cancelTripByPassenger() {
        
        if isAdvanceBooking == true {
            
            self.CancelBookLaterTripByCancelNotification()
            
        }
        else {
            self.socket.on(socketApiKeys.kDriverCancelTripNotification, callback: { (data, ack) in
                print ("Cancel request regular by passenger: \(data)")
                
                UtilityClass.showAlert("Request Cancelled", message: (((data as NSArray).object(at: 0) as! NSDictionary)).object(forKey: "message") as! String, vc: ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController)!)
                self.resetMapView()
                
                Singletons.sharedInstance.isRequestAccepted = false
                Singletons.sharedInstance.isTripContinue = false
                UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
                UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
                self.setCarAfterTrip()
                
            })
        }
        
    }
    
    func CancelBookLaterTripByCancelNotification() {
        
        self.socket.on(socketApiKeys.kAdvancedBookingDriverCancelTripNotification, callback: { (data, ack) in
            print ("Cancel request Later by passenger:  \(data)")
            
            let alert = UIAlertController(title: nil, message: ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "message") as? String, preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                
                self.resetMapView()
                
                Singletons.sharedInstance.isRequestAccepted = false
                Singletons.sharedInstance.isTripContinue = false
                UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
                UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
                
                self.setCarAfterTrip()
                
            })
            
            alert.addAction(OK)
            
            self.present(alert, animated: true, completion: nil)
            
        })
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Set Car icon
    //-------------------------------------------------------------
    
    
    func setCarAfterTrip()
    {
        // print ("setCarAfterTrip")
        
        self.originCoordinate = CLLocationCoordinate2DMake(defaultLocation.coordinate.latitude, defaultLocation.coordinate.longitude)
        
        driverMarker = nil
        Singletons.sharedInstance.isRequestAccepted = false
        
//        let originMarker = GMSMarker(position: self.originCoordinate)
//        originMarker.map = self.mapView
//        originMarker.icon = UIImage(named: Singletons.sharedInstance.strSetCar)
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Button Action
    //-------------------------------------------------------------
    
    @IBAction func btnCurrentLocation(_ sender: UIButton) {
        
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude))
        mapView.animate(toZoom: 17.5)
        
    }
    
    
    @IBAction func btnStartTrip(_ sender: UIButton) {
        
        
        if isAdvanceBooking == true {
            
            if advanceBookingID == "" || driverID == "" {
                
                UtilityClass.showAlert("Missing", message: "Booking ID or Driver ID", vc: self)
                
            }
            else {
                
                self.PickupPassengerByDriverInBookLaterRequest()
                
                self.btnStartTripAction()
            }
        }
        else {
            
            if bookingID == "" || driverID == "" {
                
                UtilityClass.showAlert("Missing", message: "Booking ID or Driver ID", vc: self)
                
            }
            else {
                
                self.startTrip()
                self.btnStartTripAction()
            }
            
        }
        
    }
    
    func btnStartTripAction() {
        
        self.mapView.clear()
        self.driverMarker = nil
        
        
        Singletons.sharedInstance.isRequestAccepted = true
        Singletons.sharedInstance.isTripContinue = true
        
        UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
        UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
        
        
        if isAdvanceBooking == true {
            
            self.PickupPassengerByDriverInBookLaterRequest()
            
            BottomButtonView.isHidden = true
            StartTripView.isHidden = false
            
            self.pickupPassengerFromLocation()
            
        }
        else {
            
            BottomButtonView.isHidden = true
            StartTripView.isHidden = false
            
            self.pickupPassengerFromLocation()
            
            
        }
    }
    
    func startTrip() {
        
        let myJSON = [socketApiKeys.kBookingId : bookingID,  profileKeys.kDriverId : driverID] as [String : Any]
        socket.emit(socketApiKeys.kPickupPassengerByDriver, with: [myJSON])
        
    }
    
    @IBAction func btnShowPassengerInfo(_ sender: UIButton) {
        
        let data: NSArray = self.aryBookingData
        
        UserDefaults.standard.set(data, forKey: "BookNowInformation")
        UserDefaults.standard.synchronize()
        
        self.aryPassengerData = NSArray(array: data)
        self.BottomButtonView.isHidden = false
        
        let getPassengerInfo = getBookingAndPassengerInfo(data: self.aryPassengerData)
        
        
        let BookingInfo = getPassengerInfo.0
        let PassengerInfo = getPassengerInfo.1
        var imgURL = String()
        
        
        self.lblLocationOnMap.text = BookingInfo.object(forKey: "PickupLocation") as? String
        self.strPickupLocation = BookingInfo.object(forKey: "PickupLocation") as! String
        self.strDropoffLocation = BookingInfo.object(forKey: "DropoffLocation") as! String
        self.strPassengerName = PassengerInfo.object(forKey: "Fullname") as! String
        self.strPassengerMobileNo = PassengerInfo.object(forKey: "MobileNo") as! String
        
        if let img =  PassengerInfo.object(forKey: "Image") as? String {
            imgURL = img
        }
        else {
            imgURL = ""
        }
        
        if let PassengerType = BookingInfo.object(forKey: "PassengerType") as? String {
            Singletons.sharedInstance.passengerType = PassengerType
        }
        if Singletons.sharedInstance.passengerType == "other" || Singletons.sharedInstance.passengerType == "others" {
            
            if let contactNumber = BookingInfo.object(forKey: "PassengerContact") as? String {
                
                self.strPassengerMobileNo = contactNumber
            }
        }
        
        
        //        self.performSegue(withIdentifier: "seguePasdengerInfo", sender: nil)
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PassengerInfoViewController") as! PassengerInfoViewController
        next.strPickupLocation = self.strPickupLocation
        next.strDropoffLocation = self.strDropoffLocation
        next.imgURL = imgURL
        if((PassengerInfo.object(forKey: "FlightNumber")) != nil)
        {
            next.strFlightNumber = PassengerInfo.object(forKey: "FlightNumber") as! String
        }
        if((PassengerInfo.object(forKey: "Notes")) != nil)
        {
            next.strNotes = PassengerInfo.object(forKey: "Notes") as! String
        }
        next.strPassengerName =  self.strPassengerName
        next.strPassengerMobileNumber =  self.strPassengerMobileNo
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
        
        
    }
    var audioPlayer:AVAudioPlayer!
    
    func playSound(strName : String) {
        
        guard let url = Bundle.main.url(forResource: strName, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            //            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.numberOfLoops = 1
            audioPlayer.play()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        
        guard let url = Bundle.main.url(forResource: "ringTone", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.stop()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func enableButton() {
        self.btnCompleteTrip.isEnabled = true
    }
    
    var tollFee = String()
    
    func setPaddingView(txtField: UITextField){
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 15, height: 18))
        label.text = "$"

        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 15, height: 18))
        txtField.leftViewMode = .always
        txtField.addSubview(label)
        txtField.leftView = paddingView
    }
    
    @IBAction func btnCompleteTrip(_ sender: UIButton) {
        
        
        
        tollFee = "0.00"
        
        
        if(Singletons.sharedInstance.strBookingType == "")
        {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Toll Fee", message: "Enter toll fee if any", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "0.00"
            textField.keyboardType = .decimalPad
            self.setPaddingView(txtField: textField)

        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.tollFee = (textField?.text)!
            print("Text field: \(String(describing: textField?.text))")
            
            if Singletons.sharedInstance.passengerPaymentType == "cash" || Singletons.sharedInstance.passengerPaymentType == "Cash" {

                    self.completeTripButtonAction()
            
            }
            else {
                
                self.completeTripButtonAction()
            }
        }))
        
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "NO", style: .destructive, handler: { [] (_) in
            if Singletons.sharedInstance.passengerPaymentType == "cash" || Singletons.sharedInstance.passengerPaymentType == "Cash" {
     
                    self.completeTripButtonAction()
                
            }
            else {
                
                self.completeTripButtonAction()
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
        
        }
        else
        {
            self.completeTripButtonAction()

        }
        
    }
    
    func completeTripButtonAction() {
        
        self.btnCompleteTrip.isEnabled = false
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(HomeViewController.enableButton), userInfo: nil, repeats: false)
        
        if Singletons.sharedInstance.isTripHolding == true
        {
            UtilityClass.showAlert("Hold Trip Active", message: "Please stop holding trip", vc: self)
            
        }
        else {
            
            DispatchQueue.main.async {
                
                let PickupLat = Singletons.sharedInstance.startedTripLatitude
                let PickupLng = Singletons.sharedInstance.startedTripLongitude
                let DropOffLat = self.defaultLocation.coordinate.latitude
                let DropOffLon = self.defaultLocation.coordinate.longitude
                
                let dummyLatitude = Double(PickupLat) - Double(DropOffLat)
                let dummyLongitude = Double(PickupLng) - Double(DropOffLon)
                
                let waypointLatitude = self.defaultLocation.coordinate.latitude - dummyLatitude
                let waypointSetLongitude = self.defaultLocation.coordinate.longitude - dummyLongitude
                
                let pickupCordinate = "\(Singletons.sharedInstance.startedTripLatitude),\(Singletons.sharedInstance.startedTripLongitude)"
                let destinationCordinate = "\(self.defaultLocation.coordinate.latitude),\(self.defaultLocation.coordinate.longitude)"
                
                
                self.getDirectionsCompleteTripInfo(origin: pickupCordinate, destination: destinationCordinate, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: { (message, status) in
                    print("getDirectionsCompleteTripInfo : \(message)")
                })
                
            }
        }
    }
    
    func completeTripFinalSubmit() {
        
        if sumOfFinalDistance != 0 {
            
            var dictOFParam = [String:AnyObject]()
            let tollfee = self.tollFee.replacingOccurrences(of: "$", with: "")
            dictOFParam["TripDistance"] = sumOfFinalDistance as AnyObject
            dictOFParam["NightFareApplicable"] = 0 as AnyObject
            dictOFParam["PromoCode"] = "" as AnyObject
            dictOFParam["PaymentType"] = "cash" as AnyObject
            dictOFParam["PaymentStatus"] = "" as AnyObject
            dictOFParam["TransactionId"] = "" as AnyObject
            dictOFParam["TollFee"] = tollfee as AnyObject
            
            
            if isAdvanceBooking {
                
                dictOFParam["BookingId"] = advanceBookingID as AnyObject
                
                webserviceCallForAdvanceCompleteTrip(dictOFParam: dictOFParam as AnyObject)
            }
            else {
                
                dictOFParam["BookingId"] = bookingID as AnyObject
                
                webserviceCallForCompleteTrip(dictOFParam: dictOFParam as AnyObject)
            }
            
        }
    }
    
    
    //MARK:- ResetMap View
    func resetMapView()
    {
        self.mapView.clear()
        
        self.BottomButtonView.isHidden = true
        self.StartTripView.isHidden = true
        self.sumOfFinalDistance = 0
        
    }
    
    //MARK:- Holding Button
    
    @IBOutlet weak var btnCompleteTrip: UIButton!
    @IBOutlet weak var btnWaiting: UIButton!
    
    // Holding Button
    @IBAction func btnHoldWaiting(_ sender: UIButton) {
        
        
        if isAdvanceBooking {
            
            if advanceBookingID == "" {
                
                UtilityClass.showAlert("Missing", message: "Booking ID", vc: self)
                
            }
            else {
                
                if btnWaiting.currentTitle == "Hold (Waiting)" {
                    
                    btnWaiting.setTitle("Stop (Waiting)",for: .normal)
                    
                    Singletons.sharedInstance.isTripHolding = true
                    UserDefaults.standard.set(Singletons.sharedInstance.isTripHolding, forKey: holdTripStatus.kIsTripisHolding)
                    
                    self.StartHoldTrip()
                    
                }
                else if btnWaiting.currentTitle == "Stop (Waiting)" {
                    
                    btnWaiting.setTitle("Hold (Waiting)",for: .normal)
                    
                    Singletons.sharedInstance.isTripHolding = false
                    UserDefaults.standard.set(Singletons.sharedInstance.isTripHolding, forKey: holdTripStatus.kIsTripisHolding)
                    self.EndHoldTrip()
                    
                }
                
            }
            
        }
        else {
            
            if bookingID == "" {
                
                UtilityClass.showAlert("Missing", message: "Booking ID", vc: self)
                
            }
            else {
                
                if btnWaiting.currentTitle == "Hold (Waiting)" {
                    
                    btnWaiting.setTitle("Stop (Waiting)",for: .normal)
                    
                    Singletons.sharedInstance.isTripHolding = true
                    UserDefaults.standard.set(Singletons.sharedInstance.isTripHolding, forKey: holdTripStatus.kIsTripisHolding)
                    
                    let myJSON = [socketApiKeys.kBookingId : bookingID] as [String : Any]
                    socket.emit(socketApiKeys.kStartHoldTrip, with: [myJSON])
                    
                }
                else if btnWaiting.currentTitle == "Stop (Waiting)" {
                    
                    btnWaiting.setTitle("Hold (Waiting)",for: .normal)
                    
                    Singletons.sharedInstance.isTripHolding = false
                    UserDefaults.standard.set(Singletons.sharedInstance.isTripHolding, forKey: holdTripStatus.kIsTripisHolding)
                    
                    let myJSON = [socketApiKeys.kBookingId : bookingID] as [String : Any]
                    socket.emit(socketApiKeys.kEndHoldTrip, with: [myJSON])
                    
                }
                
            }
        }
        
    }
    
    @IBOutlet weak var btnRejectRequest: UIButton!
    @IBOutlet weak var btnAcceptRequest: UIButton!
    
    @IBAction func btnAcceptRequest(_ sender: UIButton) {
        
        
        self.resetMapView()
        
        
        if isAdvanceBooking {
            self.AcceptBookLaterBookingRequest()
        }
        else {
            self.BookingAcceped()
        }
        
        
    }
    
    @IBAction func btnRejectRequest(_ sender: UIButton) {
        
        if isAdvanceBooking {
            self.RejectBookLaterBookingRequest()
        }
        else {
            self.BookingRejected()
        }
        
    }
    
    @IBAction func btnPassengerInfoOK(_ sender: UIButton) {
        
    }
    
    func pickupPassengerFromLocation() {
        
        
        let BookingInfo : NSDictionary!
        
        if((((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) == nil)
        {
            // print ("Yes its  array ")
            BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        }
        else
        {
            // print ("Yes its dictionary")
            BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
        }
        
        // ------------------------------------------------------------
        let DropOffLat = BookingInfo.object(forKey: "DropOffLat") as! String
        let DropOffLon = BookingInfo.object(forKey: "DropOffLon") as! String
        
        Singletons.sharedInstance.startedTripLatitude = Double(BookingInfo.object(forKey: "PickupLat") as! String)!
        Singletons.sharedInstance.startedTripLongitude = Double(BookingInfo.object(forKey: "PickupLng") as! String)!
        
        self.lblLocationOnMap.text = BookingInfo.object(forKey: "DropoffLocation") as? String
        
        let PickupLat = self.defaultLocation.coordinate.latitude
        let PickupLng = self.defaultLocation.coordinate.longitude
        
        let dummyLatitude = Double(PickupLat) - Double(DropOffLat)!
        let dummyLongitude = Double(PickupLng) - Double(DropOffLon)!
        
        let waypointLatitude = self.defaultLocation.coordinate.latitude - dummyLatitude
        let waypointSetLongitude = self.defaultLocation.coordinate.longitude - dummyLongitude
        
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        zoomoutCamera(PickupLat: PickupLat, PickupLng: PickupLng, DropOffLat: DropOffLat, DropOffLon: DropOffLon)
        
        self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Prepare For Segue
    //-------------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ReceiveRequestViewController {
            destination.delegate = self
        }
        else if let moveToPassenger = segue.destination as? PassengerInfoViewController {
            
            moveToPassenger.strPickupLocation = self.strPickupLocation
            moveToPassenger.strDropoffLocation = self.strDropoffLocation
            
            moveToPassenger.strPassengerName =  self.strPassengerName
            moveToPassenger.strPassengerMobileNumber =  self.strPassengerMobileNo
        }
        else if let moveToTripInfo = segue.destination as? RatingViewController {
            
            let getBookingAndPassengerInfo = self.getBookingAndPassengerInfo(data: self.aryPassengerData)
            
            //            let BookingInfo = getBookingAndPassengerInfo.0
            let PassengerInfo = getBookingAndPassengerInfo.1
            //            let PassengerInfo: NSDictionary!
            //            if((((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) == nil)
            //            {
            //                PassengerInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "PassengerInfo") as! NSArray).object(at: 0) as! NSDictionary
            //
            //            }
            //            else
            //            {
            //                PassengerInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "PassengerInfo") as! NSDictionary)
            //            }
            moveToTripInfo.strBookingType = "BookNow"
            if(isAdvanceBooking)
            {
                moveToTripInfo.strBookingType = "BookLater"
            }
            //
            moveToTripInfo.dictData = self.dictCompleteTripData
            moveToTripInfo.dictPassengerInfo = PassengerInfo
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - ARCar Movement Delegate Method
    //-------------------------------------------------------------
    func ARCarMovementMoved(_ Marker: GMSMarker) {
        driverMarker = Marker
        driverMarker.map = mapView
        
        //animation to make car icon in center of the mapview
        //
        //        let updatedCamera = GMSCameraUpdate.setTarget(driverMarker.position, zoom: 15.0)
        //        mapView.animate(with: updatedCamera)
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Route on Map Methods
    //-------------------------------------------------------------
    
    
    
    func getDirectionsSeconMethod(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?) {
        
        UtilityClass.hideACProgressHUD()
        mapView.clear()
        DispatchQueue.main.async {
            UtilityClass.showACProgressHUD()
            print("Function: \(#function), line: \(#line)")

        }
        
        //        UtilityClass.showAlert(appName.kAPPName, message: "Map View Called", vc: self)
        

        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation
                    if let routeWaypoints = waypoints {
                        directionsURLString += "&waypoints=optimize:true"
                        
                        for waypoint in routeWaypoints {
                            directionsURLString += "|" + waypoint
                        }
                    }
//                    print ("directionsURLString: \(directionsURLString)")
//                    directionsURLString = directionsURLString.addingPercentEscapes(using: String.Encoding.utf8)!
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    let directionsURL = NSURL(string: directionsURLString)
                    DispatchQueue.main.async( execute: { () -> Void in
                        let directionsData = NSData(contentsOf: directionsURL! as URL)
                        do{
                            let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                            
                            let status = dictionary["status"] as! String
                            
                            if status == "OK" {
                                self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                                
                                let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                
                                let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                
                                let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                
                                let originAddress = legs[0]["start_address"] as! String
                                let destinationAddress = legs[legs.count - 1]["end_address"] as! String
                                
//                                print ("getDirectionsSeconMethod")
                                
                                if(Singletons.sharedInstance.isRequestAccepted)
                                {
                                    
                                    if(self.driverMarker == nil)
                                    {
                                        
                                        self.driverMarker = GMSMarker(position: self.originCoordinate)
                                        //                                    self.driverMarker.position = self.originCoordinate
                                        self.driverMarker.icon = UIImage(named: Singletons.sharedInstance.strSetCar)
                                        self.driverMarker.map = self.mapView
                                        
                                        
                                    }
                                    
                                }
                                else
                                {
                                    let originMarker = GMSMarker(position: self.originCoordinate)
                                    originMarker.map = self.mapView
                                    originMarker.icon = UIImage(named: Singletons.sharedInstance.strSetCar)
                                    originMarker.title = originAddress
                                }
                                
                                let destinationMarker = GMSMarker(position: self.destinationCoordinate)
                                destinationMarker.map = self.mapView
                                destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
                                destinationMarker.title = destinationAddress
                                
                                var aryDistance = [String]()
                                var finalDistance = Double()
                                
                                for i in 0..<legs.count
                                {
                                    let legsData = legs[i]
                                    let distanceKey = legsData["distance"] as! Dictionary<String, AnyObject>
                                    let distance = distanceKey["text"] as! String
                                    let stringDistance = distance.components(separatedBy: " ")
                                    
                                    //                                    print("stringDistance : \(stringDistance)")
                                    
                                    if stringDistance[1] == "m" {
                                        finalDistance += Double(stringDistance[0])! / 1000
                                    }
                                    else {
                                        finalDistance += Double(stringDistance[0].replacingOccurrences(of: ",", with: ""))!
                                    }
                                    aryDistance.append(distance)
                                }
                                
                                if finalDistance == 0 {
                                    //                                    UtilityClass.showAlert(appName.kAPPName, message: "Distance is 0 by not countable distance", vc: self)
                                    
                                }
                                else {
                                    //                                    self.sumOfFinalDistance = finalDistance
                                }
                                
                                let route = self.overviewPolyline["points"] as! String
                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                let routePolyline = GMSPolyline(path: path)
                                routePolyline.map = self.mapView
                                routePolyline.strokeColor = UIColor.init(red: 44, green: 134, blue: 200, alpha: 1.0)
                                routePolyline.strokeWidth = 3.0
                                //                                UtilityClass.hideACProgressHUD()
                                
                            }
                            else {
                                DispatchQueue.main.async {
                                    UtilityClass.hideACProgressHUD()
                                    print("Function: \(#function), line: \(#line)")
                                    
                                    }
                                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: {
                                    
//                                    UtilityClass.showAlert(appName.kAPPName, message: "Not able to get location due to free api key please restart app", vc: self)
                                })
                                
                                
                                self.pickupPassengerFromLocation()
                                UtilityClass.showAlert(appName.kAPPName, message: "OVER_QUERY_LIMIT", vc: self)
                                print("OVER_QUERY_LIMIT")
                                
                                
                                
                                //completionHandler(status: status, success: false)
                            }
                        }
                        catch {
                            print("Catch Not able to get location due to free api key please restart app")
                            UtilityClass.showAlert(appName.kAPPName, message: "Not able to get location due to free api key please restart app", vc: self)
                            // completionHandler(status: "", success: false)
                            self.pickupPassengerFromLocation()
                            DispatchQueue.main.async {
                                UtilityClass.hideACProgressHUD()
                                print("Function: \(#function), line: \(#line)")
                                
                            }
                        }
                        
                        DispatchQueue.main.async {
                            UtilityClass.hideACProgressHUD()
                            print("Function: \(#function), line: \(#line)")
                            
                        }
                        
                    })
                }
                else {
                    print  ("Destination is nil.")
                    UtilityClass.showAlert(appName.kAPPName, message: "Destination is nil.", vc: self)
                    DispatchQueue.main.async {
                        UtilityClass.hideACProgressHUD()
                        print("Function: \(#function), line: \(#line)")
                        
                    }
                    //completionHandler(status: "Destination is nil.", success: false)
                }
            }
            else {
                print  ("Origin is nil")
                UtilityClass.showAlert(appName.kAPPName, message: "Origin is nil.", vc: self)
                DispatchQueue.main.async {
                    UtilityClass.hideACProgressHUD()
                    print("Function: \(#function), line: \(#line)")
                    
                }
                //completionHandler(status: "Origin is nil", success: false)
            }
            
            
        }
        
        
    }
    
    func getDirectionsCompleteTripInfo(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?) {
        
        
        DispatchQueue.main.async {
            UtilityClass.showACProgressHUD()
            print("Function: \(#function), line: \(#line)")

        }
        

        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation
                    if let routeWaypoints = waypoints {
                        directionsURLString += "&waypoints=optimize:true"
                        
                        for waypoint in routeWaypoints {
                            directionsURLString += "|" + waypoint
                        }
                    }
//                    print ("directionsURLString: \(directionsURLString)")
//                    directionsURLString = directionsURLString.addingPercentEscapes(using: String.Encoding.utf8)!
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    let directionsURL = NSURL(string: directionsURLString)
                    DispatchQueue.main.async( execute: { () -> Void in
                        let directionsData = NSData(contentsOf: directionsURL! as URL)
                        do{
                            let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                            
                            let status = dictionary["status"] as! String
                            
                            if status == "OK" {
                                self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                                
                                let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                
                                let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                
                                let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                
//                                print ("getDirectionsSeconMethod")
                                
                                var aryDistance = [String]()
                                var finalDistance = Double()
                                
                                for i in 0..<legs.count
                                {
                                    let legsData = legs[i]
                                    let distanceKey = legsData["distance"] as! Dictionary<String, AnyObject>
                                    let distance = distanceKey["text"] as! String
                                    let stringDistance = distance.components(separatedBy: " ")
                                    
                                    if stringDistance[1] == "m" {
                                        finalDistance += Double(stringDistance[0])! / 1000
                                    }
                                    else {
                                        finalDistance += Double(stringDistance[0].replacingOccurrences(of: ",", with: ""))!
                                    }
                                    aryDistance.append(distance)
                                }
                                
                                if finalDistance == 0 {
                                    UtilityClass.showAlert(appName.kAPPName, message: "Distance is 0 by not countable distance", vc: self)
                                    
                                }
                                else {
                                    self.sumOfFinalDistance = finalDistance
                                    DispatchQueue.main.async {
//                                        UtilityClass.hideACProgressHUD()
                                        self.completeTripFinalSubmit()

                                        print("Function: \(#function), line: \(#line)")
                                        
                                    }
                                    
                                }
                                
                            }
                            else {
                                
                                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: {
                                    
                                    UtilityClass.showAlert(appName.kAPPName, message: "Not able to get location due to free api key please restart app", vc: self)
                                    DispatchQueue.main.async {
                                        UtilityClass.hideACProgressHUD()
                                        print("Function: \(#function), line: \(#line)")
                                        
                                    }
                                })
                                
                                //
                                UtilityClass.showAlert(appName.kAPPName, message: "OVER_QUERY_LIMIT", vc: self)
                                print("Function: \(#function), line: \(#line) OVER_QUERY_LIMIT")

                                DispatchQueue.main.async {
                                    UtilityClass.hideACProgressHUD()
                                    print("Function: \(#function), line: \(#line)")
                                    
                                }
                                
                            }
                        }
                        catch {
//                            print("Catch Not able to get location due to free api key please restart app")
                            UtilityClass.showAlert(appName.kAPPName, message: "Not able to get location due to free api key please restart app", vc: self)
                            print("Function: \(#function), line: \(#line) Not able to get location due to free api key please restart app")

                        }
                    })
                }
                else {
                    print  ("Destination is nil.")
                    UtilityClass.showAlert(appName.kAPPName, message: "Destination is nil.", vc: self)
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            UtilityClass.hideACProgressHUD()
                            print("Function: \(#function), line: \(#line)")
                            
                        }
                        print("Function: \(#function), line: \(#line)")
                        
                    }
                }
            }
            else {
                print  ("Origin is nil")
                UtilityClass.showAlert(appName.kAPPName, message: "Origin is nil.", vc: self)
                DispatchQueue.main.async {
                    UtilityClass.hideACProgressHUD()
                    print("Function: \(#function), line: \(#line)")
                    
                }
                
            }
            
            
        }
        
        
    }
    
    // ----------------------------------------------------------------------
    //-------------------------------------------------------------
    // MARK: -
    //-------------------------------------------------------------
    
    
    func setCar()
    {
        let profile: NSMutableDictionary = NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as? NSDictionary)!)
        let Vehicle: NSMutableDictionary = NSMutableDictionary(dictionary: profile.object(forKey: "Vehicle") as! NSDictionary)
        let VehicleName = Vehicle.object(forKey: "VehicleClass") as! String
        if VehicleName.range(of:"First Class") != nil {
            print("First Class")
            Singletons.sharedInstance.strSetCar = "imgFirstClass"
        }
        else if (VehicleName.range(of:"Business Class") != nil) {
            print("First Class")
            Singletons.sharedInstance.strSetCar = "imgBusinessClass"
            
        }
        else if (VehicleName.range(of:"Economy") != nil) {
            print("First Class")
            Singletons.sharedInstance.strSetCar = "imgEconomy"
            
        }
        else if (VehicleName.range(of:"Taxi") != nil) {
            print("First Class")
            Singletons.sharedInstance.strSetCar = "imgTaxi"
            
        }
        else if (VehicleName.range(of:"LUX-VAN") != nil) {
            print("First Class")
            Singletons.sharedInstance.strSetCar = "imgLUXVAN"
            
        }
        else if (VehicleName.range(of:"Disability") != nil) {
            print("First Class")
            Singletons.sharedInstance.strSetCar = "imgDisability"
            
        }
        
        
        print(VehicleName)
    }
    
    func markerCarIconName(modelId: Int) -> String {
        
        var CarModel = String()
        
        switch modelId {
        case 1:
            CarModel = "imgBusinessClass"
            return CarModel
        case 2:
            CarModel = "imgDisability"
            return CarModel
        case 3:
            CarModel = "imgTaxi"
            return CarModel
        case 4:
            CarModel = "imgFirstClass"
            return CarModel
        case 5:
            CarModel = "imgLUXVAN"
            return CarModel
        case 6:
            CarModel = "imgEconomy"
            return CarModel
        default:
            CarModel = Singletons.sharedInstance.strSetCar
            return CarModel
        }
        
    }
    
    var dictCurrentBookingInfoData = NSDictionary()
    var dictCurrentPassengerInfoData = NSDictionary()
    var aryCurrentBookingData = NSMutableArray()
    
    var checkBookingType = String()
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Check Current Booking
    //-------------------------------------------------------------
    func webserviceOfCurrentBooking() {
        
        if let Token = UserDefaults.standard.object(forKey: "Token") as? String {
            Singletons.sharedInstance.deviceToken = Token
        }
        
        
        let param = Singletons.sharedInstance.strDriverID + "/" + Singletons.sharedInstance.deviceToken
        
        webserviceForCurrentBooking(param as AnyObject) { (result, status) in
            
            if (status) {
                
                self.resetMapView()
                
                let resultData = (result as! NSDictionary)
                Singletons.sharedInstance.strCurrentBalance = Double(resultData.object(forKey: "balance") as! String)!
                var rating = String()
                if let ratingTemp = resultData.object(forKey: "rating") as? String
                {
                    if (ratingTemp == "")
                    {
                        rating = "0.0"
                    }
                    else
                    {
                        rating = ratingTemp
                    }
                }
                
                Singletons.sharedInstance.strRating = rating
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("rating"), object: nil)
                self.aryCurrentBookingData.add(resultData)
                
                self.aryPassengerData = self.aryCurrentBookingData
                
                if let loginStatus = (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "login") as? Bool {
                    
                    if (loginStatus) {
                        
                    }
                    else {
                        UtilityClass.showAlertWithCompletion("Multiple login", message: "Please Re-Login", vc: self, completionHandler: { ACTION in
                            
                            self.webserviceOFSignOut()
                        })
                    }
                }
                
                let bookingType = (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "BookingType") as! String
                
                Singletons.sharedInstance.strBookingType = ((self.aryCurrentBookingData.object(at: 0) as! [String: AnyObject])["BookingInfo"] as! [String : AnyObject])["BookingType"]! as! String
                
                self.dictCurrentBookingInfoData = ((resultData).object(forKey: "BookingInfo") as! NSDictionary)
                let statusOfRequest = self.dictCurrentBookingInfoData.object(forKey: "Status") as! String
                
                let PassengerType = self.dictCurrentBookingInfoData.object(forKey: "PassengerType") as? String
                
                if PassengerType == "" || PassengerType == nil{
                    Singletons.sharedInstance.passengerType = ""
                }
                else {
                    Singletons.sharedInstance.passengerType = PassengerType!
                }
                if(self.dictCurrentBookingInfoData.object(forKey: "PaymentType") as! String == "cash")
                {
                    Singletons.sharedInstance.passengerPaymentType = self.dictCurrentBookingInfoData.object(forKey: "PaymentType") as! String
                }
                
                
                DispatchQueue.main.async {
                    UtilityClass.showHUD()

                }
                
                
                if bookingType != "" {
                    
                    if bookingType == "BookNow" {
                        if statusOfRequest == "accepted" {
                            
                            self.bookingID = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.driverID = Singletons.sharedInstance.strDriverID
                            
                            self.bookingTypeIsBookNow()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            
                            self.bookingID = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.driverID = Singletons.sharedInstance.strDriverID
                            
                            self.btnStartTripAction()
                        }
                        
                    }
                    else if bookingType == "BookLater" {
                        
                        self.isAdvanceBooking = true
                        
                        if statusOfRequest == "accepted" {
                            
                            self.advanceBookingID = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.driverID = Singletons.sharedInstance.strDriverID
                            
                            self.bookingtypeBookLater()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            
                            self.advanceBookingID = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.driverID = Singletons.sharedInstance.strDriverID
                            
                            self.btnStartTripAction()
                        }
                    }
                    
                    
                }
                else {
                    
                }
                self.webserviceOFGetAllCards()
            }
            else {
                
                let resultData = (result as! NSDictionary)
                Singletons.sharedInstance.strCurrentBalance = Double(resultData.object(forKey: "balance") as! String)!
                var rating = String()
                if let ratingTemp = resultData.object(forKey: "rating") as? String
                {
                    if (ratingTemp == "")
                    {
                        rating = "0.0"
                    }
                    else
                    {
                        rating = ratingTemp
                    }
                }
                
                Singletons.sharedInstance.strRating = rating
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("rating"), object: nil)
                self.aryCurrentBookingData.add(resultData)
                
                self.aryPassengerData = self.aryCurrentBookingData
                
                if let loginStatus = (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "login") as? Bool {
                    
                    if (loginStatus) {
                        
                    }
                    else {
                        UtilityClass.showAlertWithCompletion("Multiple login", message: "Please Re-Login", vc: self, completionHandler: { ACTION in
                            
                            self.webserviceOFSignOut()
                        })
                    }
                }
                
                self.webserviceOFGetAllCards()
            }
            
            
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Completeing Current Booking
    //-------------------------------------------------------------
    
    func webserviceCallForCompleteTrip(dictOFParam : AnyObject)
    {
        webserviceForCompletedTripSuccessfully(dictOFParam as AnyObject) { (result, status) in
            
            if (status) {
                
                self.dictCompleteTripData = (result as! NSDictionary)
                
                self.resetMapView()
                
                Singletons.sharedInstance.isRequestAccepted = false
                Singletons.sharedInstance.isTripContinue = false
                
                if let paymentType = (self.dictCompleteTripData.object(forKey: "details") as! NSDictionary).object(forKey: "PaymentType") as? String {
                    Singletons.sharedInstance.passengerPaymentType = paymentType
                }
                
                if Singletons.sharedInstance.passengerPaymentType == "cash" || Singletons.sharedInstance.passengerPaymentType == "Cash" {
                    
                    
                    self.playSound(strName: "ringTone")
                    UtilityClass.showAlertWithCompletion("Alert! This is a cash job", message: "Please Collect Money From Passenger", vc: self, completionHandler: { ACTION in
                        
                        DispatchQueue.main.async {
                            self.stopSound()
                        }
//                        self.completeTripButtonAction()
                        
                        UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
                        UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
                        
                        DispatchQueue.main.async {
                            self.setCarAfterTrip()
                            self.completeTripInfo()
                        }
                    })
                }
                else
                {
                    DispatchQueue.main.async {
                        self.setCarAfterTrip()
                        self.completeTripInfo()
                    }
                }
                
                
               
            }
            else {
                if let res: String = result as? String {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else {
                    UtilityClass.showAlert(appName.kAPPName, message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
                
            }
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Completeing Advance Booking
    //-------------------------------------------------------------
    
    func webserviceCallForAdvanceCompleteTrip(dictOFParam : AnyObject)
    {
        webserviceForCompletedAdvanceTripSuccessfully(dictOFParam as AnyObject) { (result, status) in
            
            if (status) {
                
                self.dictCompleteTripData = (result as! NSDictionary)
                
                self.resetMapView()
                
                Singletons.sharedInstance.isRequestAccepted = false
                Singletons.sharedInstance.isTripContinue = false
                UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
                UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
                
                self.setCarAfterTrip()
                
                if Singletons.sharedInstance.passengerType == "other" || Singletons.sharedInstance.passengerType == "others" {
                    self.completeTripInfo()
                }
                else {
                    self.performSegue(withIdentifier: "seguePresentRatings", sender: nil)
                }
                
            }
            else {
                
                if let res: String = result as? String {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else {
                    UtilityClass.showAlert(appName.kAPPName, message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Getting List of Sards
    //-------------------------------------------------------------
    
    func webserviceOFGetAllCards() {
        
        webserviceForCardListingInWallet(Singletons.sharedInstance.strDriverID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                
                
                Singletons.sharedInstance.CardsVCHaveAryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                
            }
            else {
                
                print(result)
                if let res = result as? String {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Sign Out
    //-------------------------------------------------------------
    
    func webserviceOFSignOut()
    {
        let srtDriverID = Singletons.sharedInstance.strDriverID
        
        let param = srtDriverID + "/" + Singletons.sharedInstance.deviceToken
        
        webserviceForSignOut(param as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
                
                
                socket.off(socketApiKeys.kReceiveBookingRequest)
                socket.off(socketApiKeys.kBookLaterDriverNotify)
                
                socket.off(socketApiKeys.kGetBookingDetailsAfterBookingRequestAccepted)
                socket.off(socketApiKeys.kAdvancedBookingInfo)
                
                socket.off(socketApiKeys.kReceiveMoneyNotify)
                socket.off(socketApiKeys.kAriveAdvancedBookingRequest)
                
                socket.off(socketApiKeys.kDriverCancelTripNotification)
                socket.off(socketApiKeys.kAdvancedBookingDriverCancelTripNotification)
                
                socket.disconnect()
                
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                
                self.performSegue(withIdentifier: "SignOutFromHome", sender: (Any).self)
                
                
            }
            else {
                print(result)
                if let res = result as? String {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Trip Bookings
    //-------------------------------------------------------------
    
    func bookingTypeIsBookNow() {
        
        methodAfterDidAcceptBooking(data: aryCurrentBookingData)
        
    }
    
    func bookingtypeBookLater() {
        
        methodAfterDidAcceptBookingLaterRequest(data: aryCurrentBookingData)
        
    }
    
    func bookingStatusAccepted() {
        
        btnStartTripAction()
        
    }
    
    func bookingStatusTraveling() {
        
        btnStartTripAction()
    }
    
    @IBAction func getDirections(_ sender: Any) {
        
        let BookingInfo : NSDictionary!
        
        if((((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) == nil)
        {
            BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        }
        else
        {
            BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
        }
        
        
        // ------------------------------------------------------------
        var DropOffLat = BookingInfo.object(forKey: "PickupLat") as! String
        var DropOffLon = BookingInfo.object(forKey: "PickupLng") as! String
        
        if(Singletons.sharedInstance.isTripContinue == true)
        {
            DropOffLat = BookingInfo.object(forKey: "DropOffLat") as! String
            DropOffLon = BookingInfo.object(forKey: "DropOffLon") as! String
        }
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            UIApplication.shared.open(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(String(describing: Float(DropOffLat)!)),\(String(describing: Float(DropOffLon)!))&directionsmode=driving")! as URL, options: [:], completionHandler: { (status) in
                    
            })
            
        } else
        {
            NSLog("Can't use com.google.maps://");
        }
    }
    
    
    func didRatingCompleted() {
        
        self.performSegue(withIdentifier: "seguePresentRatings", sender: nil)
        
    }
    
    func completeTripInfo() {
        
        
//        if Singletons.sharedInstance.passengerType == "other" || Singletons.sharedInstance.passengerType == "others" {
//            let next = self.storyboard?.instantiateViewController(withIdentifier: "TripInfoCompletedTripVC") as! TripInfoCompletedTripVC
//            next.dictData = self.dictCompleteTripData
//            next.delegate = self
//            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
//
//            Singletons.sharedInstance.passengerType = ""
//        }
//        else {
        
            Singletons.sharedInstance.passengerType = ""
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "TripInfoCompletedTripVC") as! TripInfoCompletedTripVC
            next.dictData = self.dictCompleteTripData
            next.delegate = self
        DispatchQueue.main.async {
            self.btnCurrentLocation(self.btnCurrentlocation)
            
        }
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
        
        
        
//        }
        
    }
    
}
