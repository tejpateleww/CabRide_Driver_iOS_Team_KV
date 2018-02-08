//
//  DriverRegistrationViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 10/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
//import TTSegmentedControl

class DriverRegistrationViewController: UIViewController, UIScrollViewDelegate //SPSegmentControlCellStyleDelegate, SPSegmentControlDelegate
{

    var percentIndicatorViewLabel = String()
     var selectedIndex = Int()
    private let borderColor: UIColor = UIColor(hue: 1, saturation: 0, brightness: 1, alpha: 0.5)
    private let backgroundColor: UIColor = UIColor(hue: 1, saturation: 0, brightness: 1, alpha: 0.08)
    
    
    @IBOutlet var imgDriver: UIImageView!
    @IBOutlet var imgMail: UIImageView!
    @IBOutlet var imgBank: UIImageView!
    @IBOutlet var imgCar: UIImageView!
    @IBOutlet var imgAttachment: UIImageView!
    
    @IBOutlet var viewEmailDriver: UIView!
    @IBOutlet var viewDriverBank: UIView!
    @IBOutlet var viewBankCar: UIView!
    @IBOutlet var viewCarAttachment: UIView!
    
    var arrImageUnselected = [iconMailUnselect, iconDriverUnselect, iconBankUnselect, iconCarUnselect, iconAttachmentUnselect]
    var arrImageSelected = [iconMailSelect, iconDriverSelect, iconBankSelect, iconCarSelect, iconAttachmentSelect]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imgMail.image = UIImage.init(named: iconMailSelect)
        imgDriver.image = UIImage.init(named: iconDriverUnselect)
        imgBank.image = UIImage.init(named: iconBankUnselect)
        imgCar.image = UIImage.init(named: iconCarUnselect)
        imgAttachment.image = UIImage.init(named: iconAttachmentUnselect)
        
        viewEmailDriver.backgroundColor = ThemeGrayColor
        viewDriverBank.backgroundColor = ThemeGrayColor
        viewBankCar.backgroundColor = ThemeGrayColor
        viewCarAttachment.backgroundColor = ThemeGrayColor

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.setNavigationBar()
    }
    
    func setNavigationBar()
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.navigationBar.isTranslucent = true
        

        if self.selectedIndex == 0
        {
            self.navigationItem.titleView = nil
            let lblTitle = UILabel.init(frame: CGRect (x: 0, y: 0, width: 100, height: 30))
            lblTitle.text = "Pick N Go"
            lblTitle.textColor = UIColor.white
            lblTitle.textAlignment = .center
            lblTitle.font = UIFont.init(name: CustomeFontProximaNovaBold, size: 11)
            self.navigationItem.titleView = lblTitle
        }
        else if  self.selectedIndex == 1
        {
            self.navigationItem.titleView = nil
            let lblTitle = UILabel.init(frame: CGRect (x: 0, y: 0, width: 100, height: 30))
            lblTitle.text = "Pick N Go"
            lblTitle.textColor = UIColor.white
            lblTitle.textAlignment = .center
            lblTitle.font = UIFont.init(name: CustomeFontProximaNovaBold, size: 11)
            self.navigationItem.titleView = lblTitle
        }
        else if  self.selectedIndex == 2
        {
            self.navigationItem.titleView = nil
            let img = UIImage(named: kNavIcon)
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imgView.image = img
            // setContent mode aspect fit
            imgView.contentMode = .scaleAspectFit
            self.navigationItem.titleView = imgView

        }
        else if  self.selectedIndex == 3
        {
        self.navigationItem.titleView = nil
            let img = UIImage(named: kNavIcon)
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imgView.image = img
            // setContent mode aspect fit
            imgView.contentMode = .scaleAspectFit
            self.navigationItem.titleView = imgView

        }
        else if  self.selectedIndex == 4
        {
        self.navigationItem.titleView = nil
            let img = UIImage(named: kNavIcon)
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imgView.image = img
            // setContent mode aspect fit
            imgView.contentMode = .scaleAspectFit
            self.navigationItem.titleView = imgView

        }
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage.init()
        self.navigationController?.view.backgroundColor = UIColor.clear
        if self.navigationController?.viewControllers.count == 1
        {
            let btnSideMenu:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: kMenuIcon), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnSidemenuClicked(_:)))
            self.navigationItem.leftBarButtonItem = btnSideMenu
        }
        else
        {
            let btnBack:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: kBackIcon), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnBackClicked(_:)))
            self.navigationItem.leftBarButtonItem = btnBack
        }
    }
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
//    @IBOutlet var segmentController: SPSegmentedControl!
    
    @IBOutlet weak var scrollObj: UIScrollView!
    
    
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var thirdView: UIView!
    @IBOutlet var fourthView: UIView!
    @IBOutlet var fifthView: UIView!
    @IBOutlet var sixthView: UIView!
    
    
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    
    func backButtonClicked() {
        
        if (self.scrollObj.frame.size.width / self.view.frame.width) == 0 {
            
        }
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let pageNo = CGFloat(scrollView.contentOffset.x / scrollView.frame.size.width)
//         headerView?.btnSignOut.isHidden = true
//        if (pageNo >= 2)
//        {
//            headerView?.btnSignOut.isHidden = false
//        }
//        segmentController.selectItemAt(index: Int(pageNo), animated: true)
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnSidemenuClicked(_ sender: Any)
    {
//        self.revealViewController() .revealToggle(animated: true)
    }
    
    @objc @IBAction func btnBackClicked (_ sender: Any)
    {
         navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
//    private func createCell(text: String, image: UIImage) -> SPSegmentedControlCell {
//        let cell = SPSegmentedControlCell.init()
//        cell.label.text = text
////        cell.backgroundColor = UIColor.green
//        cell.label.font = UIFont(name: "Avenir-Medium", size: 13.0)!
//        cell.imageView.image = image
//        return cell
//    }
//
//    private func createImage(withName name: String) -> UIImage
//    {
//        return UIImage.init(named: name)!//.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//    }
//
//
//
//    func selectedState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
//        SPAnimation.animate(0.1, animations:
//            {
////                segmentControlCell.imageView.tintColor = UIColor.clear
//
//                self.selectedIndex = index
//                self.setNavigationBar()
////                                segmentControlCell.imageView.tintColor = UIColor.clear
//
//
//                if self.selectedIndex == 0
//                {
//                    segmentControlCell.imageView.image = UIImage.init(named: self.arrImageSelected[0])
//                }
//                else if self.selectedIndex == 1
//                {
//                   segmentControlCell.imageView.image = UIImage.init(named: self.arrImageSelected[1])
//                }
//                else if self.selectedIndex == 2
//                {
//                    segmentControlCell.imageView.image = UIImage.init(named: self.arrImageSelected[2])
//                }
//                else if self.selectedIndex == 3
//                {
//                   segmentControlCell.imageView.image = UIImage.init(named: self.arrImageSelected[3])
//                }
//                else if self.selectedIndex == 4
//                {
//                    segmentControlCell.imageView.image = UIImage.init(named: self.arrImageSelected[4])
//                }
//
//        })
//
//        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
//            segmentControlCell.label.textColor = UIColor.clear
//
//
//            let x = CGFloat(index) * self.scrollObj.frame.size.width
//            self.scrollObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
//
//        }, completion: nil)
//    }
//
//    func normalState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
//        SPAnimation.animate(0.1, animations: {
//            var i = 1
//            if self.selectedIndex >= index
//            {
////
////                if self.selectedIndex <= 0 {
////                    self.headerView?.btnSignOut.isHidden = true
////                }
////                else {
////                    self.headerView?.btnSignOut.isHidden = true
////                }
//
//                while i <= index {
//                    print(i)
////                    segmentControlCell.imageView.tintColor = UIColor.clear
//                    i = i + 1
//                }
//            }
//            else{
////                segmentControlCell.imageView.tintColor = UIColor.clear
//            }
//
//
//
//        })
//
//        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
//            segmentControlCell.label.textColor = UIColor.white
//        }, completion: nil)
//    }
//
//    func indicatorViewRelativPosition(position: CGFloat, onSegmentControl segmentControl: SPSegmentedControl) {
//        let percentPosition = position / (segmentControl.frame.width - position) / CGFloat(segmentControl.cells.count - 1) * 100
//        let intPercentPosition = Int(percentPosition)
//        self.percentIndicatorViewLabel = "scrolling: \(intPercentPosition)%"
//    }
//
    func setData(companyData: [[String:AnyObject]])
    {
        let company: [[String:AnyObject]] = companyData
//
//        if company == [[:]] {
//            company
//        }
//
//        self.userDefault.set(company, forKey: OTPCodeStruct.kCompanyList)
        
        print("SETDATA")
        
        print("otp = ;")
    }
    
    
    
}

