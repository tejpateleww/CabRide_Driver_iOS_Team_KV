//
//  DriverBankDetailsViewController.swift
//  PickNGo-Driver
//
//  Created by Excellent Webworld on 09/02/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift

class DriverBankDetailsViewController: UIViewController
{

    
    @IBOutlet var btnNext: UIButton!
    var userDefault =  UserDefaults.standard

    @IBOutlet var txtAccountNumber: ACFloatingTextfield!
    @IBOutlet var txtBankBranch: ACFloatingTextfield!
    @IBOutlet var txtBankName: ACFloatingTextfield!
    @IBOutlet var txtAccountHolderName: ACFloatingTextfield!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnNext.layer.cornerRadius = btnNext.frame.size.height/2
        btnNext.clipsToBounds = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnNext(_ sender: Any) {
        

        if CheckValidation()
        {
            let driverVC = self.navigationController?.viewControllers.last as! DriverRegistrationViewController
            
            //        let personalDetailsVC = driverVC.childViewControllers[2] as! DriverPersonelDetailsViewController
            driverVC.viewBankCar.backgroundColor = ThemePinkColor
            driverVC.imgCar.image = UIImage.init(named: iconCarSelect)
            let x = self.view.frame.size.width * 3
            driverVC.scrollObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
            
            
            
            self.userDefault.set(self.txtAccountHolderName.text, forKey: RegistrationFinalKeys.kbankHolderName)
            self.userDefault.set(self.txtBankName.text, forKey: RegistrationFinalKeys.kBankName)
            self.userDefault.set(self.txtBankBranch.text, forKey: RegistrationFinalKeys.kBSB)
            self.userDefault.set(self.txtAccountNumber.text, forKey: RegistrationFinalKeys.kBankAccountNo)
            self.userDefault.set(3, forKey: savedDataForRegistration.kPageNumber)
            
        }
        
        
        
    }
    
    func CheckValidation() -> Bool
    {
        let sb = Snackbar()
//        sb.createWithAction(text: "Upload Car Registration", actionTitle: "OK", action: { print("Button is push") })
        
        if txtAccountHolderName.text == "" {
            sb.createWithAction(text: "Enter Account Holder Name", actionTitle: "OK", action: { print("Button is push") })
            return false
        }
        else if txtBankName.text == "" {
            sb.createWithAction(text: "Enter Bank Name", actionTitle: "OK", action: { print("Button is push") })
            return false

        }
            
            
        else if txtBankBranch.text == "" {
            sb.createWithAction(text: "Enter Bank Branch", actionTitle: "OK", action: { print("Button is push") })
            return false

        }
            
        else if txtAccountNumber.text == "" {
            sb.createWithAction(text: "Enter Account Number", actionTitle: "OK", action: { print("Button is push") })
            return false

        }
        
        sb.show()
        return true

    }

}
