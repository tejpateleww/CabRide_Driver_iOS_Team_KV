//
//  InviteDriverViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 14/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import MessageUI
import Social
import SDWebImage

class InviteDriverViewController: ParentViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    
    var strReferralCode = String()
    var strReferralMoney = String()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let profileData = Singletons.sharedInstance.dictDriverProfile
        
        if let ReferralCode = (profileData?.object(forKey: "profile") as! NSDictionary).object(forKey: "ReferralCode") as? String {
            strReferralCode = ReferralCode
            lblReferralCode.text = strReferralCode
        }
        
        if let RefarMoney = (profileData?.object(forKey: "profile") as! NSDictionary).object(forKey: "ReferralAmount") as? Double {
            strReferralMoney = String(RefarMoney)
            lblReferralMoney.text = "\(currency) \(strReferralMoney)"
        }
        
        if let imgProfile = (profileData?.object(forKey: "profile") as! NSDictionary).object(forKey: "Image") as? String {
            
            imgProfilePick.sd_setImage(with: URL(string: imgProfile), completed: nil)
        }
        
       

        headerView?.btnBack.addTarget(self, action: #selector(self.nevigateToBack), for: .touchUpInside)
        
        imgProfilePick.layer.cornerRadius = imgProfilePick.frame.width / 2
        imgProfilePick.layer.masksToBounds = true
        imgProfilePick.layer.borderWidth = 1.0
        imgProfilePick.layer.borderColor = UIColor.black.cgColor
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet var imgProfilePick: UIImageView!
    @IBOutlet weak var lblReferralCode: UILabel!
    @IBOutlet weak var lblReferralMoney: UILabel!
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    func nevigateToBack()
    {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: TabbarController.self) {
                self.sideMenuController?.embed(centerViewController: controller)
                break
            }
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnFacebook(_ sender: UIButton) {

        
        let fbController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let completionHandler: SLComposeViewControllerCompletionHandler = {(_ result: SLComposeViewControllerResult) -> Void in
                fbController?.dismiss(animated: true) { _ in }
                switch result {
                case .done:
                    print("Posted.")
                case .cancelled:
                    fallthrough
                default:
                    print("Cancelled.")
                }
            }
            fbController?.setInitialText("Check out this article.")
            fbController?.completionHandler = completionHandler
            self.present(fbController!, animated: true) { _ in }
        }
        else {
            if let fbSignInDialog = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
                fbSignInDialog.setInitialText(codeToSend())
                self.present(fbSignInDialog, animated: false) { _ in }
        }
            else {
                UtilityClass.showAlert(appName.kAPPName, message: "Please install Facebook app", vc: self)
            }
        }
        
    }
    
    @IBAction func btnTwitter(_ sender: UIButton) {

        
        let TWController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let completionHandler: SLComposeViewControllerCompletionHandler = {(_ result: SLComposeViewControllerResult) -> Void in
                TWController?.dismiss(animated: true) { _ in }
                switch result {
                case .done:
                    print("Posted.")
                case .cancelled:
                    fallthrough
                default:
                    print("Cancelled.")
                }
            }
            TWController?.setInitialText("Check out this article.")
            TWController?.completionHandler = completionHandler
            self.present(TWController!, animated: true) { _ in }
        }
        else {
            if let twitterSignInDialog = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            
                twitterSignInDialog.setInitialText(codeToSend())
                
                if twitterSignInDialog.serviceType == SLServiceTypeTwitter {
                     self.present(twitterSignInDialog, animated: false)
                }
                else {
                    UtilityClass.showAlert(appName.kAPPName, message: "Please install Twitter app", vc: self)
                }
                
            }
            else {
               UtilityClass.showAlert(appName.kAPPName, message: "Please install Twitter app", vc: self)
            }
            
        }
    }
    
    @IBAction func btnEmail(_ sender: UIButton) {
        
        let emailTitle = ""
        
        //Driver name has invited you to become a TiCKTOC Driver.
        let toRecipents = [""]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(codeToSend(), isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.present(mc, animated: true, completion: nil)
        
    }
    
    @IBAction func btnWhatsApp(_ sender: UIButton) {
        
        let urlStringEncoded = codeToSend().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
        
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        } else {
            
            UtilityClass.showAlert(appName.kAPPName, message: "Please install WhatsApp app", vc: self)

        }
    }
    
    @IBAction func btnSMS(_ sender: UIButton) {
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = codeToSend()
            controller.recipients = [""]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
            UtilityClass.showAlert(appName.kAPPName, message: "Mail cancelled", vc: self)
        case MFMailComposeResult.saved:
            print("Mail saved")
            UtilityClass.showAlert(appName.kAPPName, message: "Mail saved", vc: self)
        case MFMailComposeResult.sent:
            print("Mail sent")
            UtilityClass.showAlert(appName.kAPPName, message: "Mail sent", vc: self)
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
            UtilityClass.showAlert(appName.kAPPName, message: "Mail sent failure: \(String(describing: error?.localizedDescription))", vc: self)
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        switch result {
        case MessageComposeResult.cancelled:
            print("Mail cancelled")
            UtilityClass.showAlert(appName.kAPPName, message: "Message cancelled", vc: self)
        case MessageComposeResult.sent:
            print("Mail sent")
            UtilityClass.showAlert(appName.kAPPName, message: "Message sent", vc: self)
        case MessageComposeResult.failed:
            print("Mail sent failure")
            break
        }
        self.dismiss(animated: true, completion: nil)
    }

    
    func codeToSend() -> String
    {
        let profile =  NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary))
        let driverFullName = profile.object(forKey: "Fullname") as! String
        let messageBody = "\(driverFullName) has invited you to become a TiCKTOC Driver"
        let androidLink = "Android click \("")"
        let iosLink = "iOS click \("https://itunes.apple.com/us/app/ticktoc-driver/id1034261927?ls=1&mt=8")"
        let yourInviteCode = "Your invite code is: \(strReferralCode)"
        let urlOfTick = "www.ticktoc.net www.facebook.com/ticktoc.net"
        
        let urlString = "\(messageBody) \n \(androidLink) \n \(iosLink) \n \(yourInviteCode) \n \(urlOfTick)" as String
        return urlString
    }
    
}
