//
//  CarAndTaxiesVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 16/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

@objc protocol getVehicleIdAndNameDelegate {
    
    func didgetIdAndName(id: String, Name: String)
}

protocol getEstimateFareForDispatchJobsNow {
    
    func didSelectVehicleModelNow()
}

class CarAndTaxiesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    //-------------------------------------------------------------
    // MARK: - Global Declaration
    //-------------------------------------------------------------
    
    var aryData = NSArray()
    var selectedCells = NSMutableArray()
    
    weak var delegate: getVehicleIdAndNameDelegate!

    var delegateForEstimate: getEstimateFareForDispatchJobs!
    var delegateForEstimateNow: getEstimateFareForDispatchJobsNow!

    var strId = String()
    var strType = String()
    
    var indexPathSample = NSIndexPath()
  
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewMain.layer.cornerRadius = 3
        viewMain.layer.masksToBounds = true
        btnOK.layer.cornerRadius = 3
        btnOK.layer.masksToBounds = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        tableView.allowsMultipleSelection = false
        indexPathSample = NSIndexPath(row: 23, section: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewMain: UIView!
    
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarAndTaxiesTableViewCell") as! CarAndTaxiesTableViewCell
        cell.selectionStyle = .none
        
        let dictData = aryData.object(at: indexPath.row) as! NSDictionary
        
        cell.lblCarModelClass.text = dictData.object(forKey: "Name") as? String
        cell.lblCarModelDescription.text = dictData.object(forKey: "Description") as? String

        cell.btnTickMark.setImage(UIImage.init(named: "iconCheckMarkUnSelected"), for: .normal)

        if (indexPathSample as IndexPath == indexPath)
        {
      
            cell.btnTickMark.setImage(UIImage.init(named: "iconCheckMarkSelected"), for: .normal)
            
            strId = dictData.object(forKey: "Id") as! String
            strType = dictData.object(forKey: "Name") as! String
           
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         indexPathSample = indexPath as NSIndexPath
        
        tableView.reloadData()
        
    }

    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------

    @IBOutlet weak var btnOK: UIButton!
    @IBAction func btnOK(_ sender: UIButton) {
 
            delegate.didgetIdAndName(id: strId, Name: strType)
//            delegateForBookLater.didgetIdAndName(id: strId, Name: strType)
//            delegateForEstimateNow?.didSelectVehicleModelNow()
            delegateForEstimate?.didSelectVehicleModel()
            self.dismiss(animated: true, completion: nil)
  
    }
    
}
