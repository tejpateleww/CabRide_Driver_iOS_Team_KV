//
//  DriverCertificatesViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 11/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit


class DriverCertificatesViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,WWCalendarTimeSelectorProtocol  {

    
    @IBOutlet var btnDone: UIButton!
    let datePicker: UIDatePicker = UIDatePicker()
    
    var imagePicker = UIImagePickerController()
    var imagePicked = 0
    
    var userDefault = UserDefaults.standard
    
    var imgDriver = UIImage()
    var imgVehicle = UIImage()
    
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        giveShadow()
        
        
        imagePicker.delegate = self
       
        
/*
        imgDriverLicence.layer.cornerRadius = imgDriverLicence.frame.size.width / 2
        imgDriverLicence.layer.masksToBounds = true
        imgAccreditationCertifi.layer.cornerRadius = imgAccreditationCertifi.frame.size.width / 2
        imgAccreditationCertifi.layer.masksToBounds = true
        imgCarRegistration.layer.cornerRadius = imgCarRegistration.frame.size.width / 2
        imgCarRegistration.layer.masksToBounds = true
        imgVehicleInsurience.layer.cornerRadius = imgVehicleInsurience.frame.size.width / 2
        imgVehicleInsurience.layer.masksToBounds = true
*/
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        btnDone.layer.cornerRadius = btnDone.frame.size.height/2
        btnDone.clipsToBounds = true
    }
   

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet var DriverLicenceView: UIView!    
    @IBOutlet var AccreditationView: UIView!
    @IBOutlet var carRegisView: UIView!
    @IBOutlet var VehicleInsuView: UIView!
    // ------------------------------------------------------------
    
    @IBOutlet weak var imgDriverLicence: UIImageView!
    @IBOutlet weak var imgAccreditationCertifi: UIImageView!
    @IBOutlet weak var imgCarRegistration: UIImageView!
    @IBOutlet weak var imgVehicleInsurience: UIImageView!
    // ------------------------------------------------------------
    
    @IBOutlet weak var lblDriverLicence: UILabel!
    @IBOutlet weak var lblAccreditation: UILabel!
    @IBOutlet weak var lblCarRegistraion: UILabel!
    @IBOutlet weak var lblVehicleInsurance: UILabel!
    
    
    // ------------------------------------------------------------
    @IBOutlet var btnDriverLicence: UIButton!
    @IBOutlet var btnAccreditationCerti: UIButton!
    @IBOutlet var btnCarRegis: UIButton!
    @IBOutlet var btnVehicleInsu: UIButton!
    // ------------------------------------------------------------
    
    
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
//    cellDetails.classView.layer.borderWidth = 1
//    cellDetails.classView.layer.masksToBounds = true
//    cellDetails.classView.layer.borderColor = UIColor.gray.cgColor
    
    
    
    @IBAction func btnDriverLicenceView(_ sender: UIButton) {
        
//        self.PickingImageFromGallery()
//        self.selectDate()
        
        let alert = UIAlertController(title: "Choose Options", message: nil, preferredStyle: .alert)
        
        let Gallery = UIAlertAction(title: "Gallery", style: .default, handler: { ACTION in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            
            self.imagePicked = sender.tag
            self.present(self.imagePicker, animated: true)
    
        })
        let Camera  = UIAlertAction(title: "Camera", style: .default, handler: { ACTION in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.imagePicker.cameraCaptureMode = .photo
 
            self.imagePicked = sender.tag
            self.present(self.imagePicker, animated: true)
                
           
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(Gallery)
        alert.addAction(Camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
   
   
    }
    
    @IBAction func btnAccreditationCertiView(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Options", message: nil, preferredStyle: .alert)
        
        let Gallery = UIAlertAction(title: "Gallery", style: .default, handler: { ACTION in
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.imagePicked = sender.tag
                self.present(self.imagePicker, animated: true)
                
//            }
        })
        let Camera  = UIAlertAction(title: "Camera", style: .default, handler: { ACTION in
   
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.imagePicker.cameraCaptureMode = .photo
         
            
            self.imagePicked = sender.tag
            self.present(self.imagePicker, animated: true)
                
            
        })
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(Gallery)
        alert.addAction(Camera)
        alert.addAction(Cancel)
        self.present(alert, animated: true, completion: nil)
        
        
        
        
//        alert()
    }
    
    @IBAction func btnCarRegisView(_ sender: UIButton) {
//        alert()
        
        let alert = UIAlertController(title: "Choose Options", message: nil, preferredStyle: .alert)
        
        let Gallery = UIAlertAction(title: "Gallery", style: .default, handler: { ACTION in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            
                self.imagePicked = sender.tag
                self.present(self.imagePicker, animated: true)
                
           
        })
        let Camera  = UIAlertAction(title: "Camera", style: .default, handler: { ACTION in
           
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.imagePicker.cameraCaptureMode = .photo
     
            self.imagePicked = sender.tag
            self.present(self.imagePicker, animated: true)
                
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(Gallery)
        alert.addAction(Camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnVehicleInsuView(_ sender: UIButton) {
//        alert()
        
        let alert = UIAlertController(title: "Choose Options", message: nil, preferredStyle: .alert)
        
        let Gallery = UIAlertAction(title: "Gallery", style: .default, handler: { ACTION in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            
            self.imagePicked = sender.tag
            self.present(self.imagePicker, animated: true)
                
          
        })
        let Camera  = UIAlertAction(title: "Camera", style: .default, handler: { ACTION in
            
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.imagePicker.cameraCaptureMode = .photo
            
            self.imagePicked = sender.tag
            self.present(self.imagePicker, animated: true)
                
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(Gallery)
        alert.addAction(Camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alert()
    {
        let alert = UIAlertController(title: nil, message: "This feature will comming soon.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

    
    // ------------------------------------------------------------
    
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
        
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if imagePicked == 1 {
            imgDriverLicence.image = pickedImage

        } else if imagePicked == 2 {
            imgAccreditationCertifi.image = pickedImage
        } else if imagePicked == 3 {
            imgCarRegistration.image = pickedImage
        } else if imagePicked == 4 {
            imgVehicleInsurience.image = pickedImage
        }
        dismiss(animated: true)
       
//        UIView.animate(withDuration: 5.0, delay: 10.0, options: .transitionCurlUp, animations: {
//
//            self.Calendar()
//        }, completion: {_ in
//
//        })
        
        let selector = WWCalendarTimeSelector.instantiate()
        
        
        // 2. You can then set delegate, and any customization options
        //        selector.delegate = self
        selector.optionTopPanelTitle = "Please choose date"
        
        // 3. Then you simply present it from your view controller when necessary!
        self.present(selector, animated: true, completion: nil)
        selector.delegate = self
 
        
//        Calendar()
        
        
        
        
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imgDriverLicence.contentMode = .scaleToFill
//            imgDriverLicence.image = pickedImage
//
//        }
//        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        lblDriverLicence.text = selectedDate
        
        datePicker.removeFromSuperview()
        print("Selected value \(selectedDate)")
    }
    
    
   
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------

    func giveShadow()
    {
        DriverLicenceView.layer.borderWidth = 1
        DriverLicenceView.layer.masksToBounds = true
        DriverLicenceView.layer.borderColor = UIColor.gray.cgColor
        
        AccreditationView.layer.borderWidth = 1
        AccreditationView.layer.masksToBounds = true
        AccreditationView.layer.borderColor = UIColor.gray.cgColor
        
        carRegisView.layer.borderWidth = 1
        carRegisView.layer.masksToBounds = true
        carRegisView.layer.borderColor = UIColor.gray.cgColor
        
        VehicleInsuView.layer.borderWidth = 1
        VehicleInsuView.layer.masksToBounds = true
        VehicleInsuView.layer.borderColor = UIColor.gray.cgColor
        
        
//        DriverLicenceView.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 1, scale: true)
 //       AccreditationView.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 1, scale: true)
//        carRegisView.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 1, scale: true)
//        VehicleInsuView.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 1, scale: true)

    }
    
    func giveBorder(borderView: UIView) -> UIView
    {
        return borderView
    }
    
    @IBAction func btnNext(_ sender: Any) {
        
        getAllRegistrationData()
        
        if imgDriverLicence.image == UIImage(named: "iconCamera-1") {
            
            UtilityClass.showAlert(appName.kAPPName, message: "Upload Driver Licence", vc: self)
            
        }
        else if imgCarRegistration.image == UIImage(named: "iconCamera-1") {
            
             UtilityClass.showAlert(appName.kAPPName, message: "Upload Car Registration", vc: self)
            
        }
        else if imgVehicleInsurience.image == UIImage(named: "iconCamera-1") {
            
            UtilityClass.showAlert(appName.kAPPName, message: "Upload Vehicle Insurance", vc: self)

        }
        else if imgAccreditationCertifi.image == UIImage(named: "iconCamera-1") {
            
            UtilityClass.showAlert(appName.kAPPName, message: "Upload Accreditation Certificate", vc: self)
            
        }
        else {
            self.webserviceForRegistration()
        }
        
    }
    
   
    let myDatePicker: UIDatePicker = UIDatePicker()
    func Calendar()
    {
        // make DatePicker
        
        
        // setting properties of the datePicker
        myDatePicker.frame = CGRect(x:0, y: 50,width: self.view.frame.width, height: 200)
        myDatePicker.timeZone = NSTimeZone.local
        myDatePicker.backgroundColor = UIColor.white
        myDatePicker.layer.cornerRadius = 5.0
        myDatePicker.layer.shadowOpacity = 0.5
        
        // add an event called when value is changed.
        myDatePicker.addTarget(self, action: #selector(self.onDidChangeDate(sender:)), for: .valueChanged)
        
        // add DataPicker to the view
        self.view.addSubview(myDatePicker)
    }
    
    // called when the date picker called.
    internal func onDidChangeDate(sender: UIDatePicker){
        
        // date format
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy/MM/dd"
        
        // get the date string applied date format
        let mySelectedDate: NSString = myDateFormatter.string(from: sender.date) as NSString
        
        
        if imagePicked == 1 {
            lblDriverLicence.text = mySelectedDate as String
            
        } else if imagePicked == 2 {
            lblAccreditation.text = mySelectedDate as String
            
        } else if imagePicked == 3 {
            lblCarRegistraion.text = mySelectedDate as String
            
        } else if imagePicked == 4 {
            lblVehicleInsurance.text = mySelectedDate as String
        }
        self.myDatePicker.removeFromSuperview()
    }
    
    // ------------------------------------------------------------
    
    var certiFicateDate = String()
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date)
    {
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy/MM/dd"
        
        let finalDate = myDateFormatter.string(from: date)

        // get the date string applied date format
        let mySelectedDate = String(describing: finalDate)
        certiFicateDate = mySelectedDate
        
        if imagePicked == 1 {
            lblDriverLicence.text = mySelectedDate as String
            
        } else if imagePicked == 2 {
            lblAccreditation.text = mySelectedDate as String
            
        } else if imagePicked == 3 {
            lblCarRegistraion.text = mySelectedDate as String
            
        } else if imagePicked == 4 {
            lblVehicleInsurance.text = mySelectedDate as String
        }
        
        
        
    }
   
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var dictData = [String:AnyObject]()
    
    func webserviceForRegistration()
    {
   
        webserviceForRegistrationForDriver(dictData as AnyObject, image1: imgDriverLicence.image!, image2: imgAccreditationCertifi.image!, image3: imgCarRegistration.image!, image4: imgVehicleInsurience.image!, image5: imgDriver, image6: imgVehicle) { (result, status) in
            
            
            // ------------------------------------------------------------
            
            if (status)
            {
                print(result)
                
                if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
                {
                    Singletons.sharedInstance.dictDriverProfile = NSMutableDictionary(dictionary: (result as! NSDictionary))
                    Singletons.sharedInstance.isDriverLoggedIN = true
                    
                    UserDefaults.standard.set(Singletons.sharedInstance.dictDriverProfile, forKey: driverProfileKeys.kKeyDriverProfile)
                    UserDefaults.standard.set(true, forKey: driverProfileKeys.kKeyIsDriverLoggedIN)
                    
                    let profileData = Singletons.sharedInstance.dictDriverProfile
                    
                    Singletons.sharedInstance.strDriverID = (profileData?.object(forKey: "profile") as! NSDictionary).object(forKey: "Id") as! String
                    
//                    let next = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! CustomSideMenuViewController
//                    self.navigationController?.pushViewController(next, animated: true)
                    
                    self.navigationController?.isNavigationBarHidden = true
                    self.performSegue(withIdentifier: "afterCompleteRegistration", sender: nil)
                    
                }
            }
            else
            {
              
                if let res = result as? String
                {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary
                {
                    UtilityClass.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
            
        }
    }
    
    
    
    func getAllRegistrationData()
    {
        if let email: String = userDefault.object(forKey: RegistrationFinalKeys.kEmail) as? String {
            dictData[RegistrationFinalKeys.kEmail] = email as AnyObject
        }
        let fullName: String = (userDefault.object(forKey: RegistrationFinalKeys.kFullname) as? String)!
            dictData[RegistrationFinalKeys.kFullname] = fullName as AnyObject
       
        let gender: String = (userDefault.object(forKey: RegistrationFinalKeys.kGender) as? String)!
            dictData[RegistrationFinalKeys.kGender] = gender as AnyObject
       
        let mobileNo: String = (userDefault.object(forKey: RegistrationFinalKeys.kMobileNo) as? String)!
            dictData[RegistrationFinalKeys.kMobileNo] = mobileNo as AnyObject
      
        let password: String = (userDefault.object(forKey: RegistrationFinalKeys.kPassword) as? String)!
            dictData[RegistrationFinalKeys.kPassword] = password as AnyObject
      
        let address: String = (userDefault.object(forKey: RegistrationFinalKeys.kAddress) as? String)!
            dictData[RegistrationFinalKeys.kAddress] = address as AnyObject
       
//        let suburd: String = (userDefault.object(forKey: RegistrationFinalKeys.kSuburb) as? String)!
//            dictData[RegistrationFinalKeys.kSuburb] = suburd as AnyObject
        
         let postcode: String = userDefault.object(forKey: RegistrationFinalKeys.kZipcode) as! String
            dictData[RegistrationFinalKeys.kZipcode] = postcode as AnyObject
      
//         let city: String = userDefault.object(forKey: RegistrationFinalKeys.kCity) as! String
//            dictData[RegistrationFinalKeys.kCity] = city as AnyObject
//
//         let state: String = userDefault.object(forKey: RegistrationFinalKeys.kState) as! String
//            dictData[RegistrationFinalKeys.kState] = state as AnyObject
//
//         let Country: String = userDefault.object(forKey: RegistrationFinalKeys.kCountry) as! String
//            dictData[RegistrationFinalKeys.kCountry] = Country as AnyObject
      
        
        
         let DOB: String = userDefault.object(forKey: RegistrationFinalKeys.kKeyDOB) as! String
            dictData[RegistrationFinalKeys.kKeyDOB] = DOB as AnyObject
//
//         let ABN: String = userDefault.object(forKey: RegistrationFinalKeys.kABN) as! String
//            dictData[RegistrationFinalKeys.kABN] = ABN as AnyObject
//
//        let ServiceDescription = userDefault.object(forKey: RegistrationFinalKeys.kServiceDescription) as! String
//            dictData[RegistrationFinalKeys.kServiceDescription] = ServiceDescription as AnyObject
        
         let BSB: String = userDefault.object(forKey: RegistrationFinalKeys.kBSB) as! String
            dictData[RegistrationFinalKeys.kBSB] = BSB as AnyObject
//
         let BankName: String = userDefault.object(forKey: RegistrationFinalKeys.kBankName) as! String
            dictData[RegistrationFinalKeys.kBankName] = BankName as AnyObject
     
         let BankAccountNo: String = userDefault.object(forKey: RegistrationFinalKeys.kBankAccountNo) as! String
        dictData[RegistrationFinalKeys.kBankAccountNo] = BankAccountNo as AnyObject
        
    
        
        
         let referralCode: String = userDefault.object(forKey: RegistrationFinalKeys.kReferralCode) as! String
        dictData[RegistrationFinalKeys.kReferralCode] = referralCode as AnyObject
        
//        if let lat: String = userDefault.object(forKey: RegistrationFinalKeys.kLat) as? String {
//             dictData[RegistrationFinalKeys.kLat] = lat as AnyObject
//        } else {
        
//        }
       
//        if let lng: String = userDefault.object(forKey: RegistrationFinalKeys.kLng) as? String {
//            dictData[RegistrationFinalKeys.kLng] = lng as AnyObject
//        } else {
        
//        }
        
        dictData[RegistrationFinalKeys.kLat] = "22.0236514" as AnyObject
        dictData[RegistrationFinalKeys.kLat] = "72.0236514" as AnyObject
       
//         let carModel: String = userDefault.object(forKey: profileKeys.kCarModel) as! String
//            dictData[profileKeys.kCarModel] = carModel as AnyObject
       
        
        let vehicleRegistrationNumber: String = userDefault.object(forKey: RegistrationFinalKeys.kVehicleRegistrationNo) as! String
        dictData[RegistrationFinalKeys.kVehicleRegistrationNo] = vehicleRegistrationNumber as AnyObject
        
        let vehicleColor: String = userDefault.object(forKey: RegistrationFinalKeys.kCarThreeTypeName) as! String
        dictData[RegistrationFinalKeys.kCarThreeTypeName] = vehicleColor as AnyObject
        
        
        let vehicleClass: String = userDefault.object(forKey: RegistrationFinalKeys.kVehicleClass) as! String
        dictData[RegistrationFinalKeys.kVehicleClass] = vehicleClass as AnyObject
        
        
        let vehicleCompanyModel: String = userDefault.object(forKey: RegistrationFinalKeys.kCompanyModel) as! String
        dictData[RegistrationFinalKeys.kCompanyModel] = vehicleCompanyModel as AnyObject
        
        let bankHolederName: String = userDefault.object(forKey: RegistrationFinalKeys.kbankHolderName) as! String
        dictData[RegistrationFinalKeys.kbankHolderName] = bankHolederName as AnyObject
        
        
        
        // --------------------
        
        if let driverDecodedImageData: NSData = NSKeyedUnarchiver.unarchiveObject(with: userDefault.object(forKey: RegistrationFinalKeys.kDriverImage) as! Data) as? NSData {
            let img: UIImage = UIImage(data: driverDecodedImageData as Data)!
            imgDriver = img
            
        }
        if let vehicleDecodedImageData: NSData = NSKeyedUnarchiver.unarchiveObject(with: userDefault.object(forKey: RegistrationFinalKeys.kVehicleImage) as! Data) as? NSData {
            let imgageVehicle: UIImage = UIImage(data: vehicleDecodedImageData as Data)!
            imgVehicle = imgageVehicle
        }
        
//        let placesArray = NSKeyedUnarchiver.unarchiveObject(with: userDefault.object(forKey: RegistrationFinalKeys.kDriverImage) as! Data) as! NSData
//        let image = UIImage(data: placesArray as Data)
       
        
        SetVehicleExpiryDates()
        
        
        dictData["DeviceType"] = "1" as AnyObject
        dictData["Token"] = Singletons.sharedInstance.deviceToken as AnyObject
    }
    
    func setPersonnelDetails()
    {
        
    }
    
    func SetVehicleExpiryDates()
    {
    
        let DriverLicenceExpiryDate = lblDriverLicence.text
        let CarRegistrationExpiryDate = lblCarRegistraion.text
        let AccreditationCertificateExpiryDate = lblAccreditation.text
        let VehicleInsuranceCertificateExpiryDate = lblVehicleInsurance.text
        
        
        dictData[RegistrationFinalKeys.kDriverLicenceExpiryDate] = DriverLicenceExpiryDate as AnyObject
        dictData[RegistrationFinalKeys.kCarRegistrationExpiryDate] = CarRegistrationExpiryDate as AnyObject
        dictData[RegistrationFinalKeys.kAccreditationCertificateExpiryDate] = AccreditationCertificateExpiryDate as AnyObject
        dictData[RegistrationFinalKeys.kVehicleInsuranceCertificateExpiryDate] = VehicleInsuranceCertificateExpiryDate as AnyObject
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.destination is CustomSideMenuViewController {
            
        }
       
    }
  
    // ------------------------------------------------------------
}
