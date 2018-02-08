//
//  ReceiveRequestViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 06/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SRCountdownTimer
import NVActivityIndicatorView

class ReceiveRequestViewController: UIViewController, SRCountdownTimerDelegate {

    @IBOutlet weak var viewCountdownTimer: SRCountdownTimer!
    var isAccept : Bool!
    var delegate: ReceiveRequestDelegate!
    
//    @IBOutlet var constratintHorizontalSpaceBetweenButtonAndTimer: NSLayoutConstraint!
    
    var strPickupLocation = String()
    var strDropoffLocation = String()
    var strGrandTotal = String()
    
    var strFlightNumber = String()
    var strNotes = String()
    
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CountDownView()
        
        btnReject.layer.cornerRadius = 5
        btnReject.layer.masksToBounds = true
        
        btnAccepted.layer.cornerRadius = 5
        btnAccepted.layer.masksToBounds = true
        
        boolTimeEnd = false
        isAccept = false
        
//        self.playSound()
        
        fillAllFields()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CountDownView() {
        
        viewCountdownTimer.labelFont = UIFont(name: "HelveticaNeue-Light", size: 50.0)
        //                    self.timerView.timerFinishingText = "End"
        viewCountdownTimer.lineWidth = 4
        viewCountdownTimer.lineColor = UIColor.gray
        viewCountdownTimer.trailLineColor = UIColor.red
        viewCountdownTimer.labelTextColor = UIColor.white
        viewCountdownTimer.delegate = self
        viewCountdownTimer.start(beginingValue: 30, interval: 1)
        lblMessage.text = "New booking request arrived from TiCKTOC"
        
    }
    
    func fillAllFields() {
        
        if Singletons.sharedInstance.passengerType == "" {
            
            viewDetails.isHidden = true
            
            lblGrandTotal.isHidden = true
//            constratintHorizontalSpaceBetweenButtonAndTimer.priority = 1000
//            stackViewFlightNumber.isHidden = true
//            stackViewNotes.isHidden = true
        }
        else {
            viewDetails.isHidden = false
            print(strGrandTotal)
            print(strPickupLocation)
            print(strDropoffLocation)
            print(strFlightNumber)
            print(strNotes)
            lblGrandTotal.text = "Grand Total is $\(strGrandTotal)"
            lblPickupLocation.text = strPickupLocation
            lblDropoffLocation.text = strDropoffLocation
            
//            if strFlightNumber.count == 0 {
//                stackViewFlightNumber.isHidden = true
//            }
//            else {
//                stackViewFlightNumber.isHidden = false
//                lblFlightNumber.text = strFlightNumber
//            }
//
//            if strNotes.count == 0 {
//                stackViewNotes.isHidden = true
//            }
//            else {
//                stackViewNotes.isHidden = false
//                lblNotes.text = strNotes
//            }
        }
        
    }
    
    func timerDidEnd() {
        
        if (isAccept == false)
        {
            if (boolTimeEnd) {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                self.delegate.didRejectedRequest()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Sound Implement Methods
    //-------------------------------------------------------------
    
    var audioPlayer:AVAudioPlayer!
    
    func playSound() {
        
        guard let url = Bundle.main.url(forResource: "ringTone", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            //            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.numberOfLoops = -1
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
    

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
   
    @IBOutlet weak var viewRequestReceive: UIView!
    
    @IBOutlet weak var lblReceiveRequest: UILabel!
    
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropoffLocation: UILabel!
    
//    @IBOutlet weak var lblFlightNumber: UILabel!
//    @IBOutlet weak var lblNotes: UILabel!
    
//    @IBOutlet weak var stackViewFlightNumber: UIStackView!
    
//    @IBOutlet weak var stackViewNotes: UIStackView!
    
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccepted: UIButton!
    
    @IBOutlet weak var viewDetails: UIView!
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    var boolTimeEnd = Bool()
    
    @IBAction func btnRejected(_ sender: UIButton) {
        
         Singletons.sharedInstance.firstRequestIsAccepted = false
        isAccept = false
        boolTimeEnd = true
        delegate.didRejectedRequest()
        self.viewCountdownTimer.end()
//        self.stopSound()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnAcceped(_ sender: UIButton) {
        
         Singletons.sharedInstance.firstRequestIsAccepted = false
        
        isAccept = true
        boolTimeEnd = true
        delegate.didAcceptedRequest()
        self.viewCountdownTimer.end()
        self.stopSound()
        self.dismiss(animated: true, completion: nil)
    }
    // ------------------------------------------------------------
    

    

}
