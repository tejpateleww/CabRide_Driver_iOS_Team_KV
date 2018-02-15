//
//  updateDriverSelectVehicleTypesViewControllerViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 28/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class updateDriverSelectVehicleTypesViewControllerViewController: UIViewController{
    
    
    var userDefault = UserDefaults.standard
    var aryDataCarsAndTaxiIDs = [String]()
    var aryDataDeliveryServicesIDs = [String]()
    var aryDataCarsAndTaxi = [[String : AnyObject]]()

    var aryDataCarsAndTaxiVehicleTypes = [String]()
    var aryDataDeliveryServicesVehicleTypes = [String]()
    var strVehicleClass = String()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Singletons.sharedInstance.isFromRegistration = false
        
        getData()
        
//        viewbtnCarsAndTexis.layer.borderWidth = 1
//        viewbtnDeliveryService.layer.borderWidth = 1
        
//        viewbtnCarsAndTexis.layer.cornerRadius = 3
//        viewbtnDeliveryService.layer.cornerRadius = 3
//
//        viewbtnCarsAndTexis.layer.masksToBounds = true
//        viewbtnDeliveryService.layer.masksToBounds = true
        
//        let profileData = Singletons.sharedInstance.dictDriverProfile
//        if let carType = (profileData?.object(forKey: "profile") as! NSDictionary).object(forKey: "CategoryId") as? String
//        {
//            if carType == "1" {
//                CarAndTexis()
//            }
//            else {
//                 DeliveryService()
//            }
//        }
        
//        let driverVehicleVC = self.childViewControllers.first as! updateDriverVehicleTypesViewController
//        driverVehicleVC.setupVehicleSelection()

        self.webserviceforGetCarModels()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setDataInCarTypeUpdate), name: Notification.Name("setCarTypeUpdate"), object: nil)
    }
    
    @objc func setDataInCarTypeUpdate()
    {
        if UserDefaults.standard.object(forKey: RegistrationFinalKeys.kCarThreeTypeName) != nil
        {
            let carType = UserDefaults.standard.object(forKey: RegistrationFinalKeys.kCarThreeTypeName) as! String
            txtCarType.text = carType
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        
        let profile: NSMutableDictionary = NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary))
            
            
        
        
//        NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
        let Vehicle: NSMutableDictionary = NSMutableDictionary(dictionary: profile.object(forKey: "Vehicle") as! NSDictionary)
        
        
//        txtVehicleRegistrationNumber.text = Vehicle.object(forKey: "VehicleRegistrationNo") as? String
//        txtCompany.text = Vehicle.object(forKey: "Company") as? String
//        txtCarType.text = Vehicle.object(forKey: "Color") as? String
        
        let stringOFVehicleModel: String = Vehicle.object(forKey: "VehicleModel") as! String
        
        let stringToArrayOFVehicleModel = stringOFVehicleModel.components(separatedBy: ",")
        
        Singletons.sharedInstance.arrVehicleClass = NSMutableArray(array: stringToArrayOFVehicleModel.map { Int($0)!})
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    
    @IBOutlet weak var imgVehicle: UIImageView!
    
    @IBOutlet weak var txtVehicleRegistrationNumber: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var txtCarType: UITextField!
    
    
    @IBOutlet weak var btnCarsAndTexis: UIButton!
    @IBOutlet weak var btnDeliveryService: UIButton!
    
    @IBOutlet weak var viewCarsAndTexis: UIView!
    @IBOutlet weak var viewDeliveryService: UIView!
    
    @IBOutlet weak var viewbtnCarsAndTexis: UIView!
    @IBOutlet weak var viewbtnDeliveryService: UIView!
    
    
    //-------------------------------------------------------------
    // MARK: - Actions and Custom Methods
    //-------------------------------------------------------------
    
    
    @IBAction func btnCARSandTEXIS(_ sender: UIButton) {
        
        Singletons.sharedInstance.boolTaxiModel = true
        userDefault.set(Singletons.sharedInstance.boolTaxiModel, forKey: "boolTaxiModel")
        
        let sb = Snackbar()
        
        if txtCompany.text == "" {
            
            sb.createWithAction(text: "Enter Company Name", actionTitle: "OK", action: { print("Button is push") })
            sb.show()
        }
        else if txtCarType.text == ""
        {
            sb.createWithAction(text: "Enter Car Type", actionTitle: "OK", action: { print("Button is push") })
            sb.show()
        }
        else if txtVehicleRegistrationNumber.text == "" {
            
            sb.createWithAction(text: "Enter Vehicle Registration No.", actionTitle: "OK", action: { print("Button is push") })
            sb.show()
        }
        else {
            CarAndTexis()
        }
        
        
        
        //        let driverVC = self.navigationController?.viewControllers.last as! DriverRegistrationViewController
        //        let x = self.view.frame.size.width * 4
        //        driverVC.scrollObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
        
    }
    
    @IBAction func btnDELIVERYservice(_ sender: UIButton) {
        
        Singletons.sharedInstance.boolTaxiModel = false
        userDefault.set(Singletons.sharedInstance.boolTaxiModel, forKey: "boolTaxiModel")
        
        let sb = Snackbar()
        
        if txtCompany.text == "" {
            
            sb.createWithAction(text: "Enter Company Name", actionTitle: "OK", action: { print("Button is push") })
            sb.show()
        }
        else if txtCarType.text == "" {
            
            sb.createWithAction(text: "Enter Car Type", actionTitle: "OK", action: { print("Button is push") })
            sb.show()
        }
        else if txtVehicleRegistrationNumber.text == "" {
            
            sb.createWithAction(text: "Enter Vehicle Registration No.", actionTitle: "OK", action: { print("Button is push") })
            sb.show()
        }
        else  {
            DeliveryService()
        }
        
        
        
        
        //        let driverVC = self.navigationController?.viewControllers.last as! DriverRegistrationViewController
        //        let x = self.view.frame.size.width * 5
        //        driverVC.scrollObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
        
    }
    
    
    func CarAndTexis()
    {
        
//        setData()
//        btnCarsAndTexis.setImage(UIImage(named: "iconCheckMarkSelected"), for: .normal)
//        btnDeliveryService.setImage(UIImage(named: "iconCheckMarkUnSelected"), for: .normal)
//
//        viewCarsAndTexis.isHidden = false
//        viewDeliveryService.isHidden = true
        
        self.performSegue(withIdentifier: "segueCarsAndTaxi", sender: nil)
        
    }
    
    func DeliveryService()
    {
        
        setData()
        btnCarsAndTexis.setImage(UIImage(named: "iconCheckMarkUnSelected"), for: .normal)
        btnDeliveryService.setImage(UIImage(named: "iconCheckMarkSelected"), for: .normal)
        
        viewCarsAndTexis.isHidden = true
        viewDeliveryService.isHidden = false
    }
    

    func setData()
    {
        let vehicleNumber = txtVehicleRegistrationNumber.text
        let VehiclaName = txtCompany.text
        let vehicleColor = txtCarType.text
    
        
        userDefault.set(vehicleNumber, forKey: RegistrationFinalKeys.kVehicleRegistrationNo)
        userDefault.set(VehiclaName, forKey: RegistrationFinalKeys.kCompanyModel)
        userDefault.set(vehicleColor, forKey: RegistrationFinalKeys.kCarThreeTypeName)
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == txtCarType
        {
            self.view.endEditing(true)
            CarAndTexis()
            return false
        }
        
        return true
    }
    func getData()
    {
        let profile: NSMutableDictionary = NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary))
        let Vehicle: NSMutableDictionary = NSMutableDictionary(dictionary: profile.object(forKey: "Vehicle") as! NSDictionary )
        
        
        txtVehicleRegistrationNumber.text = Vehicle.object(forKey: "VehicleRegistrationNo") as? String
        txtCompany.text = Vehicle.object(forKey: "Company") as? String
//        txtCarColor.text = Vehicle.object(forKey: "Color") as? String
        if UserDefaults.standard.object(forKey: RegistrationFinalKeys.kCarThreeTypeName) != nil
        {
            let carType = UserDefaults.standard.object(forKey: RegistrationFinalKeys.kCarThreeTypeName) as! String
            txtCarType.text = carType
        }
        
    }
    
    // ------------------------------------------------------------
    
    var dictData = NSMutableDictionary()
    
    
    
    @IBAction func btnSave(_ sender: Any) {
        
        if (Validations()){
            
            if Singletons.sharedInstance.vehicleClass == "" {
                UtilityClass.showAlert(appName.kAPPName, message: "Please select at least one car type.", vc: self)
            }
            else {
                
                let profile: NSMutableDictionary = NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary))
                
                //            (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile"))!.object(forKey: "profile") as! NSMutableDictionary
                
                let strVehicleClass = Singletons.sharedInstance.vehicleClass
                
                dictData["DriverId"] = profile.object(forKey: "Id") as? String as AnyObject
                dictData["VehicleClass"] = strVehicleClass as AnyObject
                dictData["VehicleColor"] = txtCarType.text as AnyObject
                dictData["CompanyModel"] = txtCompany.text as AnyObject
                dictData["VehicleRegistrationNo"] = txtVehicleRegistrationNumber.text as AnyObject
                
                // DriverId,VehicleClass,VehicleColor,CompanyModel,VehicleRegistrationNo
                
                
                self.webserviceCallForProfileUpdate()
            }
           
        }
        
    }
    
    func Validations() -> Bool {
        
        if (txtVehicleRegistrationNumber.text!.count == 0) {
            UtilityClass.showAlert(appName.kAPPName, message: "Enter Vehicle Registration Number", vc: self)
            return false
        }
        else if (txtCompany.text!.count == 0) {
            UtilityClass.showAlert(appName.kAPPName, message: "Enter Company", vc: self)
            return false
        }
        else if (txtCarType.text!.count == 0) {
            UtilityClass.showAlert(appName.kAPPName, message: "Enter Car Type", vc: self)
            return false
        }
    
        
        return true
    }
    
  
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceforGetCarModels() {
        
        webserviceForVehicalModelList("" as AnyObject) { (result, status) in
            
            if (status)
            {
                print(result)
                
                //                let checkCarModelClass: Bool = Singletons.sharedInstance.boolTaxiModel
                
                
                self.aryDataCarsAndTaxi = result["cars_and_taxi"] as! [[String:AnyObject]]
                
                
                for (i,_) in self.aryDataCarsAndTaxi.enumerated()
                {
                    var dataOFCars = self.aryDataCarsAndTaxi[i]
                    let CarModelID = dataOFCars["Id"] as! String
                    let strCarModelNames = dataOFCars["Name"] as! String
                    self.aryDataCarsAndTaxiIDs.append(CarModelID)
                    self.aryDataCarsAndTaxiVehicleTypes.append(strCarModelNames)
                }
                
                
                
//                self.getVehicleName()
                
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationOfCarAndTaxi = segue.destination as? CarAndTaxiesVC
        {
            destinationOfCarAndTaxi.aryData = self.aryDataCarsAndTaxi as NSArray
        }
    }
    func webserviceCallForProfileUpdate()
    {
        
        webserviceForUpdateDriverProfileUpdateVehicleInfoDetails(dictData as AnyObject) { (result, status) in
            
            if (status) {
//                print(result)
                
                
                Singletons.sharedInstance.dictDriverProfile = NSMutableDictionary(dictionary: (result as! NSDictionary))
                
                UserDefaults.standard.set(Singletons.sharedInstance.dictDriverProfile, forKey: driverProfileKeys.kKeyDriverProfile)
                
                
                let alert = UIAlertController(title: nil, message: "Updated Successfully", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                print(result)
                
                if let res = (result as? String) {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else {
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
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
}
