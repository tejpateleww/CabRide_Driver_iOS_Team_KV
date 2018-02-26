//
//  WalletTransferToBankVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 23/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

@objc protocol SelectBankCardDelegate {
    
    func didSelectBankCard(dictData: [String: AnyObject])
}

class WalletTransferToBankVC: ParentViewController, SelectBankCardDelegate {

    
    @IBOutlet var lblBSB: UILabel!
    @IBOutlet var lblBankAccNumber: UILabel!
    @IBOutlet var lblABN: UILabel!
    @IBOutlet var lblAccountHolderName: UILabel!
    @IBOutlet var lblBankName: UILabel!
    var strAmt = String()
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewMain.layer.cornerRadius = 5
        viewMain.layer.masksToBounds = true
        
        btnWithdrawFunds.layer.cornerRadius = 5
        btnWithdrawFunds.layer.masksToBounds = true
        
      
        lblCurrentBalanceTitle.text = "\(Singletons.sharedInstance.strCurrentBalance)"
        let profileData = Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! [String : AnyObject]

       
        let strBSB = profileData["BSB"] as! String
        let strHolderName = profileData["BankHolderName"] as! String
        let strABN = profileData["ABN"] as! String
        let strBankName = profileData["BankName"] as! String
        let strAccNumber = profileData["BankAcNo"] as! String
      
        
        
        
        lblAccountHolderName.text = ": \(strHolderName)"
        lblABN.text = ": \(strABN)"
        lblBankName.text = ": \(strBankName)"
        lblBankAccNumber.text = ": \(strAccNumber)"
        lblBSB.text = ":  \(strBSB)"
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var lblCardTitle: UILabel!
    @IBOutlet weak var lblCurrentBalanceTitle: UILabel!
    
    @IBOutlet weak var txtAmount: UITextField!
    
    @IBOutlet weak var btnWithdrawFunds: UIButton!
    
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var btnCardTitle: UIButton!
    
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnCardTitle(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
        Singletons.sharedInstance.isFromTransferToBank = true
        next.delegateForTransferToBank = self
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    
    @IBAction func txtAmount(_ sender: UITextField) {
        
        if let amountString = txtAmount.text?.currencyInputFormatting() {
            
            
            //            txtAmount.text = amountString
            
            
            let unfiltered1 = amountString   //  "!   !! yuahl! !"
            
            
            let y = amountString.replacingOccurrences(of: "$, ", with: "", options: .regularExpression, range: nil)

            // Array of Characters to remove
            let removal1: [Character] = ["$"," "]    // ["!"," "]
            
            // turn the string into an Array
            let unfilteredCharacters1 = unfiltered1
            
            // return an Array without the removal Characters
            let filteredCharacters1 = unfilteredCharacters1.filter { !removal1.contains($0) }
            
            // build a String with the filtered Array
            let filtered1 = String(filteredCharacters1)
            
            print(filtered1) // => "yeah"
            
            // combined to a single line
            print(String(unfiltered1.filter { !removal1.contains($0) })) // => "yuahl"
            
            txtAmount.text = String(unfiltered1.filter { !removal1.contains($0) })
            
            
            
            // ----------------------------------------------------------------------
            // ----------------------------------------------------------------------
            let unfiltered = amountString   //  "!   !! yuahl! !"
            
            // Array of Characters to remove
            let removal: [Character] = ["$",","," "]    // ["!"," "]
            
            // turn the string into an Array
            let unfilteredCharacters = unfiltered
            
            // return an Array without the removal Characters
            let filteredCharacters = unfilteredCharacters.filter { !removal.contains($0) }
            
            // build a String with the filtered Array
            let filtered = String(filteredCharacters)
            
            print(filtered) // => "yeah"
            
            // combined to a single line
            print(String(unfiltered.filter { !removal.contains($0) })) // => "yuahl"
            
            strAmt = y
            print("amount : \(strAmt)")
            
            
            
            
        }
    }
    
    @IBAction func btnWithdrawFunds(_ sender: UIButton) {
        
//        UtilityClass.showAlert(appName.kAPPName, message: "This feature is not available right now.", vc: self)
        webserviceCallToTransferToBank()
    }
    
    //-------------------------------------------------------------
    // MARK: - Select Card Delegate Methods
    //-------------------------------------------------------------
    
    func didSelectBankCard(dictData: [String : AnyObject]) {
        
        print(dictData)
        
        lblCardTitle.text = "\(dictData["Type"] as! String) \(dictData["CardNum2"] as! String)"
        
//        lblCurrentBalanceTitle = dictData["Type"] as? AnyObject
        
        //        dictData1["PassengerId"] = "1" as AnyObject
        //        dictData1["CardNo"] = "**** **** **** 1081" as AnyObject
        //        dictData1["Cvv"] = "123" as AnyObject
        //        dictData1["Expiry"] = "08/22" as AnyObject
        //        dictData1["CardType"] = "MasterCard" as AnyObject
        
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Call To transfer money to bank
    //-------------------------------------------------------------
    
    //DriverId,Amount,HolderName,ABN,BankName,BSB,AccountNo
    func  webserviceCallToTransferToBank()
    {
       
        let profileData = Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! [String : AnyObject]
        let strDriverID = profileData["Id"] as! String
        let strAmount = self.strAmt
        
        var dictData = [String : String]()
        dictData["DriverId"] = strDriverID
        dictData["Amount"] = strAmount
        dictData["HolderName"] = lblAccountHolderName.text //as! String
        dictData["ABN"] = lblABN.text //as! String
        dictData["BankName"] = lblBankName.text //as! String
        dictData["BSB"] = lblBSB.text //as! String
        dictData["AccountNo"] = lblBankAccNumber.text //as! String
        
        webserviceForTransferMoneyToBank(dictData as AnyObject) { (result, status) in
            if(status)
            {
                
            }
            else
            {
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
//
    

}
