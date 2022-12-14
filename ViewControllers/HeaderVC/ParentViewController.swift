//
//  ParentViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 09/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SocketIO

class ParentViewController: UIViewController, HeaderViewDelegate {
    
//    let socket = SocketIOClient(socketURL: URL(string: "http://54.206.55.185:8080")!, config: [.log(false), .compress])
    
    
    
    
//    var frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: CGFloat(54))
//    frame = CGRect(x: CGFloat(0), y: CGFloat(-20), width: screenWidth, height: CGFloat(114))
//   frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: CGFloat(144))
    let heightWithoutLabel : Int = 64
    let heightWithoutLabelForX : Int = 114
    
    
    let heightWithLabel : Int = 94
    let heightWithLabelForX : Int = 144
    
    @IBInspectable var showsBackButton: Bool = false
    @IBInspectable var showTitleLabelView : Bool = false
    @IBInspectable var hideSwitchButton: Bool = false
    @IBInspectable var strHeaderTitle: String?
    @IBInspectable var strTitle : String?
    @IBInspectable var hideSignOut: Bool = false
    
    var headerView: HeaderView?
    var userDefault = UserDefaults.standard
    var driverDuty = String()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ParentViewController.statusBarFrameWillChange), name: .UIApplicationDidChangeStatusBarFrame, object: nil)

    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createHeaderView()
        

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        createHeaderView()
        if(self.isKind(of: HomeViewController.self))
        {
            createHeaderView()
        }


    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func statusBarFrameWillChange(_ note: Notification) {
        print("hello")
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        var frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: CGFloat(44))
        self.headerView?.frame = frame
        
        if (showTitleLabelView)
        {
            frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: CGFloat(heightWithLabel))
            self.headerView?.frame = frame

        }
        
//        createHeaderView()

    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    

    func didSideMenuClicked()       //  Side Menu
    {
        SideMenuClicked()
    }
    func didBackButtonClicked()     //  Back Button
    {
        BackButtonClicked()
    }
    
    func didSignOutClicked()        //  SignOut
    {
        SignOutClicked()
    }
    
    func didSwitchOnOFFClicked(isOn: Bool) {
        
        if isOn {
            SwitchOnClicked()
        }
        else {
            SwitchOFFClicked()
        }
    }
    
    // ------------------------------------------------------------
    
    func SideMenuClicked()       //  Side Menu
    {
        sideMenuController?.toggle()
    }
    func BackButtonClicked()     //  Back Button
    {
        if isModal() {
            self.dismiss(animated: true, completion: nil)
            
        }
        else {
            
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    func isModal() -> Bool {
        if (presentingViewController != nil) {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if (tabBarController?.presentingViewController is UITabBarController) {
            return true
        }
        return false
    }
    
    func SearchClicked()         //  Search
    {
        
    }
    func SignOutClicked()        //  SignOut
    {
        userDefault.removeObject(forKey: savedDataForRegistration.kModelDetails)
        userDefault.removeObject(forKey: savedDataForRegistration.kPageNumber)
        userDefault.removeObject(forKey: savedDataForRegistration.kKeyAllUserDetails)
  
        userDefault.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
        performSegue(withIdentifier: "SignOutFromRegister", sender: (Any).self)
  
    }
    func SwitchOnClicked()    //  Switch On
    {
        
        webserviceForChangeDutyStatus()
    
    }
    func SwitchOFFClicked()   //  Switch OFF
    {
   
        webserviceForChangeDutyStatus()
    
    }
    
    func CloseButtonClicked()    //  Close Button
    {
        self.navigationController?.popViewController(animated: true)
    }
    // ------------------------------------------------------------
    
    func createHeaderView() {
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        let hView = HeaderView.headerView(withDelegate: self)
        
        var frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: CGFloat(heightWithoutLabel))
        hView.bottomView.isHidden = !showTitleLabelView
        if (showTitleLabelView)
        {
            frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: CGFloat(heightWithLabel))
            hView.lblHeaderTitle.text = strHeaderTitle
        }
        
        
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                frame = CGRect(x: CGFloat(0), y: CGFloat(-20), width: screenWidth, height: CGFloat(heightWithoutLabelForX))
                if (showTitleLabelView)
                {
                    frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: CGFloat(heightWithLabelForX))
                    hView.lblHeaderTitle.text = strHeaderTitle
                }
            default:
                print("unknown")
            }
        }
        
        headerView?.lblTitle.isHidden = true
        
        if (strTitle != nil)
        {
            hView.lblTitle.isHidden = false
            hView.lblTitle.text = strTitle
            hView.imgHeaderImage.isHidden = true
        }
        
        hView.btnBack.isHidden = !showsBackButton
        hView.btnMenu.isHidden = showsBackButton
        hView.btnSwitch.isHidden = !hideSwitchButton
        hView.btnSignOut.isHidden = !hideSignOut
        
        hView.frame = frame
        headerView = hView
        view.addSubview(hView)
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice For Change Duty Status
    //-------------------------------------------------------------
    
    func webserviceForChangeDutyStatus()
    {
        let profile = NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile as NSDictionary).object(forKey: "profile") as! NSDictionary)
        let vehicle = profile.object(forKey: "Vehicle") as! NSDictionary
        
        var dictData = [String:AnyObject]()
        dictData[profileKeys.kDriverId] = vehicle.object(forKey: "DriverId") as AnyObject

        if Singletons.sharedInstance.latitude == nil || Singletons.sharedInstance.longitude == nil || Singletons.sharedInstance.latitude == 0 || Singletons.sharedInstance.longitude == 0
        {
            UtilityClass.showAlert("Location Missing", message: "Please turn on location", vc: self)
        }
        else
        {
            
            dictData[RegistrationFinalKeys.kLat] = Singletons.sharedInstance.latitude as AnyObject
            dictData[RegistrationFinalKeys.kLng] = Singletons.sharedInstance.longitude as AnyObject
            
            webserviceForDriverChangeDutyStatusOrShiftDutyStatus(dictData as AnyObject) { (result, status) in
                
                if (status) {
                    
                    print(result)
                    self.headerView?.btnSwitch.isEnabled = true
                    
                    if ((result as! NSDictionary).object(forKey: "duty") as! String == "off")
                    {
                        self.headerView?.btnSwitch.setImage(UIImage(named: "iconOffSwitch"), for: .normal)
                        Singletons.sharedInstance.driverDuty = "0"
                         UtilityClass.showAlert((result as! NSDictionary).object(forKey: "message") as! String, message: "", vc: self)
                        UIApplication.shared.isIdleTimerDisabled = false
                        let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
                        socket.disconnect()

                    }
                    else
                    {
                        self.headerView?.btnSwitch.setImage(UIImage(named: "iconOnSwitch"), for: .normal)
                        Singletons.sharedInstance.driverDuty = "1"
                        
                        let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
                        socket.connect()
                        UIApplication.shared.isIdleTimerDisabled = true

                        UtilityClass.showAlert((result as! NSDictionary).object(forKey: "message") as! String, message: "", vc: self)
                        
                        let contentVC = (self.navigationController?.childViewControllers[0] as! TabbarController).childViewControllers[0] as! HomeViewController
                        contentVC.UpdateDriverLocation()

                    }
                    UserDefaults.standard.set(Singletons.sharedInstance.driverDuty, forKey: "DriverDuty")
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

                    self.headerView?.btnSwitch.isEnabled = true

                    
                }
            }
        }
    }
    
    
    
}

