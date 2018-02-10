 //
//  LoginViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 12/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import CoreLocation
 import ACFloatingTextfield_Swift

class LoginViewController: UIViewController, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    
    var currentLocation = CLLocation()
    
    var strLatitude = Double()
    var strLongitude = Double()
    
    var strEmailForForgotPassword = String()
    
    @IBOutlet var btnLogin: UIButton!
    
    @IBOutlet var btnSignUp: UIButton!
    
    
    
    
    
    override func loadView()
    {
        super.loadView()
//        if(Singletons.sharedInstance.isDriverLoggedIN)
//        {
//            let next = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! CustomSideMenuViewController
//            self.navigationController?.pushViewController(next, animated: true)
//        }
        
        if Connectivity.isConnectedToInternet()
        {
            print("Yes! internet is available.")
            // do some tasks..
        }
        else {
            UtilityClass.showAlert(appName.kAPPName, message: "Internet connection not available", vc: self)
        }
        
//        webserviceOfAppSetting()
//        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        if UIDevice.current.name == "Excellent Web's iPhone 5s" {

            txtEmailAddress.text = "palak@excellentwebworld.info"
            txtPassword.text = "12345678"
        }

        self.viewMain.isHidden = false

        checkPass()

        if UIDevice.current.name == "Bhavesh iPhone" {

            txtEmailAddress.text = "palak@excellentwebworld.info"
            txtPassword.text = "12345678"
        }
        

        imgFacebook.layer.cornerRadius = imgFacebook.frame.width / 2
        imgFacebook.layer.masksToBounds = true

   /*
        txtEmailAddress.text = "developer.eww@gmail.com"
        txtPassword.text = "123456"
   */
        strLatitude = 0
        strLongitude = 0
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if manager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))
            {
                if manager.location != nil
                {
                    currentLocation = manager.location!
                    
                    strLatitude = currentLocation.coordinate.latitude
                    strLongitude = currentLocation.coordinate.longitude
                }
                
                manager.startUpdatingLocation()
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        btnSignUp.layer.cornerRadius = btnSignUp.frame.size.height/2
        btnSignUp.clipsToBounds = true
        
        btnLogin.layer.cornerRadius = btnLogin.frame.size.height/2
        btnLogin.clipsToBounds = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    

    @IBOutlet var imgFacebook: UIImageView!
    @IBOutlet weak var txtEmailAddress: ACFloatingTextfield!
    @IBOutlet weak var txtPassword: ACFloatingTextfield!
    
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewMain: UIView!
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnLogin(_ sender: UIButton) {
//        CustomSideMenuViewController
        
        if (validateAllFields()) {
            webserviceForLoginDrivers()
        }
       
    }
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Forgot Password?", message: "Enter E-Mail address", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "E-Mail"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField?.text))")
            
            self.strEmailForForgotPassword = (textField?.text)!
            
            if self.strEmailForForgotPassword == "" {
                
                NotificationCenter.default.post(name: Notification.Name("checkForgotPassword"), object: nil)
            }
            else {
                self.webserviceForgotPassword()
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
           
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSignUP(_ sender: UIButton) {
    }
    
    @IBAction func btnPassengerLogin(_ sender: UIButton) {
    }
    
    func checkPass() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showAlertForPasswordWrong), name: Notification.Name("checkForgotPassword"), object: nil)
    }
    
    func showAlertForPasswordWrong() {
        
        UtilityClass.showAlert(appName.kAPPName, message: "Enter Email", vc: self)
    }
    
    // ------------------------------------------------------------
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
        
    }
    
    // ------------------------------------------------------------
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var dictData = [String:AnyObject]()
    
    func webserviceForLoginDrivers()
    {
        dictData["Username"] = txtEmailAddress.text as AnyObject
        dictData["Password"] = txtPassword.text as AnyObject
        
        if strLatitude == 0 {
            dictData["Lat"] = "23.0012356" as AnyObject
        } else {
            dictData["Lat"] = strLatitude as AnyObject
        }
        
        if strLongitude == 0 {
            dictData["Lng"] = "72.0012341" as AnyObject
        } else {
            dictData["Lng"] = strLongitude as AnyObject
        }
        dictData["Token"] = Singletons.sharedInstance.deviceToken as AnyObject
        dictData["DeviceType"] = "1" as AnyObject
        
        webserviceForDriverLogin(dictData as AnyObject) { (result, status) in
            
            if (status)
            {
                 print(result)
                
                if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
                {
                    Singletons.sharedInstance.dictDriverProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "driver") as! NSDictionary)
                    Singletons.sharedInstance.isDriverLoggedIN = true
                    
                    UserDefaults.standard.set(Singletons.sharedInstance.dictDriverProfile, forKey: driverProfileKeys.kKeyDriverProfile)
                    UserDefaults.standard.set(true, forKey: driverProfileKeys.kKeyIsDriverLoggedIN)
                    
                    Singletons.sharedInstance.strDriverID = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "Vehicle") as! NSDictionary).object(forKey: "DriverId") as! String

                    Singletons.sharedInstance.driverDuty = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "DriverDuty") as! String)
//                    Singletons.sharedInstance.showTickPayRegistrationSceeen =
                    
                    let profileData = Singletons.sharedInstance.dictDriverProfile
                    
                    if let currentBalance = (profileData?.object(forKey: "profile") as! NSDictionary).object(forKey: "Balance") as? Double
                    {
                        Singletons.sharedInstance.strCurrentBalance = currentBalance
                    }
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! CustomSideMenuViewController
                    self.navigationController?.pushViewController(next, animated: true)
                }
                
            }
            else
            {
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
    
    // ------------------------------------------------------------
    
    func webserviceForgotPassword()
    {
        var params = [String:AnyObject]()
        params[RegistrationFinalKeys.kEmail] = strEmailForForgotPassword as AnyObject
        
        webserviceForForgotPassword(params as AnyObject) { (result, status) in
            
            if (status) {
                
                print(result)
                let alert = UIAlertController(title: nil, message: result.object(forKey: "message") as? String, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            } else {
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
    // ----------------------------------------------------------------------
    
    func webserviceOfAppSetting() {
//        version : 1.0.0 , (app_type : AndroidPassenger , AndroidDriver , IOSPassenger , IOSDriver)
        
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        
        var param = String()
        
        param = version + "/" + "IOSDriver"
        
        webserviceForAppSetting(param as AnyObject) { (result, status) in
            
            if(status) {
                print(result)
                /*
                 {
                     "status": true,
                     "update": false,
                     "message": "Ticktoc app new version available"
                 }
                 */
                self.viewMain.isHidden = true
                
                if let update = (result as! NSDictionary).object(forKey: "update") as? Bool {
                    
                    let alert = UIAlertController(title: nil, message: (result as! NSDictionary).object(forKey: "message") as? String, preferredStyle: .alert)
                    let UPDATE = UIAlertAction(title: "UPDATE", style: .default, handler: { ACTION in
                        
                        UIApplication.shared.openURL(NSURL(string: "itms://itunes.apple.com/us/app/ticktoc-driver/id1034261927?mt=8")! as URL)
                    })
                    let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: { ACTION in
                        
                        if(Singletons.sharedInstance.isDriverLoggedIN)
                        {
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! CustomSideMenuViewController
                            self.navigationController?.pushViewController(next, animated: true)
                        }
                    })
                    alert.addAction(UPDATE)
                    alert.addAction(Cancel)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    
                    if(Singletons.sharedInstance.isDriverLoggedIN)
                    {
                        let next = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! CustomSideMenuViewController
                        self.navigationController?.pushViewController(next, animated: true)
                    }
                    
                }
                
                //                if(SingletonClass.sharedInstance.isUserLoggedIN)
                //                {
                //                    self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                //                }
                
                
            }
            else {
                print(result)
                /*
                 {
                     "status": false,
                     "update": false,
                     "maintenance": true,
                     "message": "Server under maintenance, please try again after some time"
                 }
                 */
                
                if let res = result as? String {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else if let update = (result as! NSDictionary).object(forKey: "update") as? Bool {
                    
                    if (update) {
                        //                        UtilityClass.showAlert(appName.kAPPName, message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                        
                        UtilityClass.showAlertWithCompletion(appName.kAPPName, message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self, completionHandler: { ACTION in
                            
                            UIApplication.shared.openURL(NSURL(string: "itms://itunes.apple.com/us/app/ticktoc-driver/id1034261927?mt=8")! as URL)
                        })
                    }
                    else {
                        UtilityClass.showAlert(appName.kAPPName, message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                    }
                    
                }
                /*
                 {
                     "status": false,
                     "update": true,
                     "message": "Ticktoc app new version available, please upgrade your application"
                 }
                 */
//                if let res = result as? String {
//                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
//                }
//                else if let resDict = result as? NSDictionary {
//                    UtilityClass.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
//                }
//                else if let resAry = result as? NSArray {
//                    UtilityClass.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
//                }
            }
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Validation Methods
    //-------------------------------------------------------------
    
    func validateAllFields() -> Bool
    {
        let isEmailAddressValid = isValidEmailAddress(emailID: txtEmailAddress.text!)
        //        let providePassword = txtPassword.text
        
        //        let isPasswordValid = isPwdLenth(password: providePassword!)
        
        
        if txtEmailAddress.text!.count == 0
        {
            UtilityClass.showAlert(appName.kAPPName, message: "Please Enter Email Id", vc: self)
            return false
        }
        else if (!isEmailAddressValid)
        {
            UtilityClass.showAlert(appName.kAPPName, message: "Please Enter Valid Email ID", vc: self)
            
            return false
        }
        else if txtPassword.text!.count == 0
        {
            
            UtilityClass.showAlert(appName.kAPPName, message: "Please Enter Password", vc: self)
            
            return false
        }
        else if txtPassword.text!.count <= 5 {
            UtilityClass.showAlert(appName.kAPPName, message: "Password should be more than 5 characters", vc: self)
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
    

}
