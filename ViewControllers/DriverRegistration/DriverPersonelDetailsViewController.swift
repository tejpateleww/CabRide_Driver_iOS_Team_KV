//
//  DriverPersonelDetailsViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 11/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import CoreLocation

class DriverPersonelDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {
    
    let manager = CLLocationManager()
    
    var currentLocation = CLLocation()
    
    var strLatitude = Double()
    var strLongitude = Double()
    
    var userDefault =  UserDefaults.standard
    
    let thePicker = UIPickerView()
    
    var companyID = String()
    
    var aryCompanyIDS = [[String:AnyObject]]()
    

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    @IBOutlet var btnOthers: UIButton!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtInviteCode: UITextField!
    
    
    @IBOutlet weak var txtSuburb: UITextField!
    @IBOutlet weak var txtCompanyId: UITextField!
    
    @IBOutlet weak var txtAccountHolderName: UITextField!
    @IBOutlet weak var txtServiceDescription: UITextField!
    
    @IBOutlet weak var txtABN: UITextField!
    @IBOutlet weak var txtBSB: UITextField!
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtBankAccountNo: UITextField!
    
    var emailID = String()

    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        headerView?.btnSignOut.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thePicker.delegate = self
        

        txtMobileNumber.delegate = self
        
        txtPostCode.delegate = self
        
        viewGender.layer.cornerRadius = 5
        viewGender.layer.borderWidth = 0.3
        viewGender.layer.masksToBounds = true
        viewGender.layer.borderColor = UIColor.gray.cgColor
        
        imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2
        imgProfile.layer.masksToBounds = true
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let aryOFCom: [[String:AnyObject]] = userDefault.object(forKey: OTPCodeStruct.kCompanyList) as? [[String:AnyObject]] {
            aryCompanyIDS = aryOFCom
        }
        if let getEmailId = userDefault.object(forKey: RegistrationFinalKeys.kEmail) as? String {
            emailID = getEmailId
        }
            txtEmail.text = emailID
        
        
        thePicker.reloadAllComponents()
        thePicker.reloadInputViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func txtCompanyId(_ sender: UITextField) {
        
        thePicker.selectedRow(inComponent: 0)
        txtCompanyId.inputView = thePicker

    }
    
    //-------------------------------------------------------------
    // MARK: - Picker Methods
    //-------------------------------------------------------------
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return aryCompanyIDS.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
  
        return aryCompanyIDS[row]["CompanyName"] as? String
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        txtCompanyId.text = aryCompanyIDS[row]["CompanyName"] as? String
        companyID = (aryCompanyIDS[row]["Id"] as? String)!
        
        txtCity.text = aryCompanyIDS[row]["City"] as? String
        txtState.text = aryCompanyIDS[row]["State"] as? String
        txtCountry.text = aryCompanyIDS[row]["Country"] as? String
      
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
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveAllDataInArray() -> NSMutableArray {
        
        let arrData = NSMutableArray()
        let dictData = NSMutableDictionary()
        
        if (txtEmail.text?.count != 0)
        {
            dictData.setObject(txtEmail.text!, forKey: RegistrationProfileKeys.kKeyEmail as NSCopying)
            dictData.setObject(txtFullName.text!, forKey: RegistrationProfileKeys.kKeyFullName as NSCopying)
            dictData.setObject(txtMobileNumber.text!, forKey: RegistrationProfileKeys.kKeyMobileNumber as NSCopying)
            dictData.setObject(txtPassword.text!, forKey: RegistrationProfileKeys.kKeyPassword as NSCopying)
            dictData.setObject(txtAddress.text!, forKey: RegistrationProfileKeys.kKeyAddress as NSCopying)
            dictData.setObject(txtPostCode.text!, forKey: RegistrationProfileKeys.kKeyPostCode as NSCopying)
            dictData.setObject(txtState.text!, forKey: RegistrationProfileKeys.kKeyState as NSCopying)
            dictData.setObject(txtCountry.text!, forKey: RegistrationProfileKeys.kKeyCountry as NSCopying)
            dictData.setObject(txtInviteCode.text!, forKey: RegistrationProfileKeys.kKeyInviteCode as NSCopying)
           
            
            arrData.add(dictData)
        }
        
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
//        let sb = Snackbar()
//        sb.createWithAction(text: "Upload Car Registration", actionTitle: "OK", action: { print("Button is push") })
//
//
//        if txtEmail.text == "" {
//            sb.createWithAction(text: "Email Id not available", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtFullName.text == "" {
//            sb.createWithAction(text: "Enter Full Name", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtMobileNumber.text == "" {
//            sb.createWithAction(text: "Enter Mobile Number", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtPassword.text == "" {
//            sb.createWithAction(text: "Enter Password", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtPassword.text!.count <= 7 {
//            sb.createWithAction(text: "password 8 characters minimum", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtAccountHolderName.text == "" {
//            sb.createWithAction(text: "Enter Account Holder Name", actionTitle: "OK", action: { print("Button is push") })
//        }
//
//        else if txtAddress.text == "" {
//             sb.createWithAction(text: "Enter Address", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtSuburb.text == "" {
//            sb.createWithAction(text: "Enter Suburb", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtPostCode.text == "" {
//            sb.createWithAction(text: "Enter Post Code", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtCity.text == "" {
//            sb.createWithAction(text: "Enter City", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtState.text == "" {
//            sb.createWithAction(text: "Enter State", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtCountry.text == "" {
//            sb.createWithAction(text: "Enter Country", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtCompanyId.text == "" {
//            sb.createWithAction(text: "Select Company ", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtABN.text == "" {
//            sb.createWithAction(text: "Enter ABN", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtServiceDescription.text == "" {
//            sb.createWithAction(text: "Enter Service Description", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtBSB.text == "" {
//            sb.createWithAction(text: "Enter BSB", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtBankName.text == "" {
//            sb.createWithAction(text: "Enter Bank Name", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if txtBankAccountNo.text == "" {
//             sb.createWithAction(text: "Enter Bank Account No", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else if imgProfile.image == UIImage(named: "iconProfileLocation") {
//            sb.createWithAction(text: "Please Choose Image", actionTitle: "OK", action: { print("Button is push") })
//        }
//        else {
            setData()
//        }
        
//        sb.show()
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
//        if companyID == "" {
//            companyID = "0"
//        }
//        
//        let imageData: NSData = UIImagePNGRepresentation(imgProfile.image!)! as NSData
//        let myEncodedImageData: NSData = NSKeyedArchiver.archivedData(withRootObject: imageData) as NSData
//        userDefault.set(myEncodedImageData, forKey: RegistrationFinalKeys.kDriverImage)
//        
//        userDefault.set(txtMobileNumber.text, forKey: RegistrationFinalKeys.kMobileNo)
//        userDefault.set(txtFullName.text, forKey: RegistrationFinalKeys.kFullname)
//        //        userDefault.set(<#T##value: Any?##Any?#>, forKey: RegistrationFinalKeys.kGender)
//        userDefault.set(txtPassword.text, forKey: RegistrationFinalKeys.kPassword)
//        userDefault.set(txtAddress.text, forKey: RegistrationFinalKeys.kAddress)
//        userDefault.set(txtInviteCode.text, forKey: RegistrationFinalKeys.kReferralCode)
//        userDefault.set(strLatitude, forKey: RegistrationFinalKeys.kLat)
//        userDefault.set(strLongitude, forKey: RegistrationFinalKeys.kLng)
//        userDefault.set(txtPostCode.text, forKey: RegistrationFinalKeys.kZipcode)
//
//        
//        userDefault.set(txtCity.text, forKey: RegistrationFinalKeys.kCity)
//        userDefault.set(txtState.text, forKey: RegistrationFinalKeys.kState)
//        userDefault.set(txtCountry.text, forKey: RegistrationFinalKeys.kCountry)
//        
//        userDefault.set(txtSuburb.text, forKey: RegistrationFinalKeys.kSuburb)
//        userDefault.set(companyID, forKey: RegistrationFinalKeys.kCompanyID)
//        userDefault.set(txtAccountHolderName.text, forKey: RegistrationFinalKeys.kbankHolderName)
//        
//        userDefault.set(txtABN.text, forKey: RegistrationFinalKeys.kABN)
//        userDefault.set(txtServiceDescription.text, forKey: RegistrationFinalKeys.kServiceDescription)
//        
//        userDefault.set(txtBSB.text, forKey: RegistrationFinalKeys.kBSB)
//        userDefault.set(txtBankName.text, forKey: RegistrationFinalKeys.kBankName)
//        userDefault.set(txtBankAccountNo.text, forKey: RegistrationFinalKeys.kBankAccountNo)
//        
//        if (btnMale.currentImage?.isEqual(UIImage(named: "iconCheckMarkSelected")))! {
//            userDefault.set("Male", forKey: RegistrationFinalKeys.kGender)
//        }
//        else if (btnFemale.currentImage?.isEqual(UIImage(named: "iconCheckMarkSelected")))! {
//            userDefault.set("Female", forKey: RegistrationFinalKeys.kGender)
//        }
//        else if (btnOthers.currentImage?.isEqual(UIImage(named: "iconCheckMarkSelected")))! {
//            userDefault.set("Other", forKey: RegistrationFinalKeys.kGender)
//        }
//        else {
//            userDefault.set("Male", forKey: RegistrationFinalKeys.kGender)
//        }

        navigateToNext()
    }
    
    func navigateToNext()
    {
        let driverVC = self.navigationController?.viewControllers.last as! DriverRegistrationViewController
                let x = self.view.frame.size.width * 3
                driverVC.scrollObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
//        driverVC.segmentController.selectedIndex = 3
        driverVC.viewBankCar.backgroundColor = ThemeYellowColor
        driverVC.imgCar.image = UIImage.init(named: iconCarSelect)
        if (self.saveAllDataInArray().count != 0)
        {
            UserDefaults.standard.set(self.saveAllDataInArray(), forKey: savedDataForRegistration.kKeyAllUserDetails)
        }
        UserDefaults.standard.set(3, forKey: savedDataForRegistration.kPageNumber)
    }
    
    // For Mobile Number
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtMobileNumber {
            let resultText: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            //            return (resultText?.count ?? 0) <= 10
            
            if resultText!.count >= 11 {
                return false
            }
            else {
                return true
            }
        }
        
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
  
}
