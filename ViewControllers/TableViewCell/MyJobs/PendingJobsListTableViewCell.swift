//
//  PendingJobsListTableViewCell.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 15/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class PendingJobsListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnStartTrip.layer.cornerRadius = 5
        btnStartTrip.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    // total Cell Height is 158.5
    
    // First View height is 81
    
    @IBOutlet weak var btnStartTrip: UIButton!
    
    @IBOutlet weak var lblPassengerName: UILabel!
    
    @IBOutlet weak var lblTimeAndDateAtTop: UILabel!
    
    
    @IBOutlet weak var lblDropoffLocation: UILabel!
    @IBOutlet weak var lblDropoffLocationDescription: UILabel!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var viewAllDetails: UIView! // Height is 72
    
    @IBOutlet weak var lblPickupLocationDesc: UILabel!
    @IBOutlet weak var lblpassengerEmailDesc: UILabel!
    @IBOutlet weak var lblPassengerNoDesc: UILabel!
    @IBOutlet weak var lblPickupTimeDesc: UILabel!
    @IBOutlet weak var lblCarModelDesc: UILabel!
    
    @IBOutlet weak var lblFlightNumber: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    

    
    
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
