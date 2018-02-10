//
//  DriverSelectVehicleTypesViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 24/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class DriverSelectVehicleTypesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate
{

    
    var userDefault = UserDefaults.standard
    var aryDataCarsAndTaxi = [[String : AnyObject]]()
    
    var allElemsContainedCarsandTaxi = Bool()
    var allElemsContainedDeliveryServices = Bool()
    
    var aryCarModelID = [String]()
    
    @IBOutlet var btnNext: UIButton!
    var aryDataCarsAndTaxiIDs = [String]()
    var aryDataDeliveryServicesIDs = [String]()
    
    var aryDataCarsAndTaxiVehicleTypes = [String]()
    var aryDataDeliveryServicesVehicleTypes = [String]()
    var strVehicleClass = String()
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        viewbtnCarsAndTexis.layer.borderWidth = 1
        viewbtnDeliveryService.layer.borderWidth = 1
        
        viewbtnCarsAndTexis.layer.cornerRadius = 3
        viewbtnDeliveryService.layer.cornerRadius = 3
        
        viewbtnCarsAndTexis.layer.masksToBounds = true
        viewbtnDeliveryService.layer.masksToBounds = true
        
//        imgVehicle.layer.cornerRadius = imgVehicle.frame.size.width / 2
//        imgVehicle.layer.masksToBounds = true
        
        
        
//         CarAndTexis()
        
        viewCarsAndTexis.isHidden = true
        viewDeliveryService.isHidden = true
        
        self.webserviceforGetCarModels()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        btnNext.layer.cornerRadius = btnNext.frame.size.height/2
        btnNext.clipsToBounds = true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == txtCarType
        {
            
            Singletons.sharedInstance.boolTaxiModel = true
            userDefault.set(Singletons.sharedInstance.boolTaxiModel, forKey: "boolTaxiModel")
            
            let sb = Snackbar()
            if txtVehicleRegistrationNumber.text == "" {
                
                sb.createWithAction(text: "Enter Vehicle Registration No.", actionTitle: "OK", action: { print("Button is push") })
                sb.show()
            }
            else if txtCompany.text == "" {
                
                sb.createWithAction(text: "Enter Car model", actionTitle: "OK", action: { print("Button is push") })
                sb.show()
            }
//            else if txtCarType.text == "" {
//
//                sb.createWithAction(text: "Enter Car Type", actionTitle: "OK", action: { print("Button is push") })
//                sb.show()
//            }
            else if imgVehicle.image == nil {
                
                sb.createWithAction(text: "Please Choose Image", actionTitle: "OK", action: { print("Button is push") })
                sb.show()
            } else {
                CarAndTexis()
            }
            
            return false
        }
        
        return true
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
    // MARK: - Actions
    //-------------------------------------------------------------
    
    
    @IBAction func btnCARSandTEXIS(_ sender: UIButton)
    {
        
        Singletons.sharedInstance.boolTaxiModel = true
        userDefault.set(Singletons.sharedInstance.boolTaxiModel, forKey: "boolTaxiModel")
        
        let sb = Snackbar()
        
        if txtCompany.text == "" {
            
            sb.createWithAction(text: "Enter Company Name", actionTitle: "OK", action: { print("Button is push") })
            sb.show()
        }
        else if txtCarType.text == "" {
            
            sb.createWithAction(text: "Enter Car Color", actionTitle: "OK", action: { print("Button is push") })
            sb.show()
        }
        else if txtVehicleRegistrationNumber.text == "" {
            
            sb.createWithAction(text: "Enter Vehicle Registration No.", actionTitle: "OK", action: { print("Button is push") })
            sb.show()
        }
        else if imgVehicle.image == nil {
            
            sb.createWithAction(text: "Please Choose Image", actionTitle: "OK", action: { print("Button is push") })
            sb.show()
        } else {
            CarAndTexis()
        }
        
        
        
//        let driverVC = self.navigationController?.viewControllers.last as! DriverRegistrationViewController
//        let x = self.view.frame.size.width * 4
//        driverVC.scrollObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
        
    }
    @IBAction func btnNext(_ sender: Any)
    {
        let driverVC = self.navigationController?.viewControllers.last as! DriverRegistrationViewController
        
        driverVC.viewCarAttachment.backgroundColor = ThemeYellowColor
        driverVC.imgAttachment.image = UIImage.init(named: iconAttachmentSelect)
        let x = self.view.frame.size.width * 4
        driverVC.scrollObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
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
            
            sb.createWithAction(text: "Enter Car Color", actionTitle: "OK", action: { print("Button is push") })
            sb.show()
        }
        else if txtVehicleRegistrationNumber.text == "" {
            
            sb.createWithAction(text: "Enter Vehicle Registration No.", actionTitle: "OK", action: { print("Button is push") })
            sb.show()
        }
        else if imgVehicle.image == UIImage(named: "iconProfileLocation") {
            
            sb.createWithAction(text: "Please Choose Image", actionTitle: "OK", action: { print("Button is push") })
            sb.show()
        } else {
            DeliveryService()
        }
        
//        let driverVC = self.navigationController?.viewControllers.last as! DriverRegistrationViewController
//        let x = self.view.frame.size.width * 5
//        driverVC.scrollObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
        
    }
    
    
    func CarAndTexis()
    {
        Singletons.sharedInstance.isDriverVehicleTypesViewControllerFilled = true
//        setData()
//        btnCarsAndTexis.setImage(UIImage(named: "iconCheckMarkSelected"), for: .normal)
//        btnDeliveryService.setImage(UIImage(named: "iconCheckMarkUnSelected"), for: .normal)
//
//        viewCarsAndTexis.isHidden = false
//        viewDeliveryService.isHidden = true
        self.performSegue(withIdentifier: "segueCarsAndTaxi", sender: nil)
    }
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
                
               
                
                self.getVehicleName()
                
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
    func getVehicleName()
    {
//        let data = Singletons.sharedInstance.dictDriverProfile
//        print(data!)
        
//        strVehicleClass = (((data?.object(forKey: "profile") as! NSDictionary).object(forKey: "Vehicle") as! NSDictionary).object(forKey: "VehicleClass") as! String)
//        let userCars = strVehicleClass.components(separatedBy: ",")
//
//        let list_Cars_and_taxi = aryDataCarsAndTaxiVehicleTypes
//        let listSet_Cars_and_taxi = Set(list_Cars_and_taxi)
//        let findListSet_Cars_and_taxi = Set(userCars)
//
//        allElemsContainedCarsandTaxi = findListSet_Cars_and_taxi.isSubset(of: listSet_Cars_and_taxi)
        
        
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationOfCarAndTaxi = segue.destination as? CarAndTaxiesVC {
            destinationOfCarAndTaxi.delegate = self as? getVehicleIdAndNameDelegate
            destinationOfCarAndTaxi.delegateForEstimate = self as? getEstimateFareForDispatchJobs
            destinationOfCarAndTaxi.aryData = self.aryDataCarsAndTaxi as NSArray
        }
    }
    
    
    func DeliveryService()
    {
        Singletons.sharedInstance.isDriverVehicleTypesViewControllerFilled = true
        setData()
        btnCarsAndTexis.setImage(UIImage(named: "iconCheckMarkUnSelected"), for: .normal)
        btnDeliveryService.setImage(UIImage(named: "iconCheckMarkSelected"), for: .normal)
        
        viewCarsAndTexis.isHidden = true
        viewDeliveryService.isHidden = false
    }
    
    
    @IBAction func btnChoosePicture(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Options", message: nil, preferredStyle: .alert)
        
        let Gallery = UIAlertAction(title: "Gallery", style: .default, handler: { ACTION in
            self.PickingImageFromGallery()
        })
        let Camera  = UIAlertAction(title: "Camera", style: .default, handler: { ACTION in
            self.PickingImageFromCamera()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(Gallery)
        alert.addAction(Camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    

    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func PickingImageFromGallery()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        
        // picker.stopVideoCapture()
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func PickingImageFromCamera()
    {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgVehicle.contentMode = .scaleToFill
            imgVehicle.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // ------------------------------------------------------------
    
    func setData()
    {
        let vehicleNumber = txtVehicleRegistrationNumber.text
        let VehiclaName = txtCompany.text
        let vehicleColor = txtCarType.text
        
        let imageData: NSData = UIImagePNGRepresentation(imgVehicle.image!)! as NSData
        let myEncodedImageData: NSData = NSKeyedArchiver.archivedData(withRootObject: imageData) as NSData
         userDefault.set(myEncodedImageData, forKey: RegistrationFinalKeys.kVehicleImage)
     
        
        userDefault.set(vehicleNumber, forKey: RegistrationFinalKeys.kVehicleRegistrationNo)
        userDefault.set(VehiclaName, forKey: RegistrationFinalKeys.kCompanyModel)
        userDefault.set(vehicleColor, forKey: RegistrationFinalKeys.kVehicleColor)
       
    }
    
    
    // ------------------------------------------------------------
    
    
    
    
    

}
