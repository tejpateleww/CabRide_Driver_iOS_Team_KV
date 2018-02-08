//
//  DummyData.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 04/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import Foundation
/*
"kReceiveBookingRequest"
[{
    BookingId = 980;
    BookingType = "";
    DriverId = 21;
    DropoffLocation = "Iscoxzx, Sarkhej - Gandhinagar Highway, Ahmedabad, Gujarat, India";
    GrandTotal = "";
    PickupLocation = "119, Science City Rd, Sola, Ahmedabad, Gujarat 380060, India";
    message = "New booking request arrived from TiCKTOC";
    type = BookingRequest;
}]
 
 [{
 BookingId = 981;
 BookingType = dispatch;
 DriverId = 21;
 DropoffLocation = "Sola Bridge, Sola, Ahmedabad, Gujarat, India";
 GrandTotal = "28.88";
 PickupLocation = "Star Hospital, Ahmedabad, Gujarat, India";
 message = "New booking request arrived from TiCKTOC";
 type = BookingRequest;
 }]
*/

/*
 "GetAdvanceBookingDetailsAfterBookingRequestAccepted()"
[{
    BookingInfo =     (
        {
            AdminAmount = "";
            BookingCharge = "";
            BookingType = "";
            ByDriverAmount = "";
            ByDriverId = 0;
            CardId = 0;
            CompanyAmount = "";
            CompanyId = 1;
            CompanyTax = "";
            CreatedDate = "2018-01-10T03:45:09.000Z";
            Discount = "";
            DistanceFare = "";
            DriverId = 21;
            DropOffLat = "23.030513";
            DropOffLon = "72.5075401";
            DropTime = "";
            DropoffLocation = "Iscoxzx, Sarkhej - Gandhinagar Highway, Ahmedabad, Gujarat, India";
            FlightNumber = filkdh;
            GrandTotal = "";
            Id = 124;
            ModelId = 3;
            NightFare = "";
            NightFareApplicable = 0;
            Notes = hello;
            OnTheWay = 1;
            PaidToDriver = 0;
            PassengerContact = 9999999999;
            PassengerEmail = "";
            PassengerId = 29;
            PassengerName = allu;
            PassengerType = other;
            PaymentStatus = "";
            PaymentType = cash;
            PickupDate = "2018-01-10T00:00:00.000Z";
            PickupDateTime = "2018-01-10T17:13:00.000Z";
            PickupLat = "23.0714566";
            PickupLng = "72.5161168";
            PickupLocation = "119, Science City Rd, Sola, Ahmedabad, Gujarat 380060, India";
            PickupTime = "";
            PromoCode = "";
            Reason = "";
            Status = accepted;
            SubDispatcherId = 0;
            SubTotal = "";
            Tax = "";
            TollFee = "";
            TransactionId = "";
            TripDistance = "7.9";
            TripDuration = 1020;
            TripFare = "";
            WaitingTime = "";
            WaitingTimeCost = "";
        }
    );
    PassengerInfo =     (
        {
            Fullname = "Ganpat Developer";
            MobileNo = 9898989898;
        }
    );
    type = BookingInfo;
    }]
*/



// Register Data
/*
{
    profile =     {
        ABN = 1234556;
        AccreditationCertificate = "http://54.206.55.185/web/images/driver/21/image5.jpeg";
        AccreditationCertificateExpire = "2018-03-14";
        Address = Prahladnagar;
        Availability = 0;
        BSB = qwerty;
        BankAcNo = 12345678900987;
        BankHolderName = Bhavesh;
        BankName = HDFC;
        City = "Ahmedabad ";
        CompanyId = 1;
        Country = "India ";
        DCNumber = "";
        DispatcherId = 0;
        DriverDuty = 1;
        DriverLicense = "http://54.206.55.185/web/images/driver/21/image4.jpeg";
        DriverLicenseExpire = "2018-01-11";
        Email = "bhavesh@excellentwebworld.info";
        Fullname = Bhavesh;
        Gender = Male;
        Id = 21;
        Image = "http://54.206.55.185/web/images/driver/21/image.png";
        Lat = "72.0236514";
        Lng = "";
        MobileNo = 9876543210;
        Password = 25d55ad283aa400af464c76d713c07ad;
        ProfileComplete = 1;
        ReferralCode = tktc21Bha;
        State = "Gujarat ";
        Status = 1;
        SubUrb = Ahm;
        Vehicle =         {
            Color = Black;
            Company = Hummer;
            CompanyId = 1;
            Description = "";
            DriverId = 21;
            Id = 146;
            RegistrationCertificate = "http://54.206.55.185/web/images/driver/21/image.jpeg";
            RegistrationCertificateExpire = "2018-05-09";
            VehicleClass = "First Class,Disability";
            VehicleImage = "http://54.206.55.185/web/images/driver/21/image2.jpeg";
            VehicleInsuranceCertificate = "http://54.206.55.185/web/images/driver/21/image1.jpeg";
            VehicleInsuranceCertificateExpire = "2018-06-09";
            VehicleModel = "4,2";
            VehicleRegistrationNo = "GJ-01-B-9999";
        };
        ZipCode = 560071;
    };
    status = 1;
}
*/

// ------------------------------------------------------------
// ------------------------------------------------------------

// Complete trip Data
/*
{
    details =     {
        AdminAmount = "29.445";
        BookingCharge = 2;
        CompanyAmount = "265.005";
        CreatedDate = "2017-11-04 02:04:18";
        Discount = 0;
        DriverId = 21;
        DropOffLat = "23.012033799999998";
        DropOffLon = "72.51075399999999";
        DropTime = "";
        DropoffLocation = "Prahlad Nagar, Ahmedabad, Gujarat, India";
        GrandTotal = "294.45";
        Id = 6;
        ModelId = 2;
        NightFare = 0;
        NightFareApplicable = 0;
        PassengerId = 29;
        PaymentStatus = "";
        PaymentType = cash;
        PickupLat = "23.0712832";
        PickupLng = "72.5182444";
        PickupLocation = "Science City Road, Panchamrut Bunglows II, Ahmedabad, Gujarat, India";
        PickupTime = 1509784473;
        PromoCode = "";
        Reason = "";
        Status = completed;
        SubTotal = "292.45";
        Tax = "29.245";
        TollFee = 0;
        TransactionId = "";
        TripDistance = 100;
        TripDuration = "";
        TripFare = "292.45";
        WaitingTime = "";
        WaitingTimeCost = 0;
    };
    status = 1;
}
*/
/*
[{
    BookingInfo =     (
        {
            AdminAmount = "5.71";
            BookingCharge = "2.2";
            CompanyAmount = "31.55";
            CompanyId = 1;
            CompanyTax = "";
            CreatedDate = "2017-11-13T04:39:19.000Z";
            Discount = 0;
            DriverId = 20;
            DropTime = 1510572098;
            DropoffLocation = "Iscon Mega Mall, Ahmedabad, Gujarat, India";
            FlightNumber = "";
            GrandTotal = "37.25";
            Id = 1;
            ModelId = 4;
            NightFare = 0;
            NightFareApplicable = 0;
            PassengerContact = 9898989898;
            PassengerId = 29;
            PassengerName = "Ganpat Developer";
            PassengerType = myself;
            PaymentStatus = "";
            PaymentType = cash;
            PickupDate = "2017-11-13T00:00:00.000Z";
            PickupDateTime = "2017-11-13T17:30:00.000Z";
            PickupLocation = "Excellent WebWorld - iPhone | Android Mobile App Development Company, Ahmedabad, Gujarat, India";
            PickupTime = 1510572087;
            PromoCode = "";
            Reason = "";
            Status = pending;
            SubTotal = "35.05";
            Tax = "3.73";
            TollFee = 0;
            TransactionId = "";
            TripDistance = "0.001";
            TripDuration = 11;
            TripFare = 35;
            WaitingTime = 3;
            WaitingTimeCost = "0.05";
        }
    );
    type = BookingInfo;
    }]
*/
/*
{
    info =     {
        AdminAmount = "";
        BookingCharge = "";
        BookingType = "";
        ByDriverAmount = "";
        ByDriverId = 0;
        CompanyAmount = "";
        CompanyId = 1;
        CompanyTax = "";
        CreatedDate = "2017-11-20 07:32:32";
        Discount = "";
        DriverId = 0;
        DropOffLat = "23.0263517";
        DropOffLon = "72.5819013";
        DropTime = "";
        DropoffLocation = "Lal Darwaja, Ahmedabad, Gujarat, India";
        FlightNumber = "";
        GrandTotal = "";
        Id = 49;
        ModelId = 1;
        NightFare = "";
        NightFareApplicable = 0;
        PassengerContact = 9898989898;
        PassengerEmail = "";
        PassengerId = 29;
        PassengerName = "Ganpat Developer";
        PassengerType = myself;
        PaymentStatus = "";
        PaymentType = "";
        PickupDate = "2017-11-20";
        PickupDateTime = "2017-11-20 19:55:00";
        PickupLat = "23.0714566";
        PickupLng = "72.5161168";
        PickupLocation = "119, Science City Rd, Sola, Ahmedabad, Gujarat 380060, India";
        PickupTime = "";
        PromoCode = "";
        Reason = "";
        Status = pending;
        SubTotal = "";
        Tax = "";
        TollFee = "";
        TransactionId = "";
        TripDistance = "9.8";
        TripDuration = 1740;
        TripFare = "";
        WaitingTime = "";
        WaitingTimeCost = "";
    };
    message = "Thank you for accept request";
    status = 1;
}
*/

/*
//  MARK: CurrentBooking/21

{
    "status": true,
    "booking": {
        "Id": "16",
        "PassengerId": "29",
        "ModelId": "4",
        "DriverId": "21",
        "CreatedDate": "2017-11-22 11:17:00",
        "TransactionId": "",
        "PaymentStatus": "",
        "PickupTime": "",
        "DropTime": "",
        "TripDuration": "",
        "TripDistance": "",
        "PickupLocation": "119, Science City Rd, Sola, Ahmedabad, Gujarat 380060, India",
        "DropoffLocation": "Iscon Mega Mall, Ahmedabad, Gujarat, India",
        "NightFareApplicable": "0",
        "NightFare": "",
        "TripFare": "",
        "WaitingTime": "",
        "WaitingTimeCost": "",
        "TollFee": "",
        "BookingCharge": "",
        "Tax": "",
        "PromoCode": "",
        "Discount": "",
        "SubTotal": "",
        "GrandTotal": "",
        "Status": "accepted",
        "Reason": "",
        "PaymentType": "",
        "ByDriverAmount": "",
        "AdminAmount": "",
        "CompanyAmount": "",
        "PickupLat": "23.072728",
        "PickupLng": "72.516391",
        "DropOffLat": "23.030245999999998",
        "DropOffLon": "72.508699",
        "BookingType": "",
        "ByDriverId": "0",
        "PassengerName": "",
        "PassengerContact": "",
        "PassengerEmail": "",
        "PassengerInfo": {
            "Id": "29",
            "Fullname": "Ganpat Developer",
            "Email": "ganpat@excellentwebworld.info",
            "Password": "25d55ad283aa400af464c76d713c07ad",
            "MobileNo": "9898989898",
            "Image": "images/passenger/Image10",
            "Gender": "female",
            "Address": "excellent web world",
            "DeviceType": "2",
            "Token": "c-RJY1_r2m4:APA91bGppD3jIVLWS6e1p2L9XWa7v2LMB23nODYfgdESKOQjYseJDcBBrTtu7RkdVYVII2pJg3M75aGfxLufj4CqUFgSQA2hz4Qs19-MaXMM7opbwDDA7n7in4_rOWnDal00FUCjYM1p",
            "Lat": "23.072715",
            "Lng": "72.51639",
            "Status": "1",
            "CreatedDate": "2017-11-04 11:53:00"
        }
    }
}
*/

/*

self.aryPassengerData = NSArray(array: data)
self.BottomButtonView.isHidden = false

let BookingInfo : NSDictionary!//= (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
let PassengerInfo: NSDictionary!// = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "PassengerInfo") as! NSArray).object(at: 0) as! NSDictionary

if((((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) == nil)
{
    print("Yes its  array ")
    BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
    PassengerInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "PassengerInfo") as! NSArray).object(at: 0) as! NSDictionary
    
}
else
{
    print("Yes its dictionary")
    BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
    PassengerInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "PassengerInfo") as! NSDictionary)//.object(at: 0) as! NSDictionary
}
*/

/*

// MARK: Switch ON or OFF

// TRUE
{
    duty = off;
    location = 1;
    message = "Shift duty is off";
    status = 1;
}

{
    duty = on;
    location = 1;
    message = "Shift duty is on";
    status = 1;
}

// FALSE

-> OFF to ON
Response status code was unacceptable: 500.
 
-> ON to OFF
Response status code was unacceptable: 500.
 
*/

/*
{
    earning =     {
        dispatch =         {
            Fri = 0;
            Mon = 0;
            Sat = 0;
            Sun = 0;
            Thu = 0;
            Tue = 0;
            Wed = 0;
        };
        rides =         {
            Fri = 0;
            Mon = "102.8";
            Sat = "236.18";
            Sun = 0;
            Thu = "45.72";
            Tue = "310.6";
            Wed = "184.41";
        };
        tickpay =         {
            Fri = "0.00";
            Mon = "0.00";
            Sat = "0.00";
            Sun = "0.00";
            Thu = "0.00";
            Tue = "0.02";
            Wed = "0.00";
        };
        total =         {
            Fri = 0;
            Mon = "102.8";
            Sat = "236.18";
            Sun = 0;
            Thu = "45.72";
            Tue = "310.62";
            Wed = "184.41";
        };
    };
    "end_date" = "2017-12-29";
    "start_date" = "2017-12-23";
    status = 1;
    "total_earing" = "879.73";
}
*/
