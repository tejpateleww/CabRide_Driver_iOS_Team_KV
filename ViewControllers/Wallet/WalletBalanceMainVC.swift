//
//  WalletBalanceMainVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 23/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class WalletBalanceMainVC: ParentViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        webserviceOfTransactionHistory()
        tableView.reloadData()
    }

    
     var aryData = [[String:AnyObject]]()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        self.tableView.addSubview(self.refreshControl)
        
        if Singletons.sharedInstance.walletHistoryData.count == 0 {
             webserviceOfTransactionHistory()
        }
        else {
            aryData = Singletons.sharedInstance.walletHistoryData
            let currentRatio = Double(Singletons.sharedInstance.strCurrentBalance)
            
            self.lblAvailableFundsDesc.text = "$\(String(format: "%.2f", currentRatio))"
            
        }
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        viewAvailableFunds.layer.cornerRadius = 5
        viewAvailableFunds.layer.masksToBounds = true
        
        viewCenter.layer.cornerRadius = 5
        viewCenter.layer.masksToBounds = true
        
        viewBottom.layer.cornerRadius = 5
        viewBottom.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var viewAvailableFunds: UIView!
    @IBOutlet weak var lblAvailableFunds: UILabel!
    @IBOutlet weak var lblAvailableFundsDesc: UILabel!
    
  
    @IBOutlet weak var viewCenter: UIView!
    
    @IBOutlet weak var imgTopUp: UIImageView!
    @IBOutlet weak var lblTopUp: UILabel!
    
    @IBOutlet weak var imgTansferToBank: UIImageView!
    @IBOutlet weak var lblTransferToBank: UILabel!
    
    @IBOutlet weak var imgHistory: UIImageView!
    @IBOutlet weak var lblHistory: UILabel!
    
    
    @IBOutlet weak var viewBottom: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
  
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletBalanceMainTableViewCell") as! WalletBalanceMainTableViewCell
        cell.selectionStyle = .none
        
        let dictData = aryData[indexPath.row]
        
        cell.lblTransferTitle.text = dictData["Description"] as? String
        cell.lblTransferDateAndTime.text = dictData["UpdatedDate"] as? String
        let currentRatio = Double(dictData["Amount"] as! String)!
        if dictData["Status"] as! String == "failed" {
            
            cell.lblPrice.text = "\(dictData["Type"] as! String) \(String(format: "%.2f", currentRatio))"
            cell.lblPrice.textColor = UIColor.red
        }
        else {
            
            cell.lblPrice.text = "\(dictData["Type"] as! String) \(String(format: "%.2f", currentRatio))"
            cell.lblPrice.textColor = UIColor.init(red: 0, green: 144/255, blue: 81/255, alpha: 1.0)
        }
        
        return cell
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnTopUP(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletTopUpVC") as! WalletTopUpVC
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    @IBAction func btnTransferToBank(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletTransferToBankVC") as! WalletTransferToBankVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnHistory(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletHistoryViewController") as! WalletHistoryViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Transaction History
    //-------------------------------------------------------------
    
    func webserviceOfTransactionHistory() {
        
        webserviceForTransactionHistoryInWallet(Singletons.sharedInstance.strDriverID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                Singletons.sharedInstance.strCurrentBalance = ((result as! NSDictionary).object(forKey: "walletBalance") as AnyObject).doubleValue
                
                
                let currentRatio = Double(Singletons.sharedInstance.strCurrentBalance)
                
                self.lblAvailableFundsDesc.text = "$\(String(format: "%.2f", currentRatio))"
                
                self.aryData = (result as! NSDictionary).object(forKey: "history") as! [[String:AnyObject]]
                
                Singletons.sharedInstance.walletHistoryData = self.aryData
                
                self.tableView.reloadData()
                
                self.refreshControl.endRefreshing()
                
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
