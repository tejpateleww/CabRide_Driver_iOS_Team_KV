//
//  TripInfoCompletedTripVC.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 06/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class TripInfoCompletedTripVC: UIViewController {
    var delegate: CompleterTripInfoDelegate!
    
    var dictData = NSDictionary()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        if Singletons.sharedInstance.pasengerFlightNumber == "" {
            stackViewFlightNumber.isHidden = true
        }
        else {
            lblFlightNumber.text = Singletons.sharedInstance.pasengerFlightNumber
            stackViewFlightNumber.isHidden = false
        }
        
        if Singletons.sharedInstance.passengerNote == "" {
            stackViewNote.isHidden = true
        }
        else {
            lblNote.text = Singletons.sharedInstance.passengerNote
            stackViewNote.isHidden = false
        }
        
        setData()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnViewCompleteTripData.layer.cornerRadius = 10
        btnViewCompleteTripData.layer.masksToBounds = true
        
        
        btnOK.layer.cornerRadius = 10
        btnOK.layer.masksToBounds = true
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
   
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropOffLocation: UILabel!
    
    @IBOutlet weak var lblTripFare: UILabel!     // as Base Fare
    @IBOutlet weak var lblDistanceFare: UILabel!
    
    @IBOutlet weak var lblNightFare: UILabel!
    @IBOutlet weak var lblWaitingTimeCost: UILabel!
    @IBOutlet weak var lblTollFree: UILabel!
    @IBOutlet weak var lblBookingCharge: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet var btnViewCompleteTripData: UIView!
    
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    @IBOutlet weak var lblFlightNumber: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    
    @IBOutlet weak var stackViewFlightNumber: UIStackView!
    @IBOutlet weak var stackViewNote: UIStackView!
    
    // ------------------------------------------------------------
    
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setData() {
        
        dictData = NSMutableDictionary(dictionary: (dictData.object(forKey: "details") as! NSDictionary))
        lblPickupLocation.text = dictData.object(forKey: "PickupLocation") as? String
        lblDropOffLocation.text = dictData.object(forKey: "DropoffLocation") as? String
        lblTollFree.text = dictData.object(forKey: "TollFee") as? String
        lblGrandTotal.text = dictData.object(forKey: "CompanyAmount") as? String
        
    }
    

    
    @IBOutlet weak var btnOK: UIButton!
    
    @IBAction func btnOK(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.delegate.didRatingCompleted()

    }
    
}
