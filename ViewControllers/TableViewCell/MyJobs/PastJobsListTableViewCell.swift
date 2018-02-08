//
//  PastJobsListTableViewCell.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 15/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class PastJobsListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    // First View height is : 86.5
    
    // Total cell Height is : 301.5
    
    @IBOutlet weak var lblPassengerName: UILabel!
    @IBOutlet weak var lblTripID: UILabel!
    
    @IBOutlet weak var lblDropoffLocation: UILabel!
    @IBOutlet weak var lblDropoffLocationDescription: UILabel!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var viewAllDetails: UIView! // HEIGHT IS : 215
    
    @IBOutlet weak var lblPickupLocationDesc: UILabel!
    @IBOutlet weak var lblpassengerEmail: UILabel!
    @IBOutlet weak var lblPassengerNo: UILabel!
    @IBOutlet weak var lblPickupTime: UILabel!
    @IBOutlet weak var lblDropOffTimeDesc: UILabel!
    @IBOutlet weak var lblTripDistanceDesc: UILabel!
    @IBOutlet weak var lbltripDurationDesc: UILabel!
    @IBOutlet weak var lblCarModelDesc: UILabel!
    @IBOutlet weak var lblNightFareDesc: UILabel!
    @IBOutlet weak var lblTripFareDesc: UILabel!
    @IBOutlet weak var lblWaitingTimeCostDesc: UILabel!
    @IBOutlet weak var lblTollFeeDesc: UILabel!
    @IBOutlet weak var lblBokingChargeDesc: UILabel!
    @IBOutlet weak var lblTaxDesc: UILabel!
    @IBOutlet weak var lblDiscountDesc: UILabel!
    @IBOutlet weak var lblSubTotalDesc: UILabel!
    @IBOutlet weak var lblGrandTotalDesc: UILabel!
    
    @IBOutlet weak var txtPaymentType: UILabel!
    @IBOutlet weak var lblFlightNumber: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var lblTripStatus: UILabel!
    
    
    
    @IBOutlet var lblDispatcherName: UILabel!
    @IBOutlet var lblDispatcherEmail: UILabel!
    @IBOutlet var lblDispatcherNumber: UILabel!
    
    @IBOutlet var lblDispatcherNameTitle: UILabel!
    @IBOutlet var lblDispatcherEmailTitle: UILabel!
    @IBOutlet var lblDispatcherNumberTitle: UILabel!
    
    
    @IBOutlet var stackViewEmail: UIStackView!
    @IBOutlet var stackViewName: UIStackView!
    @IBOutlet var stackViewNumber: UIStackView!

}
