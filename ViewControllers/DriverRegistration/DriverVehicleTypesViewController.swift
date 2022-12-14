//
//  DriverVehicleTypesViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 11/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class DriverVehicleTypesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var aryOfTitles = [String]()
    var aryyOfDetails = [String]()
    var strOFTopLabel = String()
    var sbView = UIView()
    var ShadowSize = CGSize()
    
    var selectedCells:[Int] = []
    
    var intCarModel: [Int] = []
    var userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        strOFTopLabel = "Please select which vehicle classes you are a part of. Select up to 3 classes of 4-door vehicles. You must be 21 years of age or over."

        ShadowSize = CGSize(width: 1, height: 1)
       
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        
        aryOfTitles = ["First Class","Second Class","Lux Van","Taxi","Economy","Disability","Delivery"]
        aryyOfDetails = ["(All First Class Cars can be a part of Business Class) Mercedes S series, BMW 7 series, Audi A8 & S, Tesla S, X, Porsche Cayenne, Jaguar, All luxury SUV’s.","Caprice, Genesis, Lexus, Mercedes E, BMW 5 Series, VW Touareg, Audi A6, Chrysler 300C. etc","Most modern, minimum 7-seater people movers and SUV’s.","Taxi Drivers.","Most other 4-door vehicles > 2007","(fitted with wheelchair access)","(Any car above can be part of Delivery) Select from 6 types of delivery vehicles here. Bicycle, Motorbike, Car delivery, Van/Trays, 2T truck, 3T truck"]
        
//        tableView.backgroundColor = UIColor.white
        
//        webserviceForVehicleTypes()
        
//         giveShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webserviceForVehicleTypes()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet var firstCalss: UIView!
    @IBOutlet var secondClass: UIView!
    @IBOutlet var luxVanView: UIView!
    @IBOutlet var DeliveryView: UIView!
    @IBOutlet var DisabilityView: UIView!
    @IBOutlet var economicView: UIView!
    @IBOutlet var texiView: UIView!
    // ------------------------------------------------------------
    
    @IBOutlet var tableView: UITableView!
    
    //-------------------------------------------------------------
    // MARK: - Table View Methods
    //-------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if strOFTopLabel == "" {
                return 0
            }
            return 1
        }
        else if section == 1 {
            
            if aryData.count == 0
            {
                return 0
            }
            return aryData.count
        }
        else if section == 2 {
            
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cellTop = tableView.dequeueReusableCell(withIdentifier: "DriverVehicleTypesTOP") as! DriverVehicleTypesTableViewCell
        let cellDetails = tableView.dequeueReusableCell(withIdentifier: "DriverVehicleTypesData") as! DriverVehicleTypesTableViewCell
        let cellBottom = tableView.dequeueReusableCell(withIdentifier: "DriverVehicleTypesTableViewCellNext") as! DriverVehicleTypesTableViewCell
        
        cellTop.selectionStyle = .none
        cellDetails.selectionStyle = .none
        cellBottom.selectionStyle = .none
        
//        cellDetails.layoutIfNeeded()
        
//        tableView.layoutIfNeeded()
        
        
        if indexPath.section == 0 {
            
            return cellTop
        } else if indexPath.section == 1 {
            
            let dictData = aryData[indexPath.row]
            
            cellDetails.classView.layer.borderWidth = 1
            cellDetails.classView.layer.masksToBounds = true
            cellDetails.classView.layer.borderColor = UIColor.gray.cgColor
            
            cellDetails.backgroundColor = UIColor.white
            cellDetails.lblTitlesOFClass.text = dictData["Name"] as? String
            cellDetails.lblClassDetails.text = dictData["Description"] as? String
//            cellDetails.classView.dropShadow(color: .gray, opacity: 1, offSet: ShadowSize, radius: 1, scale: true)

            if (self.selectedCells.contains(indexPath.row))
            {
                cellDetails.btnCheckMark.setImage(UIImage(named: "iconCheckMarkSelected"), for: .normal)
            }
            else
            {
                cellDetails.btnCheckMark.setImage(UIImage(named: "iconCheckMarkUnSelected"), for: .normal)
            }
//            cellDetails.accessoryType = self.selectedCells.contains(indexPath.row) ? .checkmark : .none
            
            return cellDetails
        } else if indexPath.section == 2 {
            
            if self.aryChooseCareModel.count == 0 {
                
//                UtilityClass.showAlert(appName.kAPPName, message: "Please select car model", vc: self)
            }
            else if Singletons.sharedInstance.isDriverVehicleTypesViewControllerFilled == false {
                UtilityClass.showAlert(appName.kAPPName, message: "All fields are required", vc: self)
            }
            else {
                cellBottom.btnNext.addTarget(self, action: #selector(self.MoveToNext), for: .touchUpInside)
            }
            
            return cellBottom
        } else {
            return UITableViewCell()
        }
        
    }
    
    var aryChooseCareModel = [String]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if self.selectedCells.count == 3
        {
            if self.selectedCells.contains(indexPath.row) {
                self.aryChooseCareModel.remove(at: self.selectedCells.index(of: indexPath.row)!)
                self.selectedCells.remove(at: self.selectedCells.index(of: indexPath.row)!)
                
            }
            else
            {
                let sb = Snackbar()
                sb.createWithAction(text: "You can select only three types.", actionTitle: "DISMISS", action: { print("Button is push") })
                sb.show()
            }
            
        } else {
            if self.selectedCells.contains(indexPath.row) {
                self.aryChooseCareModel.remove(at: self.selectedCells.index(of: indexPath.row)!)
                self.selectedCells.remove(at: self.selectedCells.index(of: indexPath.row)!)
                
            } else {
                self.selectedCells.append(indexPath.row)
                self.aryChooseCareModel.append(aryCarModel[indexPath.row])
            }
        }
        
        tableView.reloadData()
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 1 {
//            return 65
//        }
//        return UITableViewAutomaticDimension
//    }
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    
    func MoveToNext()
    {
   
        let joined = aryChooseCareModel.joined(separator: ",")
        userDefault.set(joined, forKey: RegistrationFinalKeys.kVehicleClass)
        
        let driverVC = self.navigationController?.viewControllers.last as! DriverRegistrationViewController
                let x = self.view.frame.size.width * 4
                driverVC.scrollObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
        
//        driverVC.segmentController.selectedIndex = 5
    
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var aryData = [[String:AnyObject]]()
    var aryCarModel = [String]()
    
    func webserviceForVehicleTypes()
    {
        webserviceForVehicalModelList("" as AnyObject) { (result, status) in
            
            if (status)
            {
                print(result)
                
                self.aryData = result["cars_and_taxi"] as! [[String:AnyObject]]
                
                for (i,_) in self.aryData.enumerated()
                {
                    var dataOFCars = self.aryData[i]
                    let CarModelID = dataOFCars["Id"] as! String
                    self.aryCarModel.append(CarModelID)
                }

                self.tableView.reloadData()
                
                //cars_and_taxi
            }
            else
            {
                print(result)
//                let alert = UIAlertController(title: nil, message: result.object(forKey: "message") as? String, preferredStyle: .alert)
//                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alert.addAction(ok)
//                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    // ------------------------------------------------------------
    
    
    
    
    
    
    
}


