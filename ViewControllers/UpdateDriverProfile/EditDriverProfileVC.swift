//
//  EditDriverProfileVC.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 25/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class EditDriverProfileVC: ParentViewController {

     var crnRadios = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        crnRadios = 5
        giveCornorRadiosToView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func UnWinddBackToProfileVC(segue: UIStoryboardSegue)
    {
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet var viewEditProfile: UIView!
    @IBOutlet var viewVehicleOption: UIView!
    @IBOutlet var viewAccount: UIView!
    @IBOutlet var viewDocument: UIView!
    
    
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func giveCornorRadiosToView()
    {
        viewEditProfile.dropShadow()
        viewVehicleOption.dropShadow()
        viewAccount.dropShadow()
        viewDocument.dropShadow()
        
//        viewEditProfile.layer.cornerRadius = crnRadios
//        viewVehicleOption.layer.cornerRadius = crnRadios
//        viewAccount.layer.cornerRadius = crnRadios
//        viewDocument.layer.cornerRadius = crnRadios

//        viewEditProfile.layer.masksToBounds = true
//        viewVehicleOption.layer.masksToBounds = true
//        viewAccount.layer.masksToBounds = true
//        viewDocument.layer.masksToBounds = true
        
    }
    @IBAction func btnEditProfile(_ sender: UIButton) {
        
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfilePersonelDetailsVC") as! UpdateProfilePersonelDetailsVC
//
//        self.navigationController?.pushViewController(next, animated: true)

        
    }
    @IBAction func btnVehicle(_ sender: UIButton) {
        
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "SelectVehivleUpdatedViewController") as! SelectVehivleUpdatedViewController
//
//        self.navigationController?.pushViewController(next, animated: true)
        
    }
    @IBAction func btnAccount(_ sender: UIButton) {
        
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileAccountVC") as! UpdateProfileAccountVC
//
//        self.navigationController?.pushViewController(next, animated: true)
        
    }
    @IBAction func btnDocument(_ sender: UIButton) {
        
//        let alert = UIAlertController(title: nil, message: "Comming Soon", preferredStyle: .alert)
//        
//        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
//        
//        alert.addAction(ok)
//        
//        self.present(alert, animated: true, completion: nil)
        
//        let alert = UIAlertController(title: nil, message: "Up Comming", preferredStyle: .alert)
//
//        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//        alert.addAction(ok)
//
//        self.present(alert, animated: true, completion: nil)
        
    }

}

extension UIView {
    
    // OUTPUT 1
    func dropShadow()
    {
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = true
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
//        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
   
}

