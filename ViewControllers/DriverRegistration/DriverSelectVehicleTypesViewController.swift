//
//  DriverSelectVehicleTypesViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 24/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class DriverSelectVehicleTypesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var userDefault = UserDefaults.standard
    
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
        
        imgVehicle.layer.cornerRadius = imgVehicle.frame.size.width / 2
        imgVehicle.layer.masksToBounds = true
        
        
        
//         CarAndTexis()
        
        viewCarsAndTexis.isHidden = true
        viewDeliveryService.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    
    @IBOutlet weak var imgVehicle: UIImageView!
    
    @IBOutlet weak var txtVehicleRegistrationNumber: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var txtCarColor: UITextField!
    
    
    @IBOutlet weak var btnCarsAndTexis: UIButton!
    @IBOutlet weak var btnDeliveryService: UIButton!
    
    @IBOutlet weak var viewCarsAndTexis: UIView!
    @IBOutlet weak var viewDeliveryService: UIView!
    
    @IBOutlet weak var viewbtnCarsAndTexis: UIView!
    @IBOutlet weak var viewbtnDeliveryService: UIView!
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    
    @IBAction func btnCARSandTEXIS(_ sender: UIButton) {
        
        Singletons.sharedInstance.boolTaxiModel = true
        userDefault.set(Singletons.sharedInstance.boolTaxiModel, forKey: "boolTaxiModel")
        
        let sb = Snackbar()
        
        if txtCompany.text == "" {
            
            sb.createWithAction(text: "Enter Company Name", actionTitle: "OK", action: { print("Button is push") })
            sb.show()
        }
        else if txtCarColor.text == "" {
            
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
    
    @IBAction func btnDELIVERYservice(_ sender: UIButton) {
        
        Singletons.sharedInstance.boolTaxiModel = false
        userDefault.set(Singletons.sharedInstance.boolTaxiModel, forKey: "boolTaxiModel")
        
        let sb = Snackbar()
        
        if txtCompany.text == "" {
            
            sb.createWithAction(text: "Enter Company Name", actionTitle: "OK", action: { print("Button is push") })
            sb.show()
        }
        else if txtCarColor.text == "" {
            
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
        let vehicleColor = txtCarColor.text
        
        let imageData: NSData = UIImagePNGRepresentation(imgVehicle.image!)! as NSData
        let myEncodedImageData: NSData = NSKeyedArchiver.archivedData(withRootObject: imageData) as NSData
         userDefault.set(myEncodedImageData, forKey: RegistrationFinalKeys.kVehicleImage)
     
        
        userDefault.set(vehicleNumber, forKey: RegistrationFinalKeys.kVehicleRegistrationNo)
        userDefault.set(VehiclaName, forKey: RegistrationFinalKeys.kCompanyModel)
        userDefault.set(vehicleColor, forKey: RegistrationFinalKeys.kVehicleColor)
       
    }
    
    
    // ------------------------------------------------------------
    
    
    
    
    

}
