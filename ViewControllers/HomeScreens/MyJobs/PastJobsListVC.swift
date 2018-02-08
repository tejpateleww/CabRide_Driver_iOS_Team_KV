//
//  PastJobsListVC.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 14/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView



class PastJobsListVC: ParentViewController, UITableViewDataSource, UITableViewDelegate {

    
    override func loadView() {
        super.loadView()
        
//        let activityData = ActivityData()
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Global Declaration
    //-------------------------------------------------------------
    
    var aryData = NSArray()
    var aryPastJobs = NSMutableArray()
    
    var selectedCellIndexPath: IndexPath?
    let selectedCellHeight: CGFloat = 350.5
    let unselectedCellHeight: CGFloat = 86.5
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
        
    func dismissSelf() {
        
        self.navigationController?.popViewController(animated: true)
        
        
//        self.dismiss(animated: true, completion: nil)
    }
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView?.btnBack.addTarget(self, action: #selector(self.dismissSelf), for: .touchUpInside)
        
        
        tableView.dataSource = self
        tableView.delegate = self
            
        self.labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.labelNoData.text = "Loading..."
        self.labelNoData.textAlignment = .center
        self.view.addSubview(self.labelNoData)
        self.tableView.isHidden = true
        
        self.tableView.tableFooterView = UIView()
        self.webserviceofPendingJobs()
        
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        self.tableView.addSubview(self.refreshControl)
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        
//        aryPastJobs.removeAllObjects()
        
        webserviceofPendingJobs()
        
        tableView.reloadData()
        
       
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    

    @IBOutlet weak var tableView: UITableView!
    

    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if section == 0 {
//
//            if aryPastJobs.count == 0 {
//                 return 1
//            }
//            else {
//                return aryPastJobs.count
//            }
//        }
//        else {
//            return 1
//        }
        
        return aryPastJobs.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PastJobsListTableViewCell") as! PastJobsListTableViewCell
//        let cell2 = tableView.dequeueReusableCell(withIdentifier: "NoDataFound") as! PastJobsListTableViewCell
        
        cell.selectionStyle = .none
//        cell2.selectionStyle = .none
        
//        if aryPastJobs.count != 0 {
//
//            if indexPath.section == 0 {
            
                let data = aryPastJobs.object(at: indexPath.row) as! NSDictionary
               
                //        cell.viewAllDetails.isHidden = true
//                cell.selectionStyle = .none
        
                cell.lblPassengerName.text = data.object(forKey: "PassengerName") as? String
                
                //        cell.lblDropoffLocation.text = data.object(forKey: "PassengerName") as? String
                cell.lblDropoffLocationDescription.text = data.object(forKey: "PickupLocation") as? String // DropoffLocation
                cell.lblDateAndTime.text = data.object(forKey: "CreatedDate") as? String
                
                cell.lblPickupLocationDesc.text = data.object(forKey: "DropoffLocation") as? String // PickupLocation
                cell.lblpassengerEmail.text = data.object(forKey: "PassengerEmail") as? String
                cell.lblPassengerNo.text = data.object(forKey: "PassengerMobileNo") as? String
//                cell.lblPickupTime.text = data.object(forKey: "PickupTime") as? String
                if let pickupTime = data.object(forKey: "PickupTime") as? String {
                    if pickupTime == "" {
                        cell.lblPickupTime.isHidden = true
//                        cell.stackViewPickupTime.isHidden = true
                    }
                    else {
                        cell.lblPickupTime.text = setTimeStampToDate(timeStamp: pickupTime)
                    }
                }
//                cell.lblDropOffTimeDesc.text = data.object(forKey: "DropTime") as? String
                if let DropoffTime = data.object(forKey: "DropTime") as? String {
                    if DropoffTime == "" {
                        cell.lblDropOffTimeDesc.isHidden = true
        //                cell.stackViewDropoffTime.isHidden = true
                    }
                    else {
                        cell.lblDropOffTimeDesc.text = setTimeStampToDate(timeStamp: DropoffTime)
                    }
                }
                cell.lblTripDistanceDesc.text = data.object(forKey: "TripDistance") as? String
                cell.lbltripDurationDesc.text = data.object(forKey: "TripDuration") as? String
                cell.lblCarModelDesc.text = data.object(forKey: "Model") as? String
                cell.lblNightFareDesc.text = data.object(forKey: "NightFare") as? String
                cell.lblTripFareDesc.text = data.object(forKey: "TripFare") as? String
                cell.lblWaitingTimeCostDesc.text = data.object(forKey: "WaitingTimeCost") as? String
                cell.lblTollFeeDesc.text = data.object(forKey: "TollFee") as? String
                cell.lblBokingChargeDesc.text = data.object(forKey: "BookingCharge") as? String
                cell.lblTaxDesc.text = data.object(forKey: "Tax") as? String
                cell.lblDiscountDesc.text = data.object(forKey: "Discount") as? String
                cell.lblSubTotalDesc.text = data.object(forKey: "SubTotal") as? String
                cell.lblGrandTotalDesc.text = data.object(forKey: "GrandTotal") as? String
                cell.txtPaymentType.text = data.object(forKey: "PaymentType") as? String
                cell.lblTripStatus.text = (data.object(forKey: "Status") as? String)?.uppercased()
                cell.lblFlightNumber.text = data.object(forKey: "FlightNumber") as? String
                cell.lblNotes.text = data.object(forKey: "Notes") as? String
                cell.txtPaymentType.text = data.object(forKey: "PaymentType") as? String
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
                
//            }
//        else {
//
//            cell.textLabel?.text = "No Data Found"
//        }
        
             return cell
//        }
//        else {
//
//            cell2.frame.size.height = self.tableView.frame.size.height
//
////            return cell2
//        }
        
    }
    
    
    func setTimeStampToDate(timeStamp: String) -> String {
        
        let unixTimestamp = Double(timeStamp)
        //        let date = Date(timeIntervalSince1970: unixTimestamp)
        
        let date = Date(timeIntervalSince1970: unixTimestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy" //Specify your format that you want
        let strDate: String = dateFormatter.string(from: date)
        
        return strDate
    }
    var thereIsCellTapped = false
    var selectedRowIndex = -1

    
     var expandedCellPaths = Set<IndexPath>()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if indexPath.section == 0 {
//
//            if aryPastJobs.count != 0 {
//
                if let cell = tableView.cellForRow(at: indexPath) as? PastJobsListTableViewCell {
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
//            }
//        }
    }

    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var labelNoData = UILabel()
    func webserviceofPendingJobs() {
        
        let driverID = Singletons.sharedInstance.strDriverID
//        UtilityClass.showHUD()

        webserviceForBookingHistry(driverID as AnyObject) { (result, status) in
            
            if (status) {
//                print(result)
                
                self.aryData = ((result as! NSDictionary).object(forKey: "history") as! NSArray)
                
        
                if(self.aryData.count == 0)
                {
                    
                    self.labelNoData.text = "There are no data"
                    self.tableView.isHidden = true
                }
                else {
                    
                    
                    self.labelNoData.removeFromSuperview()
                    self.tableView.isHidden = false
                }
        
                self.getPostJobs()
                self.tableView.reloadData()
                
                UtilityClass.hideACProgressHUD()
//               UtilityClass.hideHUD()
//                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            else {
//                print(result)
//               UtilityClass.hideHUD()
//                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

                UtilityClass.hideACProgressHUD()
            }
        }
            
       
    }
    
    func getPostJobs() {
        
        aryPastJobs.removeAllObjects()
        
         refreshControl.endRefreshing()
        for i in 0..<aryData.count {
            
            let dataOfAry = (aryData.object(at: i) as! NSDictionary)
            
            let strHistoryType = dataOfAry.object(forKey: "HistoryType") as! String
            
            if strHistoryType == "Past" {
                self.aryPastJobs.add(dataOfAry)
            }
            
        }
    }
   
    
}
