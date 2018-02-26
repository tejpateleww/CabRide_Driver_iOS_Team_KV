//
//  Utilities.swift
//  SwiftFirstDemoLoginSignUp
//
//  Created by Elite on 23/06/17.
//  Copyright © 2017 Palak. All rights reserved.
//

import UIKit
//import BFKit
import QuartzCore

class Utilities: NSObject
{
   
    class func SetLeftSIDEImage(TextField: UITextField, ImageName: String)
    {
        
        let leftImageView = UIImageView()
        leftImageView.contentMode = .scaleAspectFit
        
        let leftView = UIView()
        
        leftView.frame = CGRect(x: 10, y: 0, width: 30, height: 20)
        leftImageView.frame = CGRect(x: 13, y: 3, width: 15, height: 20)
        TextField.leftViewMode = .always
        TextField.leftView = leftView
        leftView.backgroundColor = UIColor.gray
        let image = UIImage(named: ImageName)?.withRenderingMode(.alwaysTemplate)
        leftImageView.image = image
        leftImageView.tintColor = UIColor.white
        leftImageView.tintColorDidChange()
        
        leftView.addSubview(leftImageView)
    }


    class func setStatusBarColor(color: UIColor)
    {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = UIColor.clear
    }
  
    
    func isEmpty(str: String) -> Bool
    {
        var newString = String()
        newString = str
        
        if (newString as? NSNull) == NSNull()
        {
            return true
        }
        if (newString == "(null)")
        {
            return true
        }
        if newString == ""
        {
            return true
        }
        else if (newString.count ) == 0 {
            return true
        }
        else
        {
            newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
            if (str.count ) == 0 {
                return true
                
            }
        }
        if (str == "<null>")
        {
            return true
        }
        return false
    }
    func hexStringToUIColor (hex:String) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func isEmail(testStr:String) -> Bool
    {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func setLeftPaddingInTextfield(textfield:UITextField , padding:(CGFloat))
    {
        let view:UIView = UIView (frame: CGRect (x: 0, y: 0, width: padding, height: textfield.frame.size.height) )
        textfield.leftView = view
        textfield.leftViewMode = UITextFieldViewMode.always
    }
    
    func setRightPaddingInTextfield(textfield:UITextField, padding:(CGFloat))
    {
        
        let view:UIView = UIView (frame: CGRect (x: 0, y: 0, width: padding, height: textfield.frame.size.height) )
        textfield.rightView = view
        textfield.rightViewMode = UITextFieldViewMode.always
    }
    
    func showToastMSG(MSG: String)
    {
//        CSToastManager.setQueueEnabled(false)
//        Appdelegate.window?.makeToast(MSG)
    }
    
    func sizeForText(text : String , font : UIFont, width : CGFloat) -> CGSize
    {
        let constraint : CGSize = CGSize.init(width: width, height: 20000.0)
        var size  = CGSize()
        let boundingBox : CGSize = text.boundingRect(with: constraint,
                                                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                attributes: [NSFontAttributeName: font],
                                                context: nil).size
        size = CGSize.init(width: ceil(boundingBox.width), height: ceil(boundingBox.height))
        return size
        
    }
    func getAspectSizeOfImage(imageSize : CGSize , widthTofit: CGFloat) -> CGSize
    {
        var imageWidth : CGFloat = imageSize.width
        var imageHeight : CGFloat = imageSize.height
         var imgRatio : CGFloat = imageWidth/imageHeight
        
        
         let width_1 : CGFloat = widthTofit
         let height_1 : CGFloat = CGFloat(MAXFLOAT)
        let maxRatio
            : CGFloat = width_1/height_1;
        
        if(imgRatio != maxRatio)
        {
            if(imgRatio < maxRatio)
            {
                imgRatio = height_1 / imageHeight;
                imageWidth = imgRatio * imageWidth;
                imageHeight = height_1;
            }
            else
            {
                imgRatio = width_1 / imageWidth;
                imageHeight = imgRatio * imageHeight;
                imageWidth = width_1;
            }
        }
        return CGSize.init(width: imageWidth, height: imageHeight)
    }
    func formatStringForDBUse(strValue : String) -> String
    {
        let strFinalString : String = strValue .replacingOccurrences(of: "'", with: "''")
        
        return strFinalString;
    }
    
    func imageWithImage(image : UIImage  ,newSize :CGSize  ) -> UIImage
    {
        UIGraphicsBeginImageContext( newSize );
        image .draw(in: CGRect (x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return newImage;
    }
    
    func setFraction(StrAmount : String) -> String
    {
        let inputNumber : NSNumber = NSNumber.init(value: Double(StrAmount)!)
        let formatterInput : NumberFormatter = NumberFormatter.init()
        formatterInput.numberStyle = NumberFormatter.Style.decimal
        formatterInput.maximumFractionDigits = 2
        var formattedInputString : String = formatterInput .string(from: inputNumber)!
        formattedInputString = formattedInputString .replacingOccurrences(of: ",", with: "")
        
        if formattedInputString == "0"
        {
            formattedInputString = "0.0"
        }
        else
        {
            formattedInputString = formattedInputString .appending(".0")
        }
        return formattedInputString
    }

//     func showActivitiyIndicator()
//    {
//        SVProgressHUD .show()
//    }
//    func hideActivitiyIndicator()
//    {
//        SVProgressHUD.dismiss()
//    }
    
    
    func setNavigationBar(strTitle: String, imgNavigation: UIImage, navigationController: UINavigationController, isTranslucent: Bool)
    {
        navigationController.isNavigationBarHidden = false
        navigationController.navigationBar.isOpaque = isTranslucent
        navigationController.navigationBar.isTranslucent = isTranslucent
        
        
        if strTitle.isEmpty
        {
            
            navigationController.navigationItem.titleView = nil
            let img = imgNavigation
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            imgView.image = img.withRenderingMode(.alwaysTemplate)
            imgView.tintColor = ThemePinkColor
            imgView.contentMode = .scaleAspectFit
            navigationController.navigationItem.titleView = imgView
        }
        else
        {
            navigationController.navigationItem.titleView = nil
            let lblTitle = UILabel.init(frame: CGRect (x: 0, y: 0, width: 100, height: 30))
            lblTitle.text = strTitle
            lblTitle.textColor = ThemePinkColor
            lblTitle.textAlignment = .center
            lblTitle.font = UIFont.init(name: CustomeFontProximaNovaBold, size: 11)
            navigationController.navigationItem.titleView = lblTitle
        }
        
        navigationController.navigationBar.barTintColor = UIColor.white
        navigationController.navigationBar.tintColor = ThemePinkColor
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : ThemePinkColor]
        navigationController.navigationBar.setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
        navigationController.navigationBar.shadowImage = UIImage.init()
        navigationController.view.backgroundColor = UIColor.clear
        
        
    }
  
}
