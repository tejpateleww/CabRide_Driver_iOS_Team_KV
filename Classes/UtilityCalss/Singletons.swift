//
//  Singletons.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 28/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class Singletons: NSObject {
    var dictDriverProfile : NSMutableDictionary!
    var arrVehicleClass: NSMutableArray!
    var isDriverLoggedIN : Bool!
    var isPasscodeON = Bool()
    var strDriverID = String()
    var strPromocode = String()
    var strPaymentType = String()
    var strRating = String()
    var isFromRegistration = Bool()
    static let sharedInstance = Singletons()
    var vehicleClass: String!
     var strTickPayAmt: String!
    var AryVehicleClass: [Int]!
    
    var driverDuty: String!
    
    var currentLatitude: Double!
    var currentLongitude: Double!
    
    var latitude : Double!
    var longitude : Double!
    
    var boolTaxiModel = Bool() // if True { cars_and_taxi } if False { delivery_services }
        var isFirstTimeDidupdateLocation = true
    var aryPassengerInfo = NSArray()
    
    var isPresentVC = Bool()
    var isBackFromPending = Bool()
    var strPendinfTripData = String()
    var isFromNotification = Bool()

    var isTripContinue = Bool()
    var isRequestAccepted = Bool()
    
    var isTiCKPayFromSideMenu = Bool()
    
    var isTripHolding = Bool()
    var isBookNowORNot = Bool()
    
    var showTickPayRegistrationSceeen = Bool()
    
    var isFromTopUP = Bool()
    var isFromTransferToBank = Bool()
    
    var isCardsVCFirstTimeLoad: Bool = true
    var CardsVCHaveAryData = [[String:AnyObject]]()
    
    var strCurrentBalance = Double()
    var floatBearing:Double = 0.0
    var walletHistoryData = [[String:AnyObject]]()
    
    var strQRCodeForSendMoney = String()
    var isSendMoneySuccessFully = Bool()
    
    var firstRequestIsAccepted = Bool()
    
    var isfirstTimeTickPay = Bool()
    var strIsFirstTimeTickPay = String()
    var strTickPayId = String()
    var strAmoutOFTickPay = String()
    
    // For Registration
    var isDriverVehicleTypesViewControllerFilled = Bool()
    
    var startedTripLatitude = Double()
    var startedTripLongitude = Double()
    var endedTripLatitude = Double()
    var endedTripLongitude = Double()
    
    var deviceToken = String()
    
    var setPasscode = String()
    var strSetCar = String()
    var passwordFirstTime = Bool()
    
    var passengerType = String()
    var pasengerFlightNumber = String()
    var passengerNote = String()
    var strBookingType = String()
    var passengerPaymentType = String()
    

}
/*
if let passengerType = BookingInfo.object(forKey: "PassengerType") as? String {
    Singletons.sharedInstance.passengerType = passengerType
}
if let pasengerFlightNumber = BookingInfo.object(forKey: "FlightNumber") as? String {
    Singletons.sharedInstance.pasengerFlightNumber = pasengerFlightNumber
}
if let passengerNote = BookingInfo.object(forKey: "Notes") as? String {
    Singletons.sharedInstance.passengerNote = passengerNote
}
*/
