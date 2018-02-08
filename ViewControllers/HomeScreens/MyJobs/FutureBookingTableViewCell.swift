//
//  FutureBookingTableViewCell.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 16/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class FutureBookingTableViewCell: UITableViewCell {

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
    
    @IBOutlet weak var lblPassengerName: UILabel!
    @IBOutlet weak var lblTripId: UILabel!
    
    @IBOutlet weak var lblTimeAndDateAtTop: UILabel!
    

    @IBOutlet weak var lblDropOffLocation: UILabel!
    @IBOutlet weak var lblDropOffLocationDesc: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var btnAction: UIButton!
    
    
    @IBOutlet weak var viewSecond: UIView!
    
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblPassengerNoDesc: UILabel!
    @IBOutlet weak var lblTripDestanceDesc: UILabel!
    @IBOutlet weak var lblCarModelDesc: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblFlightNumber: UILabel!
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
