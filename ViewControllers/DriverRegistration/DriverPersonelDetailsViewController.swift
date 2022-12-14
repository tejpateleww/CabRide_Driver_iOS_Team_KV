//
//  DriverPersonelDetailsViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 11/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import CoreLocation
import ACFloatingTextfield_Swift
class DriverPersonelDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate  {
    
    @IBOutlet var btnNext: UIButton!
    
    let manager = CLLocationManager()
    
    var currentLocation = CLLocation()
    
    var strLatitude = Double()
    var strLongitude = Double()
    
    var userDefault =  UserDefaults.standard
    
     let datePicker = UIDatePicker()
    var companyID = String()
    
    var aryCompanyIDS = [[String:AnyObject]]()
//        let myDatePicker: UIDatePicker = UIDatePicker()

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    @IBOutlet var btnOthers: UIButton!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtFullName: ACFloatingTextfield!
    @IBOutlet weak var txtDOB: ACFloatingTextfield!
    @IBOutlet weak var txtAddress: ACFloatingTextfield!
    @IBOutlet weak var txtPostCode: ACFloatingTextfield!
   
    @IBOutlet weak var txtInviteCode: ACFloatingTextfield!

    
    var emailID = String()

    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2
        imgProfile.layer.masksToBounds = true
        btnNext.layer.cornerRadius = btnNext.frame.size.height/2
        btnNext.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        showDatePicker()
        txtDOB.delegate = self
        txtPostCode.delegate = self


        
        strLatitude = 0
        strLongitude = 0
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if manager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))
            {
                if manager.location != nil
                {
                    currentLocation = manager.location!
                    
                    strLatitude = currentLocation.coordinate.latitude
                    strLongitude = currentLocation.coordinate.longitude
                }
                
                manager.startUpdatingLocation()
            }
        }
        
        selectedMale()
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
    func cancelDatePicker()
    {
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
 
    @IBAction func btnMale(_ sender: UIButton) {
        selectedMale()
    }
    @IBAction func btnFemale(_ sender: UIButton) {
        selectedFemale()
    }
    @IBAction func btnOthers(_ sender: UIButton) {
        selectedOthers()
    }
    
    
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
    
    @IBAction func btnNext(_ sender: Any)
    {
        checkFields()
    }
    @IBAction func btnLogin(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func TapToProfilePicture(_ sender: UITapGestureRecognizer) {
        
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
    
    
    func PickingImageFromGallery()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        // picker.stopVideoCapture()
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func PickingImageFromCamera()
    {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            imgProfile.contentMode = .scaleToFill
            imgProfile.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveAllDataInArray() -> NSMutableArray {
        
        let arrData = NSMutableArray()
        let dictData = NSMutableDictionary()
        
            dictData.setObject(txtFullName.text!, forKey: RegistrationProfileKeys.kKeyFullName as NSCopying)
            dictData.setObject(txtDOB.text!, forKey: RegistrationProfileKeys.kKeyDOB as NSCopying)
            dictData.setObject(txtAddress.text!, forKey: RegistrationProfileKeys.kKeyAddress as NSCopying)
            dictData.setObject(txtPostCode.text!, forKey: RegistrationProfileKeys.kKeyPostCode as NSCopying)
            dictData.setObject(txtInviteCode.text!, forKey: RegistrationProfileKeys.kKeyInviteCode as NSCopying)
           
            
            arrData.add(dictData)
        
        
        return arrData
  
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
        
    }
    
    func checkFields()
    {
        let sb = Snackbar()
//        sb.createWithAction(text: "Upload Car Registration", actionTitle: "OK", action: { print("Button is push") })

        if txtFullName.text == "" {
            sb.createWithAction(text: "Enter Full Name", actionTitle: "OK", action: { print("Button is push") })
        }
        else if txtDOB.text == "" {
            sb.createWithAction(text: "Enter Date of Birth", actionTitle: "OK", action: { print("Button is push") })
        }
     

        else if txtAddress.text == "" {
             sb.createWithAction(text: "Enter Address", actionTitle: "OK", action: { print("Button is push") })
        }
      
        else if txtPostCode.text == "" {
            sb.createWithAction(text: "Enter Post Code", actionTitle: "OK", action: { print("Button is push") })
        }
      
        else if imgProfile.image == UIImage(named: "iconProfileLocation") {
            sb.createWithAction(text: "Please Choose Image", actionTitle: "OK", action: { print("Button is push") })
        }
        else {
            setData()
        }
        
        sb.show()
    }
    
    func setDataForProfile()
    {
//        txtEmail.text = userDefault.object(forKey: RegistrationFinalKeys.kEmail) as? String
//        aryCompanyIDS = userDefault.object(forKey: OTPCodeStruct.kCompanyList) as! [[String : AnyObject]]
//        thePicker.reloadAllComponents()
//
//
//        txtCompanyId.text = aryCompanyIDS[0]["CompanyName"] as? String
//        companyID = (aryCompanyIDS[0]["Id"] as? String)!
//        txtCity.text = aryCompanyIDS[0]["City"] as? String
//        txtState.text = aryCompanyIDS[0]["State"] as? String
//        txtCountry.text = aryCompanyIDS[0]["Country"] as? String
    }
    
    func setData()
    {
       
        
        let imageData: NSData = UIImagePNGRepresentation(imgProfile.image!)! as NSData
        let myEncodedImageData: NSData = NSKeyedArchiver.archivedData(withRootObject: imageData) as NSData
        userDefault.set(myEncodedImageData, forKey: RegistrationFinalKeys.kDriverImage)
        
        userDefault.set(txtDOB.text, forKey: RegistrationFinalKeys.kKeyDOB)
        userDefault.set(txtFullName.text, forKey: RegistrationFinalKeys.kFullname)
        userDefault.set(txtAddress.text, forKey: RegistrationFinalKeys.kAddress)
        userDefault.set(txtInviteCode.text, forKey: RegistrationFinalKeys.kReferralCode)
        userDefault.set(strLatitude, forKey: RegistrationFinalKeys.kLat)
        userDefault.set(strLongitude, forKey: RegistrationFinalKeys.kLng)
        userDefault.set(txtPostCode.text, forKey: RegistrationFinalKeys.kZipcode)

        
        if (btnMale.currentImage?.isEqual(UIImage(named: "iconCheckMarkSelected")))! {
            userDefault.set("Male", forKey: RegistrationFinalKeys.kGender)
        }
        else if (btnFemale.currentImage?.isEqual(UIImage(named: "iconCheckMarkSelected")))! {
            userDefault.set("Female", forKey: RegistrationFinalKeys.kGender)
        }
        else if (btnOthers.currentImage?.isEqual(UIImage(named: "iconCheckMarkSelected")))! {
            userDefault.set("Other", forKey: RegistrationFinalKeys.kGender)
        }
        else {
            userDefault.set("Male", forKey: RegistrationFinalKeys.kGender)
        }

        navigateToNext()
    }
    
    func navigateToNext()
    {
        let driverVC = self.navigationController?.viewControllers.last as! DriverRegistrationViewController
        let x = self.view.frame.size.width * 2
        driverVC.scrollObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
        driverVC.viewDriverBank.backgroundColor = ThemePinkColor
        driverVC.imgBank.image = UIImage.init(named: iconBankSelect)
        if (self.saveAllDataInArray().count != 0)
        {
            UserDefaults.standard.set(self.saveAllDataInArray(), forKey: savedDataForRegistration.kKeyAllUserDetails)
        }
        UserDefaults.standard.set(2, forKey: savedDataForRegistration.kPageNumber)
    }
    
    // For Mobile Number
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
     
         if textField == txtPostCode {
            let resText: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)

            if resText!.count >= 9 {
                return false
            }
            else {
                return true
            }
        }
        
        return true
    }
  
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
//        if textField == txtDOB
//        {
//            self.view.endEditing(true)
//            Calendar()
//            return false
//        }
        
        return true
    }
    

    func Calendar()
    {
        // make DatePicker
        
        
        // setting properties of the datePicker
//        myDatePicker.frame = CGRect(x:0, y: 50,width: self.view.frame.width, height: 200)
//        myDatePicker.timeZone = NSTimeZone.local
//        myDatePicker.backgroundColor = UIColor.white
//        myDatePicker.layer.cornerRadius = 5.0
//        myDatePicker.layer.shadowOpacity = 0.5
//        myDatePicker.datePickerMode = .date
//        // add an event called when value is changed.
//        myDatePicker.addTarget(self, action: #selector(self.onDidChangeDate(sender:)), for: .valueChanged)
//
//        // add DataPicker to the view
//        self.view.addSubview(myDatePicker)
    }
    
    // called when the date picker called.
    internal func onDidChangeDate(sender: UIDatePicker){
        
        // date format
//        let myDateFormatter: DateFormatter = DateFormatter()
//        myDateFormatter.dateFormat = "yyyy/MM/dd"
//        
//        // get the date string applied date format
//        let mySelectedDate: NSString = myDateFormatter.string(from: sender.date) as NSString
//        txtDOB.text = mySelectedDate as String
//        
//        self.myDatePicker.removeFromSuperview()
    }
    
}
