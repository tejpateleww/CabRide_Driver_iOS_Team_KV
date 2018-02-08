//
//  DriverRegistrationViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 10/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
//import TTSegmentedControl

class DriverRegistrationViewController: ParentViewController, UIScrollViewDelegate, SPSegmentControlCellStyleDelegate, SPSegmentControlDelegate{
   
    var percentIndicatorViewLabel = String()
    
    private let borderColor: UIColor = UIColor(hue: 1, saturation: 0, brightness: 1, alpha: 0.5)
    private let backgroundColor: UIColor = UIColor(hue: 1, saturation: 0, brightness: 1, alpha: 0.08)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let pageNo = CGFloat(scrollObj.contentOffset.x / scrollObj.frame.size.width)
        headerView?.btnSignOut.isHidden = true
        if (pageNo >= 2)
        {
            headerView?.btnSignOut.isHidden = false
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView?.btnBack.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        
       
        
        for segmentedControl in [segmentController] {
            segmentedControl?.layer.borderColor = self.borderColor.cgColor
            segmentedControl?.backgroundColor = UIColor.clear
            segmentedControl?.styleDelegate = self
            segmentedControl?.delegate = self
            
        }
        
        let zFirstCell = self.createCell(
            text: "",
            image: self.createImage(withName: "iconSegMailSelected")
        )
        zFirstCell.layout = .onlyImage
        
        let zSecondCell = self.createCell(
            text: "",
            image: self.createImage(withName: "iconSegOTPSelected")
        )
        zSecondCell.layout = .onlyImage
        
        let zThirdCell = self.createCell(
            text: "",
            image: self.createImage(withName: "iconSegUserProfileSelected")
        )
        zThirdCell.layout = .onlyImage
        
        let zForthCell = self.createCell(
            text: "",
            image: self.createImage(withName: "iconSegVehicleSelected")
        )
        zForthCell.layout = .onlyImage
        
        let zFifthCell = self.createCell(
            text: "",
            image: self.createImage(withName: "iconSegAttachmentSelected")
        )
        zFifthCell.layout = .onlyImage
        
        
        self.segmentController.isRoundedFrame = false
        self.segmentController.add(cells: [zFirstCell, zSecondCell, zThirdCell, zForthCell, zFifthCell])
        
        
        if UserDefaults.standard.object(forKey: savedDataForRegistration.kPageNumber) != nil
        {
            self.segmentController.selectedIndex = UserDefaults.standard.object(forKey: savedDataForRegistration.kPageNumber) as! Int
        }
        scrollObj.isScrollEnabled = false
        segmentController.isUserInteractionEnabled = true
        
//        segmentController.allowDrag = true
//        segmentController.allowChangeThumbWidth = false
//
//        segmentController.itemTitles = ["1","2","3","4","5"]
//
//        segmentController.didSelectItemWith = { (index, title) -> () in
//            print("Selected item \(index)")
//            let x = CGFloat(index) * self.scrollObj.frame.size.width
//            self.scrollObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet var segmentController: SPSegmentedControl!
    
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
         headerView?.btnSignOut.isHidden = true
        if (pageNo >= 2)
        {
            headerView?.btnSignOut.isHidden = false
        }
//        segmentController.selectItemAt(index: Int(pageNo), animated: true)
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    private func createCell(text: String, image: UIImage) -> SPSegmentedControlCell {
        let cell = SPSegmentedControlCell.init()
        cell.label.text = text
        cell.label.font = UIFont(name: "Avenir-Medium", size: 13.0)!
        cell.imageView.image = image
        return cell
    }
    
    private func createImage(withName name: String) -> UIImage {
        return UIImage.init(named: name)!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    }
    
    var selectedIndex = Int()
    
    func selectedState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
        SPAnimation.animate(0.1, animations: {
            segmentControlCell.imageView.tintColor = UIColor.red
          
            self.selectedIndex = index
//                segmentControlCell.imageView.tintColor = UIColor.red
            
            
//            if self.selectedIndex == 1 {
//                self.headerView?.btnSignOut.isHidden = true
//            }
//            else {
//                self.headerView?.btnSignOut.isHidden = false
//            }
            
        })
        
        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
            segmentControlCell.label.textColor = UIColor.black
            
            
            let x = CGFloat(index) * self.scrollObj.frame.size.width
            self.scrollObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
            
        }, completion: nil)
    }
    
    func normalState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
        SPAnimation.animate(0.1, animations: {
            var i = 1
            if self.selectedIndex >= index {
//
//                if self.selectedIndex <= 0 {
//                    self.headerView?.btnSignOut.isHidden = true
//                }
//                else {
//                    self.headerView?.btnSignOut.isHidden = true
//                }
                
                while i <= index {
                    print(i)
                    segmentControlCell.imageView.tintColor = UIColor.red
                    i = i + 1
                }
            }
            else{
                segmentControlCell.imageView.tintColor = UIColor.white
            }

        })
        
        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
            segmentControlCell.label.textColor = UIColor.white
        }, completion: nil)
    }
    
    func indicatorViewRelativPosition(position: CGFloat, onSegmentControl segmentControl: SPSegmentedControl) {
        let percentPosition = position / (segmentControl.frame.width - position) / CGFloat(segmentControl.cells.count - 1) * 100
        let intPercentPosition = Int(percentPosition)
        self.percentIndicatorViewLabel = "scrolling: \(intPercentPosition)%"
    }
    
    func setData(companyData: [[String:AnyObject]])
    {
        let company: [[String:AnyObject]] = companyData
//
//        if company == [[:]] {
//            company
//        }
//
        self.userDefault.set(company, forKey: OTPCodeStruct.kCompanyList)
        
        print("SETDATA")
        
        print("otp = ;")
    }
    
    
    
}

