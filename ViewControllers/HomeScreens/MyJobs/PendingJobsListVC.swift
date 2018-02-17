//
//  PendingJobsListVC.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 14/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SocketIO

class PendingJobsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
//    let socket = UtilityClass.socketManager()
    
    
    
    //-------------------------------------------------------------
    // MARK: - Global Declaration
    //-------------------------------------------------------------
//    let activityData = ActivityData()
 @IBOutlet weak var tableView: UITableView!
    var aryData = NSArray()
    var aryPendingJobs = NSMutableArray()
  
    var isSelectedIndex = Int()
    
    var selectedCellIndexPath: IndexPath?
    let selectedCellHeight: CGFloat = 158.5
    let unselectedCellHeight: CGFloat = 81
    
    var isVisible: Bool = true
    
    var labelNoData = UILabel()
    
    lazy var refreshControl: UIRefreshControl =
        {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    func dismissSelf() {
        
        self.navigationController?.popViewController(animated: true)
        
        
//        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
       // UtilityClass.showACProgressHUD()
        
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        
        labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.labelNoData.text = "Loading..."
        labelNoData.textAlignment = .center
        self.view.addSubview(labelNoData)
        self.tableView.isHidden = true
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.tableView.addSubview(self.refreshControl)
        
     
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        webserviceofPendingJobs()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func loadView() {
        super.loadView()
        
//        let activityData = ActivityData()
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {

        webserviceofPendingJobs()
        tableView.reloadData()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
   
    
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return aryPendingJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
  
        let cell = tableView.dequeueReusableCell(withIdentifier: "PendingJobsListTableViewCell") as! PendingJobsListTableViewCell
        //        let cell2 = tableView.dequeueReusableCell(withIdentifier: "NoDataFound") as! PendingJobsListTableViewCell
        
        cell.selectionStyle = .none
        
        let data = aryPendingJobs.object(at: indexPath.row) as! NSDictionary

        cell.lblPassengerName.text = data.object(forKey: "PassengerName") as? String

        if let TimeAndDate: String = data.object(forKey: "PickupDateTime") as? String {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date = dateFormatter.date(from: TimeAndDate)
            
            
            dateFormatter.dateFormat = "HH:mm dd/MM/YYYY"///this is what you want to convert format
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let timeStamp = dateFormatter.string(from: date!)
            
            cell.lblTimeAndDateAtTop.text = "\(timeStamp)"
        }

        //        cell.lblDropoffLocation.text = ""
        cell.lblDropoffLocationDescription.text = data.object(forKey: "PickupLocation") as? String // DropoffLocation
        cell.lblDateAndTime.text = data.object(forKey: "CreatedDate") as? String
        
        cell.lblPickupLocationDesc.text = data.object(forKey: "DropoffLocation") as? String // PickupLocation
        cell.lblpassengerEmailDesc.text = data.object(forKey: "PassengerEmail") as? String
        cell.lblPassengerNoDesc.text = data.object(forKey: "PassengerContact") as? String
        cell.lblPickupTimeDesc.text = data.object(forKey: "PickupDateTime") as? String
        cell.lblCarModelDesc.text = data.object(forKey: "Model") as? String
        cell.lblFlightNumber.text = data.object(forKey: "FlightNumber") as? String
        cell.lblNotes.text = data.object(forKey: "Notes") as? String
        cell.lblPaymentType.text = data.object(forKey: "PaymentType") as? String
        cell.btnStartTrip.tag = Int((data.object(forKey: "Id") as? String)!)!
        cell.btnStartTrip.addTarget(self, action: #selector(self.strtTrip(sender:)), for: .touchUpInside)
        
        cell.viewAllDetails.isHidden = !expandedCellPaths.contains(indexPath)
        
        
        cell.lblDispatcherName.text = ""
        cell.lblDispatcherEmail.text = ""
        cell.lblDispatcherNumber.text = ""
        cell.lblDispatcherNameTitle.text = ""
        cell.lblDispatcherEmailTitle.text = ""
        cell.lblDispatcherNumberTitle.text = ""
        
        
        cell.stackViewEmail.isHidden = true
        cell.stackViewName.isHidden = true
        cell.stackViewNumber.isHidden = true
        
        if((data.object(forKey: "DispatcherDriverInfo")) != nil)
        {
            print("There is driver info and passengger name is \(String(describing: cell.lblPassengerName.text))")
            
            cell.lblDispatcherName.text = (data.object(forKey: "DispatcherDriverInfo") as? [String:AnyObject])!["Email"] as? String
            cell.lblDispatcherEmail.text = (data.object(forKey: "DispatcherDriverInfo") as? [String:AnyObject])!["Fullname"] as? String
            cell.lblDispatcherNumber.text = (data.object(forKey: "DispatcherDriverInfo") as? [String:AnyObject])!["MobileNo"] as? String
            cell.lblDispatcherNameTitle.text = "DISPACTHER NAME"
            cell.lblDispatcherEmailTitle.text = "DISPATCHER EMAIL"
            cell.lblDispatcherNumberTitle.text = "DISPATCHER TITLE"
            
            cell.stackViewEmail.isHidden = false
            cell.stackViewName.isHidden = false
            cell.stackViewNumber.isHidden = false
        }
        
        return cell
    }

    
    var expandedCellPaths = Set<IndexPath>()

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let cell = tableView.cellForRow(at: indexPath) as? PendingJobsListTableViewCell {
            cell.viewAllDetails.isHidden = !cell.viewAllDetails.isHidden
            if cell.viewAllDetails.isHidden {
                expandedCellPaths.remove(indexPath)
            } else {
                expandedCellPaths.insert(indexPath)
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            //            tableView.deselectRow(at: indexPath, animated: true)
        }
      
    }
  
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceofPendingJobs() {
        
        let driverID = Singletons.sharedInstance.strDriverID
        
        webserviceForBookingHistry(driverID as AnyObject) { (result, status) in
            
            if (status)
            {
                print(result)
                
                self.aryData = ((result as! NSDictionary).object(forKey: "history") as! NSArray)
                self.getPendingJobs()
                
                if(self.aryPendingJobs.count == 0)
                {
                    self.labelNoData.text = "Please check back later"
                    self.tableView.isHidden = true
                }
                else
                {
                    self.labelNoData.removeFromSuperview()
                    
                    if self.tableView != nil
                    {
                    self.tableView.isHidden = false
                    }
                    else
                    {
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.isHidden = false
                    }
                }
                
                self.tableView.reloadData()
            //    UtilityClass.hideACProgressHUD()

            }
            else {
                print(result)
                
                if let res: String = result as? String {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else {
                    UtilityClass.showAlert(appName.kAPPName, message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
                
        //        UtilityClass.hideACProgressHUD()

            }
        }
    }
    
    func getPendingJobs() {
        
         aryPendingJobs.removeAllObjects()
        refreshControl.endRefreshing()
        for i in 0..<aryData.count {
            
            let dataOfAry = (aryData.object(at: i) as! NSDictionary)
            
            let strHistoryType = dataOfAry.object(forKey: "HistoryType") as! String
            
            if strHistoryType == "onGoing" {
                self.aryPendingJobs.add(dataOfAry)

            }
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Socket: Notify Passenger For Advance Trip
    //-------------------------------------------------------------
    
    func strtTrip(sender: UIButton)
    {
        
        let bookingID = String((sender.tag))
        
        Singletons.sharedInstance.strPendinfTripData = bookingID
        
        let alert = UIAlertController(title: nil, message: "Your trip is on there way.", preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
            
//            Singletons.sharedInstance.isBackFromPending = true
            let myJobs = (self.navigationController?.childViewControllers[0] as! TabbarController).childViewControllers.last as! MyJobsViewController
            
            myJobs.callSocket()
//            self.navigationController?.popViewController(animated: true)
            
            
//            self.dismiss(animated: true, completion: nil)
            self.tabBarController?.selectedIndex = 0
            
//        self.navigationController?.popViewController(animated: true)
       
        })
        
        alert.addAction(OK)
        
        self.present(alert, animated: true, completion: nil)

    }
  
}


