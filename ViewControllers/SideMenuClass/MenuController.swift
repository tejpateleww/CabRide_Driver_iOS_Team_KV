//
//  MenuController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 11/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SideMenuController
import SDWebImage

class MenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var aryItemNames = [String]()
    var aryItemIcons = [String]()
    
    var driverFullName = String()
    var driverImage = UIImage()
    var driverMobileNo = String()
    var strImagPath = String()
    
    private var previousIndex: NSIndexPath?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        getDataFromSingleton()
        
        aryItemNames = ["Payment Option", "My Wallet", "Driver News","Invite Drivers", "Change Password", "Settings", "Log Out"]//, "TiCKPay"
        
        aryItemIcons = ["iconPayment","iconWallet","iconNews","iconInvite", "iconChangePassword", "iconSettings", "iconSignOut"]//, "iconTickPay"


        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(MenuController.setRating), name: NSNotification.Name(rawValue: "rating"), object: nil)


    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        giveGradientColor()
    }
    func giveGradientColor()
    {
        
        let colorTop =  UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        let colorMiddle =  UIColor(red: 36/255, green: 24/255, blue: 3/255, alpha: 0.5).cgColor
        let colorBottom = UIColor(red: 64/255, green: 43/255, blue: 6/255, alpha: 0.8).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorMiddle, colorBottom]
        gradientLayer.locations = [ 0.0, 0.5, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
         UIApplication.shared.statusBarStyle = .lightContent
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
         UIApplication.shared.statusBarStyle = .default
    }
    func setRating() {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBOutlet var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if aryItemNames.count == 0 {
                return 0
            }
            return 1
        }
        else if section == 1 {
            return aryItemNames.count
        }
        else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let cellProfile = tableView.dequeueReusableCell(withIdentifier: "SideMenuIDriverProfile") as! SideMenuTableViewCell
        let cellItemList = tableView.dequeueReusableCell(withIdentifier: "SideMenuItemsList") as! SideMenuTableViewCell
        
        cellProfile.selectionStyle = .none
        cellItemList.selectionStyle = .none
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        
        if indexPath.section == 0 {
            
            cellProfile.imgProfile.layer.cornerRadius = cellProfile.imgProfile.frame.width / 2
            cellProfile.imgProfile.layer.masksToBounds = true
            cellProfile.imgProfile.layer.borderColor = ThemeYellowColor.cgColor
            cellProfile.imgProfile.layer.borderWidth = 1.0
            cellProfile.lblDriverName.text = driverFullName
            cellProfile.lblContactNumber.text = driverMobileNo
            cellProfile.lblRating.text = Singletons.sharedInstance.strRating
            cellProfile.imgProfile.sd_setImage(with: URL(string: strImagPath))
            cellProfile.btnUpdateProfile.addTarget(self, action: #selector(self.updateProfile), for: .touchUpInside)
            
            return cellProfile
        }
        else if indexPath.section == 1 {
            
            cellItemList.lblItemNames.text = aryItemNames[indexPath.row]
            cellItemList.imgItems.image = UIImage(named: aryItemIcons[indexPath.row])
            
            
            return cellItemList
        }
        else {
            return UITableViewCell()
        }
     
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        
        if indexPath.section == 1
        {
            if indexPath.row == 0 {
                if(Singletons.sharedInstance.CardsVCHaveAryData.count == 0)
                {
                      let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                    self.navigationController?.pushViewController(viewController, animated: true)

                }
                else
                {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
                    self.navigationController?.pushViewController(viewController, animated: true)


                }
            }
            else if indexPath.row == 1 {
                
                //                self.moveToComingSoon()
                //                   UserDefaults.standard.set(Singletons.sharedInstance.isPasscodeON, forKey: "isPasscodeON")
                
                if (Singletons.sharedInstance.isPasscodeON) {
                    //                    if Singletons.sharedInstance.setPasscode == "" {
                    //                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
                    //                        self.navigationController?.pushViewController(viewController, animated: true)
                    //                    }
                    //                    else {
                    //                        if (Singletons.sharedInstance.passwordFirstTime) {
                    //
                    //                            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                    //                            self.navigationController?.pushViewController(next, animated: true)
                    //                        }
                    //                        else {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
                    viewController.strStatusToNavigate = "wallet"
                    self.navigationController?.pushViewController(viewController, animated: true)
                    
                    //                        }
                }
                    
                else
                {
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                    self.navigationController?.pushViewController(next, animated: true)
                }
                
                
                
                
                //                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
                //                self.navigationController?.pushViewController(viewController, animated: true)
                //
                
                //                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                //                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
//            else if indexPath.row == 2 {
//
//                if (Singletons.sharedInstance.isPasscodeON) {
//                    let tabbar =  ((((((self.navigationController?.childViewControllers)?.last as! CustomSideMenuViewController).childViewControllers[0]) as! UINavigationController).childViewControllers[0]) as! TabbarController)
//                    tabbar.selectedIndex = 4
//                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
//                    self.present(viewController, animated: false, completion: nil)
//                    sideMenuController?.toggle()
//
//                }
//                else {
//                    let tabbar =  ((((((self.navigationController?.childViewControllers)?.last as! CustomSideMenuViewController).childViewControllers[0]) as! UINavigationController).childViewControllers[0]) as! TabbarController)
//                    tabbar.selectedIndex = 4
//
//                    sideMenuController?.toggle()
//                }
//
//            }
//            else if indexPath.row == 2 {
////                 self.moveToComingSoon()
//
//                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WeeklyEarningViewController") as! WeeklyEarningViewController
//                self.navigationController?.pushViewController(viewController, animated: true)
//            }
            else if indexPath.row == 2 {
//                self.moveToComingSoon()

                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DriverNewsViewController") as! DriverNewsViewController
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
           else if indexPath.row == 3 {
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "InviteDriverViewController") as! InviteDriverViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if indexPath.row == 4 {
                
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
            else if indexPath.row == 5 {

                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingPasscodeVC") as! SettingPasscodeVC
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
            else if indexPath.row == 6
            {
               self.webserviceOFSignOut()
            }
        }
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180
        }
        else if indexPath.section == 1 {
            return 50
        }
        else {
            return 44
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func updateProfile()
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EditDriverProfileVC") as! EditDriverProfileVC
        self.navigationController?.pushViewController(viewController, animated: true)
//        self.sideMenuController?.embed(centerViewController: viewController)
    }
    func getDataFromSingleton()
    {
        let profile =  NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary))
//         {
        
            
//            NSMutableDictionary(Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as NSDictionary).object(forKey: "profile")
        
            driverFullName = profile.object(forKey: "Fullname") as! String
            driverMobileNo = profile.object(forKey: "Email") as! String
            
            strImagPath = profile.object(forKey: "Image") as! String
        
        
//        }
//        if let profile =  NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as NSDictionary).object(forKey: "profile") as) {
//
//
//            //            NSMutableDictionary(Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as NSDictionary).object(forKey: "profile")
//
//            driverFullName = profile.object(forKey: "Fullname") as! String
//            driverMobileNo = profile.object(forKey: "MobileNo") as! String
//
//            strImagPath = profile.object(forKey: "Image") as! String
//        }
        
        
        
        
        tableView.reloadData()
        
    }
    
    // ------------------------------------------------------------
    
    func moveToComingSoon() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ComingSoonVC") as! ComingSoonVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOFSignOut()
    {
        let srtDriverID = Singletons.sharedInstance.strDriverID
        
        let param = srtDriverID + "/" + Singletons.sharedInstance.deviceToken
        
        webserviceForSignOut(param as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
   
                socket.off(socketApiKeys.kReceiveBookingRequest)
                socket.off(socketApiKeys.kBookLaterDriverNotify)
                
                socket.off(socketApiKeys.kGetBookingDetailsAfterBookingRequestAccepted)
                socket.off(socketApiKeys.kAdvancedBookingInfo)
                
                socket.off(socketApiKeys.kReceiveMoneyNotify)
                socket.off(socketApiKeys.kAriveAdvancedBookingRequest)
                
                socket.off(socketApiKeys.kDriverCancelTripNotification)
                socket.off(socketApiKeys.kAdvancedBookingDriverCancelTripNotification)
                Singletons.sharedInstance.setPasscode = ""
                Singletons.sharedInstance.isPasscodeON = false
                socket.disconnect()
                
                for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
                    print("\(key) = \(value) \n")
                    
                    if key == "Token" {
                        
                    }
                    else {
                        UserDefaults.standard.removeObject(forKey: key)
                    }
                }
                
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                Singletons.sharedInstance.isDriverLoggedIN = false                                                                                                                                                                                                                                                        
                self.performSegue(withIdentifier: "SignOutFromSideMenu", sender: (Any).self)
                
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
