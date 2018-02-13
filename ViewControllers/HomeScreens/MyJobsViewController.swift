//
//  MyJobsViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 12/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class MyJobsViewController: ParentViewController {

    var crnRadios = CGFloat()
    var shadowOpacity = Float()
    var shadowRadius = CGFloat()
    var shadowOffsetWidth = Int()
    var shadowOffsetHeight = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crnRadios = 20
        shadowOpacity = 0.2
        shadowRadius = 1
        shadowOffsetWidth = 0
        shadowOffsetHeight = 1
        
        giveCornorRadiosToView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMyJobs(segue:UIStoryboardSegue) {
        
//        self.btnPendingJobs(btnPending)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Singletons.sharedInstance.isPresentVC == true {
        
            let PendingJobsList = self.storyboard?.instantiateViewController(withIdentifier: "PendingJobsListVC") as! PendingJobsListVC
            
            Singletons.sharedInstance.isPresentVC = false

            self.navigationController?.pushViewController(PendingJobsList, animated: true)
        }
        
        if Singletons.sharedInstance.isBackFromPending == true {
            
            Singletons.sharedInstance.isBackFromPending = false
            
            self.callSocket()
            
        }
        
        if Singletons.sharedInstance.isFromNotification == true {
            Singletons.sharedInstance.isFromNotification = false
            self.btnFutureBookings(UIButton.init())
            
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    
     @IBOutlet var btnPending: UIButton!
    @IBOutlet var viewDispatchedJobs: UIView!
    @IBOutlet var viewPastJobs: UIView!
    @IBOutlet var viewFutureJobs: UIView!
    @IBOutlet var viewPendingJobs: UIView!
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func giveCornorRadiosToView()
    {
        viewDispatchedJobs.layer.cornerRadius = crnRadios
        viewPastJobs.layer.cornerRadius = crnRadios
        viewFutureJobs.layer.cornerRadius = crnRadios
        viewPendingJobs.layer.cornerRadius = crnRadios
        
       
        viewDispatchedJobs.layer.shadowOpacity = shadowOpacity
        viewDispatchedJobs.layer.shadowRadius = shadowRadius
        viewDispatchedJobs.layer.shadowColor = UIColor.black.cgColor
        viewDispatchedJobs.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        
        viewPastJobs.layer.shadowOpacity = shadowOpacity
        viewPastJobs.layer.shadowRadius = shadowRadius
        viewPastJobs.layer.shadowColor = UIColor.black.cgColor
        viewPastJobs.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        
        viewFutureJobs.layer.shadowOpacity = shadowOpacity
        viewFutureJobs.layer.shadowRadius = shadowRadius
        viewFutureJobs.layer.shadowColor = UIColor.black.cgColor
        viewFutureJobs.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        
        viewPendingJobs.layer.shadowOpacity = shadowOpacity
        viewPendingJobs.layer.shadowRadius = shadowRadius
        viewPendingJobs.layer.shadowColor = UIColor.black.cgColor
        viewPendingJobs.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        

        viewDispatchedJobs.layer.masksToBounds = false
        viewPastJobs.layer.masksToBounds = false
        viewFutureJobs.layer.masksToBounds = false
        viewPendingJobs.layer.masksToBounds = false
 
    }
    
    @IBAction func btnDispatchedJobs(_ sender: UIButton) {
        

        let dispatchJobs = self.storyboard?.instantiateViewController(withIdentifier: "DispatchedJobsForMyJobsVC") as! DispatchedJobsForMyJobsVC

        self.navigationController?.pushViewController(dispatchJobs, animated: true)
//        self.navigationController?.present(dispatchJobs, animated: true, completion: nil)
//         (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(dispatchJobs, animated: true, completion: nil)

    }
    @IBAction func btnPastJobs(_ sender: UIButton) {
        
        let PastJobsList = self.storyboard?.instantiateViewController(withIdentifier: "PastJobsListVC") as! PastJobsListVC

        self.navigationController?.pushViewController(PastJobsList, animated: true)
        
//        self.navigationController?.present(PastJobsList, animated: true, completion: nil)
        
     
    }
    @IBAction func btnFutureBookings(_ sender: UIButton) {
        
        let FutureBooking = self.storyboard?.instantiateViewController(withIdentifier: "FutureBookingVC") as! FutureBookingVC
        
        self.navigationController?.pushViewController(FutureBooking, animated: true)
    
//        self.navigationController?.present(FutureBooking, animated: true, completion: nil)
        
    }
    
    @IBAction func btnPendingJobs(_ sender: UIButton) {

        let PendingJobsList = self.storyboard?.instantiateViewController(withIdentifier: "PendingJobsListVC") as! PendingJobsListVC
        
        self.navigationController?.pushViewController(PendingJobsList, animated: true)
        
//        self.navigationController?.present(PendingJobsList, animated: true, completion: nil)
       
        
    }
    
    func callSocket() {
        
//        let socket = (((self.navigationController?.childViewControllers[0] as! TabbarController).childViewControllers)[0] as! ContentViewController).socket
        
        
        let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
        
        var isAdvance = (((self.navigationController?.childViewControllers[0] as! TabbarController).childViewControllers)[0] as! HomeViewController).isAdvanceBooking
        isAdvance = true
        
       
        let ttabbar = (self.navigationController?.childViewControllers[0] as! TabbarController)
        ttabbar.selectedIndex = 0
        
        let myJSON = ["DriverId" : Singletons.sharedInstance.strDriverID, "BookingId" : Singletons.sharedInstance.strPendinfTripData] as [String : Any]
        socket.emit("NotifyPassengerForAdvancedTrip", with: [myJSON])
        
        print("Start Trip : \(myJSON)")
    }

}

