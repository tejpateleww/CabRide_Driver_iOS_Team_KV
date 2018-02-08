//
//  WalletAddCardsViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 28/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

import FormTextField

class WalletAddCardsViewController: ParentViewController, UIPickerViewDataSource, UIPickerViewDelegate, CardIOPaymentViewControllerDelegate {
    
    @IBOutlet var viewOfTextFields: [UIView]!
    
    @IBOutlet var viewScanCard: UIView!
    var aryMonth = [String]()
    var aryYear = [String]()
    
    var strSelectMonth = String()
    var strSelectYear = String()
    
    var pickerView = UIPickerView()
    
    weak var delegateAddCard: AddCadsDelegate!
    
    var creditCardValidator: CreditCardValidator!
    
    var isCreditCardValid = Bool()
    
    var cardTypeLabel = String()
    var aryData = [[String:AnyObject]]()
    
    var CardNumber = String()
    var strMonth = String()
    var strYear = String()
    var strCVV = String()
    
    var aryTempMonth = [String]()
    var aryTempYear = [String]()
    
    
    
    var crnRadios = CGFloat()
    var shadowOpacity = Float()
    var shadowRadius = CGFloat()
    var shadowOffsetWidth = Int()
    var shadowOffsetHeight = Int()

    
  
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crnRadios = 5
        shadowOpacity = 0.2
        shadowRadius = 1
        shadowOffsetWidth = 0
        
        btnAddPaymentMethods.layer.cornerRadius = 5
        btnAddPaymentMethods.layer.masksToBounds = true
        
        cardNum()
        // Initialise Credit Card Validator
        creditCardValidator = CreditCardValidator()
        
        pickerView.delegate = self
        
//        aryMonths = ["January","February","March","April","May","June","July","August","September","October","November","December"]
//        aryMonths = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        aryMonth = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        
        aryYear = ["2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030"]
        
        aryTempMonth = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        aryTempYear = ["2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030"]

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for viewTextFields in viewOfTextFields
        {
            viewTextFields.layer.cornerRadius = 5.0
            viewTextFields.layer.borderColor = UIColor.gray.cgColor
            viewTextFields.layer.borderWidth = 1.0
            viewTextFields.layer.masksToBounds = true
        }
        
        viewScanCard.layer.shadowOpacity = shadowOpacity
        viewScanCard.layer.shadowRadius = shadowRadius
        viewScanCard.layer.shadowColor = UIColor.black.cgColor
        viewScanCard.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var btnAddPaymentMethods: UIButton!
    @IBOutlet weak var txtCardNumber: FormTextField!
    @IBOutlet weak var txtValidThrough: FormTextField!
    @IBOutlet weak var txtCVVNumber: FormTextField!
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var txtAlies: UITextField!
    
    var validation = Validation()
    var inputValidator = InputValidator()
    
    //-------------------------------------------------------------
    // MARK: - PicketView Methods
    //-------------------------------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return aryMonth.count
        }
        else {
            return aryYear.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return aryMonth[row]
        }
        else {
            return aryYear[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 1 {
            if currentYear == aryYear[row] {
                
                aryYear.removeFirst(row)
                for i in 0..<aryMonth.count {
                    if currentMonth == aryMonth[i] {
                        aryMonth.removeFirst(i - 1)
                    }
                }
                pickerView.reloadComponent(0)
            }
            else {
                aryMonth = aryTempMonth
                aryYear = aryTempYear
                
                pickerView.reloadComponent(0)
            }
        }
        
        if component == 0 {
            strSelectMonth = aryMonth[row]
        }
        else {
            strSelectYear = aryYear[row]
            strSelectYear.removeFirst(2)
        }
        
        txtValidThrough.text = "\(strSelectMonth)/\(strSelectYear)"
    }
    
    var currentMonth = String()
    var currentYear = String()
    
    func findCurrentMonthAndYear() {
        
        let now = NSDate()
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let curMonth = monthFormatter.string(from: now as Date)
        print("currentMonth : \(curMonth)")
        currentMonth = curMonth
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let curYear = yearFormatter.string(from: now as Date)
        print("currentYear : \(curYear)")
        currentYear = curYear
        
    }
    
    
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnAddPaymentMethods(_ sender: UIButton) {
   
        if (ValidationForAddPaymentMethod()) {
            webserviceOfAddCard()
        }
        
    }
    
    @IBAction func txtValidThrough(_ sender: UITextField) {
        
        txtValidThrough.inputView = pickerView
        
    }
    @IBAction func txtCardNumber(_ sender: UITextField) {
        
        if let number = sender.text {
            if number.isEmpty {
                isCreditCardValid = false
                
                imgCard.image = UIImage(named: "iconDummyCard")
//                self.cardValidationLabel.text = "Enter card number"
//                self.cardValidationLabel.textColor = UIColor.black
//
//                self.cardTypeLabel.text = "Enter card number"
//                self.cardTypeLabel.textColor = UIColor.black
            } else {
                validateCardNumber(number: number)
                detectCardNumberType(number: number)
            }
        }
    }
    
    @IBAction func btnScanCard(_ sender: UIButton) {
        
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)

        
//        UtilityClass.showAlert(appName.kAPPName, message: "This Feature will be soon.", vc: self)
    }
    
    
    func validateCardNumber(number: String) {
        if creditCardValidator.validate(string: number) {
            
            isCreditCardValid = true
            
//            self.cardValidationLabel.text = "Card number is valid"
//            self.cardValidationLabel.textColor = UIColor.green
        } else {
            
            isCreditCardValid = false
            
            imgCard.image = UIImage(named: "iconDummyCard")
//            self.cardValidationLabel.text = "Card number is invalid"
//            self.cardValidationLabel.textColor = UIColor.red
        }
    }
    
    func detectCardNumberType(number: String) {
        if let type = creditCardValidator.type(from: number) {
            
            isCreditCardValid = true
            
            self.cardTypeLabel = type.name
            
            print(type.name)
            
            imgCard.image = UIImage(named: type.name)
            
//            self.cardTypeLabel.textColor = UIColor.green
        } else {
            
            imgCard.image = UIImage(named: "iconDummyCard")
            
            isCreditCardValid = false
            
            self.cardTypeLabel = "Undefined"
//            self.cardTypeLabel.textColor = UIColor.red
        }
    }
    
    func ValidationForAddPaymentMethod() -> Bool {
        
        if (txtCardNumber.text!.count == 0) {
            UtilityClass.showAlert(appName.kAPPName, message: "Enter Card Number", vc: self)
            return false
        }
        else if (txtValidThrough.text!.count == 0) {
            UtilityClass.showAlert(appName.kAPPName, message: "Enter Expiry Date", vc: self)
            return false
        }
        else if (txtCVVNumber.text!.count == 0) {
            UtilityClass.showAlert(appName.kAPPName, message: "Enter CVV Number", vc: self)
            return false
        }
        
        return true
    }
 
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    
    func webserviceOfAddCard() {
        // DriverId,CardNo,Cvv,Expiry (CarNo : 4444555511115555,Expiry:09/20)
        
        var dictData = [String:AnyObject]()
        
        dictData[profileKeys.kDriverId] = Singletons.sharedInstance.strDriverID as AnyObject
        dictData[walletAddCards.kCardNo] = txtCardNumber.text as AnyObject
        dictData[walletAddCards.kCVV] = txtCVVNumber.text as AnyObject
        dictData[walletAddCards.kExpiry] = txtValidThrough.text as AnyObject
        dictData[walletAddCards.kAlias] = txtAlies.text as AnyObject
        
        
        webserviceForAddNewCardInWallet(dictData as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
              if(self.delegateAddCard != nil)
              {
                    self.delegateAddCard.didAddCard(cards: (result as! NSDictionary).object(forKey: "cards") as! NSArray)
                }
                self.aryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                Singletons.sharedInstance.CardsVCHaveAryData = self.aryData
                
                
                let alert = UIAlertController(title: nil, message: (result as! NSDictionary).object(forKey: "message") as? String, preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                
                    self.navigationController?.popViewController(animated: true)
                })
            
                alert.addAction(OK)
                self.present(alert, animated: true, completion: nil)
                
                
            }
            else {
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
    
    //-------------------------------------------------------------
    // MARK: - Scan Card Methods
    //-------------------------------------------------------------
    
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        
        print("CardInfo : \(cardInfo)")
        
        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            //            resultLabel.text = str as String
            
            
            
            print("Card Number : \(info.cardNumber)")
            print("Redacted Card Number : \(customStringFormatting(of: info.redactedCardNumber))")
            print("Month : \(info.expiryMonth)")
            print("Year : \(info.expiryYear)")
            print("CVV : \(info.cvv)")
            
            var years = String(info.expiryYear)
            years.removeFirst(2)
            //            customStringFormatting(of: info.redactedCardNumber)
            
            print("Removed Year : \(years)")
            

//            txtCardNumber.text = customStringFormatting(of: info.redactedCardNumber)
            txtCardNumber.text = info.cardNumber
            txtValidThrough.text = "\(info.expiryMonth)/\(years)"
            txtCVVNumber.text = info.cvv
            
            
            CardNumber = String(info.cardNumber)
            strMonth = String(info.expiryMonth)
            strYear = String(years)
            strCVV = String(info.cvv)
          
        }
        paymentViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    func cardNum() {
        txtCardNumber.inputType = .integer
        txtCardNumber.formatter = CardNumberFormatter()
        txtCardNumber.placeholder = "Card Number"
        
        
        validation.maximumLength = 19
        validation.minimumLength = 14
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        inputValidator = InputValidator(validation: validation)
        
        txtCardNumber.inputValidator = inputValidator
        
        cardExpiry()
    }
    
    func cardExpiry() {
        txtValidThrough.inputType = .integer
        txtValidThrough.formatter = CardExpirationDateFormatter()
        txtValidThrough.placeholder = "Expiration Date (MM/YY)"
        
        //        var validation = Validation()
        validation.minimumLength = 1
        let inputValidator = CardExpirationDateInputValidator(validation: validation)
        txtValidThrough.inputValidator = inputValidator
        
        cardCVV()
        print("")
        
    }
    
    func cardCVV() {
        
        txtCVVNumber.inputType = .integer
        txtCVVNumber.placeholder = "CVC"
        
        //        var validation = Validation()
        validation.maximumLength = 3
        validation.minimumLength = 3
        validation.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validation)
        txtCVVNumber.inputValidator = inputValidator
        
        //        print("txtCVV.text : \(txtCVV.text)")
    }
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        //        resultLabel.text = "user canceled"
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            _ = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            //            resultLabel.text = str as String
//            txtCardNumber.text = info.redactedCardNumber
//            txtExpiryDate.text = "\(info.expiryMonth)/\(info.expiryYear)"
        }
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func customStringFormatting(of str: String) -> String {
        return str.chunk(n: 4)
            .map{ String($0) }.joined(separator: " ")
        
    }

}
/*

// SuccessFully

{
    cards =     (
        {
            Alias = Kotak;
            CardNum = 4242424242424242;
            CardNum2 = "xxxx xxxx xxxx 4242";
            Id = 3;
            Type = visa;
        }
    );
    message = "Card saved successfully";
    status = 1;
}
 
// Failed
 
{
    message = "Parameter missing";
    status = 0;
}
 
*/