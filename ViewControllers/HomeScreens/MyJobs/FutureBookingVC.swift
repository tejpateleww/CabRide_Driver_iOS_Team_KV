//
//  FutureBookingVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 16/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FutureBookingVC: ParentViewController, UITableViewDataSource, UITableViewDelegate {

    
   
    
//    let hView = HeaderView()
    
    var dataPatam = [String:AnyObject]()
    var aryData = NSArray()
     var expandedCellPaths = Set<IndexPath>()
    
    var selectedCellIndexPath: IndexPath?
    let selectedCellHeight: CGFloat = 205
    let unselectedCellHeight: CGFloat = 105
    
    var drieverId = String()
    var bookingID = String()
    
     var labelNoData = UILabel()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()

        labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.labelNoData.text = "Loading..."
        labelNoData.textAlignment = .center
        self.view.addSubview(labelNoData)
        self.tableView.isHidden = true
        
        webserviceOFFurureBooking()
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        self.tableView.addSubview(self.refreshControl)

    }
    
    override func loadView() {
        super.loadView()
        
//        let activityData = ActivityData()
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
                
        webserviceOFFurureBooking()
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
//            if aryData.count == 0 {
//                return 1
//            }
//            else {
//                return aryData.count
//            }
//        }
//        else {
//            return 1
//        }
        
        return aryData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "FutureBookingTableViewCell") as! FutureBookingTableViewCell
//        let cell2 = tableView.dequeueReusableCell(withIdentifier: "NoDataFound") as! FutureBookingTableViewCell
        
        cell.selectionStyle = .none
//        cell2.selectionStyle = .none
  
//        if aryData.count != 0 {
        
//            if indexPath.section == 0 {
//
                 let data = aryData.object(at: indexPath.row) as! NSDictionary
               
                cell.lblPassengerName.text = data.object(forKey: "PassengerName") as? String
        

            if let TimeAndDate = data.object(forKey: "PickupDateTime") as? String {
                cell.lblTimeAndDateAtTop.text = setTimeStampToDate(timeStamp: TimeAndDate)
            }
            else {
                cell.lblTimeAndDateAtTop.text = "Not available"
            }
        

                cell.lblDropOffLocationDesc.text = data.object(forKey: "PickupLocation") as? String // DropoffLocation
                cell.lblDateAndTime.text = data.object(forKey: "PickupDateTime") as? String
                cell.lblPickupLocation.text = data.object(forKey: "DropoffLocation") as? String  // PickupLocation
                cell.lblPassengerNoDesc.text = data.object(forKey: "PassengerContact") as? String
                cell.lblTripDestanceDesc.text = data.object(forKey: "TripDistance") as? String
                cell.lblCarModelDesc.text = data.object(forKey: "Model") as? String
                
                cell.btnAction.tag = Int((data.object(forKey: "Id") as? String)!)!
                cell.btnAction.addTarget(self, action: #selector(self.btnActionForSelectRecord(sender:)), for: .touchUpInside)
                cell.lblFlightNumber.text = data.object(forKey: "FlightNumber") as? String
                cell.lblNotes.text = data.object(forKey: "Notes") as? String
                cell.lblPaymentType.text = data.object(forKey: "PaymentType") as? String
                cell.viewSecond.isHidden = !expandedCellPaths.contains(indexPath)
 
//            }
        
        
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
//        }
//        else {
//
//            cell2.frame.size.height = self.tableView.frame.size.height
//
//            return cell2
//        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//
//        if aryData.count != 0 {
//
//            if indexPath.section == 0 {
//
                if let cell = tableView.cellForRow(at: indexPath) as? FutureBookingTableViewCell {
                    cell.viewSecond.isHidden = !cell.viewSecond.isHidden
                    if cell.viewSecond.isHidden {
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
    

    func btnActionForSelectRecord(sender: UIButton) {
        
        bookingID = String((sender.tag))
        
        webserviceOfFutureAcceptDispatchJobRequest()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setTimeStampToDate(timeStamp: String) -> String {
        
//        let unixTimestamp = Double(timeStamp)
        //        let date = Date(timeIntervalSince1970: unixTimestamp)
        
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let date = dateFormatter.date(from: timeStamp) //according to date format your date string
        print(date ?? "")

//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy" //Specify your format that you want
        let strDate: String = dateFormatter.string(from: date!)
        
        return strDate
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOFFurureBooking()
    {
        
        let id = Singletons.sharedInstance.strDriverID
        
        webserviceForFutureBooking(id as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                self.aryData = ((result as! NSDictionary).object(forKey: "dispath_job") as! NSArray)
                
               
                if(self.aryData.count == 0)
                {
                    self.labelNoData.text = "Please check back later"
                    self.tableView.isHidden = true
                }
                else {
                    self.labelNoData.removeFromSuperview()
                    self.tableView.isHidden = false
                }
                
                 self.refreshControl.endRefreshing()
                self.tableView.reloadData()
                
            }
            else {
                print(result)
            
            }
        }
    }
    
    var audioPlayer:AVAudioPlayer!
    
    func playSound(strName : String) {
        
        guard let url = Bundle.main.url(forResource: strName, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            //            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.numberOfLoops = 1
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
    
    
    
    func webserviceOfFutureAcceptDispatchJobRequest() {
        
        drieverId = Singletons.sharedInstance.strDriverID

        let sendParam = drieverId + "/" + bookingID
        
        
        
        webserviceForFutureAcceptDispatchJobRequest(sendParam as AnyObject) { (result, status) in

            if (status) {
                print(result)
                
                
                
//                self.playSound(strName: "RequestConfirm")
                let alert = UIAlertController(title: "Booking Accepted", message: "", preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
//                    self.stopSound()
                     Singletons.sharedInstance.isPresentVC = true
                    
                    if self.isModal() {
                        self.dismiss(animated: true, completion: {
                            
                        })
                        
                    }
                    else {
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                 })
                alert.addAction(OK)
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
                print(result)
                
        
                if let res = result as? String {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }
        
    }
    
    
 
}
