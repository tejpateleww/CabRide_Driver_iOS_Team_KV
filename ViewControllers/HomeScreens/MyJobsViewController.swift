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
    
    @IBOutlet var viewSelection: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var btnFutureBooking: UIButton!
    
    @IBOutlet var btnPendingJobs: UIButton!
    
    @IBOutlet var btnPastJobs: UIButton!
    
    @IBOutlet var constrainSelectionX_position: NSLayoutConstraint!
    var pageControl = UIPageControl()
    
//    @IBOutlet var Conmmstain_btnStackViewY_posistion: NSLayoutConstraint!
//
//    @IBOutlet var constrasin_viewSelection_y_position: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crnRadios = 20
        shadowOpacity = 0.2
        shadowRadius = 1
        shadowOffsetWidth = 0
        shadowOffsetHeight = 1
        
//        giveCornorRadiosToView()
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
        self.navigationController?.isNavigationBarHidden = true

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
    
    /*func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let pageWidth : CGFloat = scrollView.frame.size.width
        let page : Int  = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        //        pageControl.currentPage = page

        if page == 0
        {
            btnFutureBooking.isSelected = true
            btnPendingJobs.isSelected = false
            btnPastJobs.isSelected = false
            self.constrainSelectionX_position.constant = 0


            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self.btnFutureBooking.setTitleColor(UIColor.white, for: .normal)
                self.btnPendingJobs.setTitleColor(UIColor.lightGray, for: .normal)
                self.btnPastJobs.setTitleColor(UIColor.lightGray, for: .normal)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else if page == 1
        {
            btnFutureBooking.isSelected = false
            btnPendingJobs.isSelected = true
            btnPastJobs.isSelected = false
            self.constrainSelectionX_position.constant = self.btnPendingJobs.frame.size.width


            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self.btnFutureBooking.setTitleColor(UIColor.lightGray, for: .normal)
                self.btnPendingJobs.setTitleColor(UIColor.white, for: .normal)
                self.btnPastJobs.setTitleColor(UIColor.lightGray, for: .normal)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else
        {
            btnFutureBooking.isSelected = false
            btnPendingJobs.isSelected = false
            btnPastJobs.isSelected = true

            self.constrainSelectionX_position.constant = self.btnPastJobs.frame.size.width*2


            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self.btnFutureBooking.setTitleColor(UIColor.lightGray, for: .normal)
                self.btnPendingJobs.setTitleColor(UIColor.lightGray, for: .normal)
                self.btnPastJobs.setTitleColor(UIColor.white, for: .normal)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    */
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    
//     @IBOutlet var btnPending: UIButton!
//    @IBOutlet var viewDispatchedJobs: UIView!
//    @IBOutlet var viewPastJobs: UIView!
//    @IBOutlet var viewFutureJobs: UIView!
//    @IBOutlet var viewPendingJobs: UIView!
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------

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
    @IBAction func btnFutureBookingClicked(_ sender: Any)
    {
        btnFutureBooking.isSelected = true
        btnPendingJobs.isSelected = false
        btnPastJobs.isSelected = false
        self.constrainSelectionX_position.constant = 0
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations:
            {
                
                self.btnFutureBooking.setTitleColor(ThemeYellowColor, for: .normal)
                self.btnPendingJobs.setTitleColor(ThemeGrayColor, for: .normal)
                self.btnPastJobs.setTitleColor(ThemeGrayColor, for: .normal)
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                
                self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func btnPendingJobsClicked(_ sender: Any)
    {
        btnFutureBooking.isSelected = false
        btnPendingJobs.isSelected = true
        btnPastJobs.isSelected = false
        self.constrainSelectionX_position.constant = self.btnPendingJobs.frame.size.width
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            
            self.btnFutureBooking.setTitleColor(ThemeGrayColor, for: .normal)
            self.btnPendingJobs.setTitleColor(ThemeYellowColor, for: .normal)
            self.btnPastJobs.setTitleColor(ThemeGrayColor, for: .normal)
            self.scrollView.contentOffset = CGPoint(x: self.view.frame.size.width, y: 0)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func btnPastJobsClicked(_ sender: Any)
    {
        btnFutureBooking.isSelected = false
        btnPendingJobs.isSelected = false
        btnPastJobs.isSelected = true
        
        self.constrainSelectionX_position.constant = self.btnPastJobs.frame.size.width*2
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations:
            {
            
            self.btnFutureBooking.setTitleColor(ThemeGrayColor, for: .normal)
                self.btnPendingJobs.setTitleColor(ThemeGrayColor, for: .normal)
            self.btnPastJobs.setTitleColor(ThemeYellowColor, for: .normal)
            self.scrollView.contentOffset = CGPoint(x: self.view.frame.size.width * 2, y: 0)
            self.view.layoutIfNeeded()
        }, completion: nil)
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

