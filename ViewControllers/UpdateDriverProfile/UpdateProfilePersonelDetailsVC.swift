//
//  UpdateProfilePersonelDetailsVC.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 16/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage

class UpdateProfilePersonelDetailsVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDelegate,UITextFieldDelegate {
    
    var aryCompanyIDS = [[String:AnyObject]]()
    var companyID = String()
    
     var dictData = [String:AnyObject]()

    let thePicker = UIPickerView()
    let datePicker = UIDatePicker()
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thePicker.delegate = self
        showDatePicker()
//        viewGenders.layer.borderWidth = 1
//        viewGenders.layer.masksToBounds = true
//        viewGenders.layer.borderColor = UIColor.gray.cgColor
        
        txtMobile.delegate = self
        txtPostCode.delegate = self
        
        webserviceCallToGetCompanyList()
        setData()
        
    }
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "donedatePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelDatePicker")
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        txtDOB.inputAccessoryView = toolbar
        // add datepicker to textField
        txtDOB.inputView = datePicker
        
    }
    func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        txtDOB.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2
        btnEditProfileIPic.layer.cornerRadius = btnEditProfileIPic.frame.size.width / 2
        btnEditProfileIPic.layer.masksToBounds = true
        imgProfile.layer.borderWidth = 1.0
        imgProfile.layer.borderColor = ThemePinkColor.cgColor
        imgProfile.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        thePicker.reloadAllComponents()
        thePicker.reloadInputViews()
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    @IBOutlet var btnOthers: UIButton!
    @IBOutlet weak var viewGenders: UIView!
    
    @IBOutlet weak var txtCompanyID: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtSuburb: UITextField!
    
    @IBOutlet weak var btnEditProfileIPic: UIButton!
   
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func selectedMale()
    {
        btnMale.setImage(UIImage(named: "iconCheckMarkSelected"), for: .normal)
        btnFemale.setImage(UIImage(named: "iconCheckMarkUnSelected"), for: .normal)
        btnOthers.setImage(UIImage(named: "iconCheckMarkUnSelected"), for: .normal)
    }
    func selectedFemale()
    {
        btnMale.setImage(UIImage(named: "iconCheckMarkUnSelected"), for: .normal)
        btnFemale.setImage(UIImage(named: "iconCheckMarkSelected"), for: .normal)
        btnOthers.setImage(UIImage(named: "iconCheckMarkUnSelected"), for: .normal)
    }
    func selectedOthers()
    {
        btnMale.setImage(UIImage(named: "iconCheckMarkUnSelected"), for: .normal)
        btnFemale.setImage(UIImage(named: "iconCheckMarkUnSelected"), for: .normal)
        btnOthers.setImage(UIImage(named: "iconCheckMarkSelected"), for: .normal)
    }

    
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
            imgProfile.contentMode = .scaleToFill
            imgProfile.image = pickedImage
            
            btnEditProfileIPic.imageView?.image = pickedImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // For Mobile Number
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
//        if textField == txtMobileNumber {
//            let resultText: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
////            return (resultText?.count ?? 0) <= 10
//
//            if resultText!.count >= 11 {
//                return false
//            }
//            else {
//                return true
//            }
//        }
        
//         if textField == txtPostCode {
//            let resText: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
//
//            if resText!.count >= 7 {
//                return false
//            }
//            else {
//                return true
//            }
//        }
     
        return true
    }

    

    
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func txtCompanyId(_ sender: UITextField) {
        
        
    }
    
    @IBAction func btnMale(_ sender: UIButton) {
        selectedMale()
    }
    @IBAction func btnFemale(_ sender: UIButton) {
        selectedFemale()
    }
    @IBAction func btnOthers(_ sender: UIButton) {
        selectedOthers()
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        getData()
        
    }
    
    @IBAction func btnEditProfileIPic(_ sender: UIButton) {
        
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
    // MARK: - Webservice all for company list
    //-------------------------------------------------------------
    
    func webserviceCallToGetCompanyList()
    {
        webserviceForCompanyList([] as AnyObject) { (data, status) in
            self.aryCompanyIDS  = (data as! NSDictionary).object(forKey: "company") as! [[String : AnyObject]]
//            self.webserviceCallForGetDriverProfile()
            self.setData()
            
        }
    }
    
    
    func setData()
    {
         let profile: NSMutableDictionary = NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary))
          
            //aryCompanyIDS = UserDefaults.standard.object(forKey: OTPCodeStruct.kCompanyList) as! [[String : AnyObject]]

            
            txtMobile.text           = profile.object(forKey: "MobileNo") as? String
            txtFullName.text        = profile.object(forKey: "Fullname") as? String
//            txtMobileNumber.text    = profile.object(forKey: "MobileNo") as? String
            txtAddress.text         = profile.object(forKey: "Address") as? String
            txtPostCode.text        = profile.object(forKey: "ZipCode") as? String
//            txtCity.text            = profile.object(forKey: "City") as? String
//            txtState.text           = profile.object(forKey: "State") as? String
//            txtCountry.text         = profile.object(forKey: "Country") as? String
//            txtSuburb.text          = profile.object(forKey: "SubUrb") as? String
        
//        let array = self.aryCompanyIDS as NSArray
        
//        for id in array
//        {
//            if ((id as! NSDictionary).object(forKey: "Id") as! String == profile.object(forKey: "CompanyId") as! String )
//            {
////                self.txtCompanyID.text = (id as! NSDictionary).object(forKey: "CompanyName") as? String
////                self.companyID = ((id as! NSDictionary).object(forKey: "Id") as? String)!
//            }
//        }

//         txtCompanyID.text       = (self.aryCompanyIDS as NSArray).filtered(using: "") as? String
        
        imgProfile.sd_setImage(with: URL(string: profile.object(forKey: "Image") as! String))
        
        let strGender = profile.object(forKey: "Gender") as? String
        thePicker.reloadAllComponents()

        if strGender == "Male" {
            selectedMale()
        } else if strGender == "Female" {
            selectedFemale()
        } else {
            selectedOthers()
        }
        
        
    }
    func getData()
    {
        let profile: NSMutableDictionary = NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as? NSDictionary)!)
        let Vehicle: NSMutableDictionary = NSMutableDictionary(dictionary: profile.object(forKey: "Vehicle") as! NSDictionary)

        
        let driverID = profile.object(forKey: "Id") as? String
//        let companyId = Vehicle.object(forKey: "CompanyId") as? String
        
        var genderSet = String()
        
        if (btnMale.currentImage?.isEqual(UIImage(named: "iconCheckMarkSelected")))! {
            genderSet = "Male"
            
        }
        else if (btnFemale.currentImage?.isEqual(UIImage(named: "iconCheckMarkSelected")))! {
            genderSet = "Female"
            
        }
        else if (btnOthers.currentImage?.isEqual(UIImage(named: "iconCheckMarkSelected")))! {
            genderSet = "Other"
            
        }
        else {
            genderSet = "Male"
            
        }
        // DriverId,CompanyId,Fullname,Gender,Address,Suburb,Zipcode,City,State,Country,DriverImage
        
        dictData["DriverId"] = driverID as AnyObject
        dictData["CompanyId"] = companyID as AnyObject
        dictData["Fullname"] = txtFullName.text as AnyObject
        dictData["Gender"] = genderSet as AnyObject
        dictData["Address"] = txtAddress.text as AnyObject
        dictData["DOB"] = txtDOB.text as AnyObject
        dictData["Zipcode"] = txtPostCode.text as AnyObject

        
        if imgProfile.image == nil {
            UtilityClass.showAlert("Missing", message: "Profile picture is required", vc: self)
        }
        else {
            
            if (validations()) {
                self.webserviceForSave()
            }
            
        }
       
    }
    
   
    
    
    
   
    
    //-------------------------------------------------------------
    // MARK: - Webservice For Save Data
    //-------------------------------------------------------------
    
//    func webserviceCallForGetDriverProfile()
//    {
//
//
//        webserviceForGetDriverProfile(((((UserDefaults.standard.object(forKey: "driverProfile") as! NSDictionary).object(forKey: "profile") as! NSDictionary).object(forKey: "Id"))!) as AnyObject) { (data, status) in
//            print(data)
//
//            self.setData()
//        }
//    }
//
    func webserviceForSave()
        
    {
        webserviceForUpdateDriverProfile(dictData as AnyObject, image: imgProfile.image!) { (result, status) in
            
            if (status) {
                print(result)
                
                Singletons.sharedInstance.dictDriverProfile = NSMutableDictionary(dictionary: (result as! NSDictionary))
                Singletons.sharedInstance.isDriverLoggedIN = true
                
                UserDefaults.standard.set(Singletons.sharedInstance.dictDriverProfile, forKey: driverProfileKeys.kKeyDriverProfile)
                UserDefaults.standard.set(true, forKey: driverProfileKeys.kKeyIsDriverLoggedIN)
                
                let alert = UIAlertController(title: nil, message: "Updated Successfully", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
                
                //                Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") = (result as! NSMutableDictionary)
                //
                //                UserDefaults.standard.set(Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile"), forKey: driverProfileKeys.kKeyDriverProfile)
                
            } else {
                print(result)
                if let res = result as? String {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary
                {
//                    if (newString as? NSNull) == NSNull()
                    
                    if (resDict.object(forKey: "message")  as? NSNull) != nil
                    {
                         UtilityClass.showAlert(appName.kAPPName, message: "Something went wrong!", vc: self)
                    }
                    else
                    {
                         UtilityClass.showAlert(appName.kAPPName, message: (resDict.object(forKey: "message") as? String)!, vc: self)
                    }
                    
//                    if(((resDict.object(forKey: "message") as! String)as? NSNull) == NSNull())
//                        {
//                             UtilityClass.showAlert(appName.kAPPName, message: "Something went wrong!", vc: self)
//                        }
//                        else
//
//                        {
//                         UtilityClass.showAlert(appName.kAPPName, message: (resDict.object(forKey: "message") as? String)!, vc: self)
//                        }
                   
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
            
            
        }
    }
    
    func validations() -> Bool
    {

        if (txtAddress.text?.count == 0)
        {
            UtilityClass.showAlert(appName.kAPPName, message: "Enter Address", vc: self)
            return false
        }
        else if (txtDOB.text?.count == 0)
        {
            UtilityClass.showAlert(appName.kAPPName, message: "Enter Date of Birth", vc: self)
            return false
        }
        else if (txtFullName.text?.count == 0)
        {
            UtilityClass.showAlert(appName.kAPPName, message: "Enter Full Name", vc: self)
            return false
        }
        else if (txtPostCode.text?.count == 0)
        {
            UtilityClass.showAlert(appName.kAPPName, message: "Enter Post Code", vc: self)
            return false
        }
        
        return true
    }
    
    
    
    
}
