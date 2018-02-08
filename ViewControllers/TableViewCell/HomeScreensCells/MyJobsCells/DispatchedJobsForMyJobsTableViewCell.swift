//
//  DispatchedJobsForMyJobsTableViewCell.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 14/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class DispatchedJobsForMyJobsTableViewCell: UITableViewCell {

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
    
    
    @IBOutlet weak var viewDetails: UIView!
    
    
    @IBOutlet var lblDriversNames: UILabel!

    @IBOutlet var lblDropLocationDescription: UILabel!
    @IBOutlet var lblDateAndTime: UILabel!
    @IBOutlet var lblPickUpLocationDescription: UILabel!
    
    @IBOutlet weak var lblPassengerEmail: UILabel!
    @IBOutlet weak var lblPassengerNumber: UILabel!
    
    @IBOutlet var lblPassengerFlightNo: UILabel!
    @IBOutlet var lblPassengerNotes: UILabel!
    
    
    @IBOutlet weak var lblCarModel: UILabel!
    
    @IBOutlet weak var lblTripDistance: UILabel!
    @IBOutlet weak var lblTripFare: UILabel!
    
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    
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
