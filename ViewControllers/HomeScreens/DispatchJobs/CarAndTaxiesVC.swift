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
    var aryChooseCareModel = [String]()
     var aryChooseCarName = [String]()
    var aryData = NSArray()
//    var selectedCells = NSMutableArray()
    
    var selectedCells:[Int] = []
    
    weak var delegate: getVehicleIdAndNameDelegate!

    var delegateForEstimate: getEstimateFareForDispatchJobs!
    var delegateForEstimateNow: getEstimateFareForDispatchJobsNow!

    var strId = String()
    var strType = String()
    
    var indexPathSample = NSIndexPath()
  
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewMain.layer.cornerRadius = 8
        viewMain.layer.masksToBounds = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        tableView.allowsMultipleSelection = false
        indexPathSample = NSIndexPath(row: 23, section: 0)
        
        
        print(aryData.count)
        
        if Singletons.sharedInstance.isFromRegistration == false
        {
            for (i,_) in self.aryData.enumerated()
            {
                let dictData = aryData.object(at: i) as! NSDictionary
                
                if self.selectedCells.count == 3
                {
                    if self.selectedCells.contains(i)
                    {
                        self.aryChooseCareModel.remove(at: self.selectedCells.index(of: i)!)
                        self.aryChooseCarName.remove(at: self.selectedCells.index(of: i)!)
                        self.selectedCells.remove(at: self.selectedCells.index(of: i)!)
                    }
                    else
                    {
//                        let sb = Snackbar()
//                        sb.createWithAction(text: "You can select only three types.", actionTitle: "DISMISS", action: { print("Button is push") })
//                        sb.show()
                    }
                    
                }
                else
                {
                    if self.selectedCells.contains(i)
                    {
                        self.aryChooseCareModel.remove(at: self.selectedCells.index(of: i)!)
                        self.aryChooseCarName.remove(at: self.selectedCells.index(of: i)!)
                        self.selectedCells.remove(at: self.selectedCells.index(of: i)!)
                    }
                    else
                    {
                        self.selectedCells.append(i)
                        self.aryChooseCareModel.append(dictData["Id"] as! String)
                        self.aryChooseCarName.append(dictData["Name"] as! String)
                    }
                }
            }
           
        }
        

    }

    override func didReceiveMemoryWarning()
    {
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
        cell.lblCarModelDescription.text = ""//dictData.object(forKey: "Description") as? String

        cell.btnTickMark.setImage(UIImage.init(named: "iconCheckMarkUnSelected"), for: .normal)

        if selectedCells.count != 0
        {
            print(selectedCells)
            print(indexPath.row)
            
            if self.selectedCells.contains(indexPath.row)
            {
                cell.btnTickMark.setImage(UIImage.init(named: "iconCheckMarkSelected"), for: .normal)
            }
            else
            {
                cell.btnTickMark.setImage(UIImage.init(named: "iconCheckMarkUnSelected"), for: .normal)
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        let dictData = aryData.object(at: indexPath.row) as! NSDictionary
        
        if self.selectedCells.count == 3
        {
            if self.selectedCells.contains(indexPath.row) {
                self.aryChooseCareModel.remove(at: self.selectedCells.index(of: indexPath.row)!)
                self.aryChooseCarName.remove(at: self.selectedCells.index(of: indexPath.row)!)
                self.selectedCells.remove(at: self.selectedCells.index(of: indexPath.row)!)
            }
            else
            {
                let sb = Snackbar()
                sb.createWithAction(text: "You can select only three types.", actionTitle: "DISMISS", action: { print("Button is push") })
                sb.show()
            }
            
        }
        else
        {
            if self.selectedCells.contains(indexPath.row)
            {
                self.aryChooseCareModel.remove(at: self.selectedCells.index(of: indexPath.row)!)
                self.aryChooseCarName.remove(at: self.selectedCells.index(of: indexPath.row)!)
                self.selectedCells.remove(at: self.selectedCells.index(of: indexPath.row)!)
            }
            else {
                self.selectedCells.append(indexPath.row)
                self.aryChooseCareModel.append(dictData["Id"] as! String)
                self.aryChooseCarName.append(dictData["Name"] as! String)
            }
        }
        
        tableView.reloadData()
       
    }

    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------

    @IBOutlet weak var btnOK: UIButton!
    @IBAction func btnOK(_ sender: UIButton)
    {
 
        let joined = aryChooseCareModel.joined(separator: ",")
        UserDefaults.standard.set(joined, forKey: RegistrationFinalKeys.kVehicleClass)
        
        let joinedName = aryChooseCarName.joined(separator: ",")
        UserDefaults.standard.set(joinedName, forKey: RegistrationFinalKeys.kCarThreeTypeName)
        
        if strId != nil
        {
            delegate?.didgetIdAndName(id: strId, Name: strType)
        }
        if Singletons.sharedInstance.isFromRegistration == true
        {
            NotificationCenter.default.post(name: Notification.Name("setCarType"), object: nil)
        }
        else
        {
            NotificationCenter.default.post(name: Notification.Name("setCarTypeUpdate"), object: nil)
        }
        
//            delegateForBookLater.didgetIdAndName(id: strId, Name: strType)
//            delegateForEstimateNow?.didSelectVehicleModelNow()
            delegateForEstimate?.didSelectVehicleModel()
            self.dismiss(animated: true, completion: nil)
  
    }
    
}
