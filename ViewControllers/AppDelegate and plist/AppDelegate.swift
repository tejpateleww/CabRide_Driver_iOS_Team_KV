//
//  AppDelegate.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 09/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SideMenuController
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import Fabric
import Crashlytics
import UserNotifications
import FirebaseMessaging
import SocketIO
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate,MessagingDelegate
{

    var window: UIWindow?
    let manager = CLLocationManager()
    var bgTask : UIBackgroundTaskIdentifier!
    
   
    
    let SocketManager = SocketIOClient(socketURL: URL(string: "https://pickngolk.info:8081")!, config: [.log(false), .compress])
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        IQKeyboardManager.sharedManager().enable = true
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        
        let img = UIImage(named: "menu")
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        imgView.image = img?.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = ThemePinkColor
        imgView.contentMode = .scaleAspectFit
        
        SideMenuController.preferences.drawing.menuButtonImage = imgView.image
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = (window?.frame.width)! - 80
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
         UIApplication.shared.statusBarStyle = .lightContent
       
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController

        // Google Map
    
        GMSPlacesClient.provideAPIKey("AIzaSyCRaduVCKdm1ll3kHPY-ebtvwwPV2VVozo")
        GMSServices.provideAPIKey("AIzaSyCRaduVCKdm1ll3kHPY-ebtvwwPV2VVozo")
        
        // AIzaSyCRaduVCKdm1ll3kHPY-ebtvwwPV2VVozo
        
        manager.delegate = self
        manager.startUpdatingLocation()
        manager.requestAlwaysAuthorization()
        
        if (UserDefaults.standard.object(forKey:  driverProfileKeys.kKeyDriverProfile) != nil)
        {
            self.setDataInSingletonClass()
        }
        else
        {
             Singletons.sharedInstance.isDriverLoggedIN = false
        }
        
        if UserDefaults.standard.object(forKey: "Passcode") as? String == nil {
            Singletons.sharedInstance.setPasscode = ""
        }
        else {
            Singletons.sharedInstance.setPasscode = UserDefaults.standard.object(forKey: "Passcode") as! String
        }
        
        
        // Push Notification Code
        registerForPushNotification()
        
        let remoteNotif = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary
        
        if remoteNotif != nil
        {
            let key = (remoteNotif as! NSDictionary).object(forKey: "gcm.notification.type")!
            NSLog("\n Custom: \(String(describing: key))")
            self.pushAfterReceiveNotification(typeKey: key as! String)
        }
        else {
//            let aps = remoteNotif!["aps" as NSString] as? [String:AnyObject]
            NSLog("//////////////////////////Normal launch")
//            self.pushAfterReceiveNotification(typeKey: "")

        }
        

        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func setDataInSingletonClass()
    {
        Singletons.sharedInstance.dictDriverProfile = NSMutableDictionary(dictionary:UserDefaults.standard.object(forKey:  driverProfileKeys.kKeyDriverProfile) as! NSDictionary)
        Singletons.sharedInstance.strDriverID = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "Vehicle") as! NSDictionary).object(forKey: "DriverId") as! String
        Singletons.sharedInstance.isDriverLoggedIN = UserDefaults.standard.object(forKey: driverProfileKeys.kKeyIsDriverLoggedIN) as! Bool
        
        if UserDefaults.standard.object(forKey: "DriverDuty") as? String == nil {
            
            Singletons.sharedInstance.driverDuty = "0"
        }
        else {
            Singletons.sharedInstance.driverDuty = UserDefaults.standard.object(forKey: "DriverDuty") as! String
        }
        
        
        if let passOn = UserDefaults.standard.object(forKey: "isPasscodeON") as? Bool {
            
            if passOn == false {
                
                Singletons.sharedInstance.isPasscodeON = false
            }
            else {
                Singletons.sharedInstance.isPasscodeON = true
            }
        }
        else
        {
            
            Singletons.sharedInstance.isPasscodeON = false
            UserDefaults.standard.set(Singletons.sharedInstance.isPasscodeON, forKey: "isPasscodeON")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation = locations.last!
        
//        defaultLocation = location
        
        Singletons.sharedInstance.latitude = location.coordinate.latitude
        Singletons.sharedInstance.longitude = location.coordinate.longitude
        
        if locations.first != nil {
//            print("location:: (location)")
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        print("App is in Background mode")
        SocketManager.connect()
        SocketManager.on(clientEvent: .connect) {data, ack in
            print ("socket connected")
            
        }
//        //  Converted to Swift 4 by Swiftify v4.1.6600 - https://objectivec2swift.com/
//        bgTask = application.beginBackgroundTask(withName: "MyTask", expirationHandler: {() -> Void in
//            // Clean up any unfinished task business by marking where you
//            // stopped or ending the task outright.
//
//            application.endBackgroundTask(self.bgTask)
//            self.bgTask = UIBackgroundTaskInvalid
//        })
//        // Start the long-running task and return immediately.
//        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
//            // Do the work associated with the task, preferably in chunks.
//            application.endBackgroundTask(self.bgTask)
//            self.bgTask = UIBackgroundTaskInvalid
//        })

        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if let isSwitchOn = UserDefaults.standard.object(forKey: "isPasscodeON") as? Bool {
            Singletons.sharedInstance.isPasscodeON = isSwitchOn
        }
        let passCode = Singletons.sharedInstance.setPasscode
        
        
        
        if (passCode != "" && Singletons.sharedInstance.isPasscodeON) {
            
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewControlleripad = mainStoryboard.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
            initialViewControlleripad.isFromAppDelegate = true
            self.window?.rootViewController?.present(initialViewControlleripad, animated: true, completion: nil)
        }
        
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        SocketManager.disconnect()
    }

    // Push Notification Methods
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        _ = deviceToken.map({ (data)-> String in
            return String(format: "%0.2.2hhx", data)
        })
//        let token = toketParts.joined()
        Messaging.messaging().apnsToken = deviceToken as Data
        if let fcmToken = Messaging.messaging().fcmToken
        {
            Singletons.sharedInstance.deviceToken = fcmToken
        }
        UserDefaults.standard.set(Singletons.sharedInstance.deviceToken, forKey: "Token")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")!

        if(application.applicationState == .background)
        {
            self.pushAfterReceiveNotification(typeKey: key as! String)
        }
        else
        {
            let data = ((userInfo["aps"]! as! [String : AnyObject])["alert"]!) as! [String : AnyObject]
            
            
            let alert = UIAlertController(title: appName.kAPPName,
                                          message: data["title"] as? String,
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "Get Details", style: .default, handler: { (action) in
                self.pushAfterReceiveNotification(typeKey: key as! String)

            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { (action) in
                
            }))
            
            //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
           // self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
//        let data = ((userInfo["aps"]! as! [String : AnyObject])["alert"]!) as! [String : AnyObject]
      //  UtilityClass.showAlert(data["title"] as! String, message: data["body"] as! String, vc: (self.window?.rootViewController)!)
         print(userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        
   
        completionHandler()
    }
    
    
    
    
    //-------------------------------------------------------------
    // MARK: - Push Notification Methods
    //-------------------------------------------------------------
    
    func registerForPushNotification() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
            
            print("Permissin granted: \(granted)")
        
            self.getNotificationSettings()
            
        })
        
    }
    
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {(settings) in
            
            print("Notification Settings: \(settings)")
            
            
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                
            }
            
        })
    }
    
    //-------------------------------------------------------------
    // MARK: - FireBase Methods
    //-------------------------------------------------------------
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        let token = Messaging.messaging().fcmToken
        Singletons.sharedInstance.deviceToken = token!
        UserDefaults.standard.set(Singletons.sharedInstance.deviceToken, forKey: "Token")
        print("FCM token: \(token ?? "")")
        
    }
    
    
    func pushAfterReceiveNotification(typeKey : String)
    {
     
        if(typeKey == "AddMoney")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "WalletHistoryViewController")
                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "TransferMoney")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "WalletHistoryViewController")
                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    
                })
                
              
                
                
            }
        }
//        else if(typeKey == "Tickpay")
//        {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                let tabbarvc = (((((((self.window?.rootViewController as! UINavigationController).viewControllers[1].childViewControllers.last!) as! MenuController).navigationController)?.childViewControllers.last) as! CustomSideMenuViewController).childViewControllers[0] as! UINavigationController).childViewControllers[0] as! TabbarController
//
//                tabbarvc.selectedIndex = 4
//            }
//        }
        else if(typeKey == "RejectDispatchJobRequest")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                let navController = self.window?.rootViewController as? UINavigationController
//                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "PastJobsListVC")
//                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
//
//                })
                
                let tabBarTemp = (((self.window?.rootViewController as! UINavigationController).childViewControllers.last as! CustomSideMenuViewController).childViewControllers[0] as! UINavigationController).childViewControllers[0] as! TabbarController
                
                tabBarTemp.selectedIndex = 1
                let MyJob = tabBarTemp.childViewControllers[1] as! MyJobsViewController
                
                MyJob.btnPastJobsClicked(MyJob.btnPastJobs)
            }
        }
        else if(typeKey == "BookLaterDriverNotify")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                let navController = self.window?.rootViewController as? UINavigationController
//                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "FutureBookingVC")
//                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
//
                
//                    let tabbarvc = (((((((self.window?.rootViewController as! UINavigationController).viewControllers[1].childViewControllers.last!) as! MenuController).navigationController)?.childViewControllers.last) as! CustomSideMenuViewController).childViewControllers[0] as! UINavigationController).childViewControllers[0] as! TabbarController
//                    Singletons.sharedInstance.isFromNotification = true
//
//                    tabbarvc.selectedIndex = 1
                
                let tabBarTemp = (((self.window?.rootViewController as! UINavigationController).childViewControllers.last as! CustomSideMenuViewController).childViewControllers[0] as! UINavigationController).childViewControllers[0] as! TabbarController
                 Singletons.sharedInstance.isFromNotification = true
                tabBarTemp.selectedIndex = 1
               
//                }
            }
        }
        
      
  


    }

}

