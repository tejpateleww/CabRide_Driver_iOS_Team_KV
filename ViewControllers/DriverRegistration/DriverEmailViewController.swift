//
//  DriverEmailViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 11/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DriverEmailViewController: UIViewController, UIScrollViewDelegate, NVActivityIndicatorViewable 
{

    var userDefault = UserDefaults.standard
    
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var constrainViewOTPLeadingPosition: NSLayoutConstraint!
    
    @IBOutlet var viewOTP: UIView!
    @IBOutlet var lblHaveAccount: UILabel!
    
    @IBOutlet var txtOTP: UITextField!
    @IBOutlet var viewEmailData: UIView!
    @IBOutlet var btnLogin: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewEmailData.isHidden = false
        constrainViewOTPLeadingPosition.constant = self.view.frame.size.width
        self.btnNext.setTitle("NEXT", for: .normal)
        self.lblHaveAccount.isHidden = false
        self.btnLogin.isHidden = false

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnNext.layer.cornerRadius = btnNext.frame.size.height/2
        btnNext.clipsToBounds = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var txtEmailId: UITextField!
    
    @IBAction func btnNext(_ sender: Any)
    {
        
        if btnNext.titleLabel?.text == "SUBMIT"
        {
//            constrainViewOTPLeadingPosition.constant = self.view.frame.size.width
            UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseOut, animations:
                {
//                    self.view.layoutIfNeeded()
//                    self.btnNext.setTitle("NEXT", for: .normal)
            }) { (done) in
//                self.viewEmailData.isHidden = false
//                self.lblHaveAccount.isHidden = false
//                self.btnLogin.isHidden = false
            }
            //        if(checkValidation())
            //        {
                        webserviceForGetOTPCode()
            //        }
        }
        else
        {
            constrainViewOTPLeadingPosition.constant = -self.view.frame.size.width
            self.viewEmailData.isHidden = true
            self.lblHaveAccount.isHidden = true
            self.btnLogin.isHidden = true
            UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseOut, animations:
                {
                    self.view.layoutIfNeeded()
                    self.btnNext.setTitle("SUBMIT", for: .normal)
            })
            { (done) in
              
            }
            
            
            

        }
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
//        let pageNo = CGFloat(scrollView.contentOffset.x / scrollView.frame.size.width)
//        segmentController.selectItemAt(index: Int(pageNo), animated: true)
    }
    
    func checkValidation() -> Bool {
        
        let isEmailAddressValid = isValidEmailAddress(emailID: txtEmailId.text!)
      
        if txtEmailId.text!.count == 0
        {
            UtilityClass.showAlert(appName.kAPPName, message: "Please Enter Email Id", vc: self)
            return false
        }
        else if (!isEmailAddressValid)
        {
            UtilityClass.showAlert(appName.kAPPName, message: "Please Enter Valid Email ID", vc: self)
            
            return false
        }
        
        return true
    }
    
    func isValidEmailAddress(emailID: String) -> Bool
    {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z)-9.-]+\\.[A-Za-z]{2,3}"
        
        do{
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailID as NSString
            let results = regex.matches(in: emailID, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
        }
        catch _ as NSError
        {
            returnValue = false
        }
        
        return returnValue
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice For Get OTP Code
    //-------------------------------------------------------------
    
    var aryOfCompany = [[String:AnyObject]]()
    
    func webserviceForGetOTPCode()
    {
        var dictData = [String:AnyObject]()
        dictData["Email"] = txtEmailId.text as AnyObject

        
//        webserviceForOTPDriverRegister(dictData as AnyObject) { (result, status) in
//
//            if (status)
//            {
//                print(result)
//
//                let otp = result.object(forKey: "otp") as! Int
//                self.aryOfCompany = result.object(forKey: "company") as! [[String : AnyObject]]
//
//                self.userDefault.set(otp, forKey: OTPCodeStruct.kOTPCode)
//                self.userDefault.set(self.aryOfCompany, forKey: OTPCodeStruct.kCompanyList)
//
//                let alert = UIAlertController(title: nil, message: result.object(forKey: "message") as? String, preferredStyle: .alert)
//
//                let ok = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
//
                    let driverVC = self.navigationController?.viewControllers.last as! DriverRegistrationViewController
//
//                    driverVC.setData(companyData: self.aryOfCompany)
//
        
                    let x = self.view.frame.size.width
                    driverVC.scrollObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
//                    driverVC.segmentController.selectedIndex = 1
                    driverVC.viewEmailDriver.backgroundColor = ThemeYellowColor
                    driverVC.imgDriver.image = UIImage.init(named: iconDriverSelect)
                    self.userDefault.set(self.txtEmailId.text, forKey: savedDataForRegistration.kKeyEmail)
                    self.userDefault.set(self.txtEmailId.text, forKey: RegistrationFinalKeys.kEmail)
                    self.userDefault.set(1, forKey: savedDataForRegistration.kPageNumber)
                    
//                })
                
           
//                alert.addAction(ok)
//                self.present(alert, animated: true, completion: nil)
//            }
//            else
//            {
//                print(result)
//                let alert = UIAlertController(title: nil, message: result.object(forKey: "message") as? String, preferredStyle: .alert)
//                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alert.addAction(ok)
//                self.present(alert, animated: true, completion: nil)
//            }
//
//            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//
//        }
    }
    
}
