//
//  RatingViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 22/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import FloatRatingView
class RatingViewController: UIViewController,FloatRatingViewDelegate {

    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var txtFeedback: UITextField!
    @IBOutlet var viewRating: UIView!
    @IBOutlet var lblDetail: UILabel!


    @IBOutlet var viewStarsRating: FloatRatingView!
    var ratingToDriver = Float()
    var commentToDriver = String()
    var strBookingType = String()
    var strBookingID = String()
    var dictData : NSDictionary!
    var dictPassengerInfo : NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewStarsRating.rating = 0.0
        viewStarsRating.delegate = self
        strBookingID = (dictData["details"]! as! [String : AnyObject])["Id"] as! String
        lblDetail.text = "How was your experience with \((dictPassengerInfo!.object(forKey: "Fullname") as! String))?"// (dictPassengerInfo!.object(forKey: "Fullname") as! String)
        // Do any additional setup after loading the view.
        
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.layer.masksToBounds = true
    }
    @IBAction func btnGiveRating(_ sender: Any) {
        
        
        webserviceCallToGiveRating()

        
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double){
        
        viewStarsRating.rating = Double(rating)
        ratingToDriver = Float(viewStarsRating.rating)
        
    }
    
    
    func webserviceCallToGiveRating() {
        
        var param = [String:AnyObject]()
        param["BookingId"] = strBookingID as AnyObject
        param["Rating"] = ratingToDriver as AnyObject
        param["Comment"] = txtFeedback.text as AnyObject
        param["BookingType"] = strBookingType as AnyObject
        
        
        webserviceForGiveRating(param as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                self.ratingToDriver = 0
                                
                UtilityClass.showAlertWithCompletion(appName.kAPPName, message: "Rating successfull", vc: self) { (status) in
 }
                
                self.dismiss(animated: true, completion: nil)
                
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
