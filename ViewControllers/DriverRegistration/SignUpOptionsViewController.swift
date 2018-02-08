//
//  SignUpOptionsViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 12/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class SignUpOptionsViewController: ParentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnDriver(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "DriverRegistrationViewController") as! DriverRegistrationViewController
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    @IBAction func btnServiceProvider(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ServiceProviderViewController") as! ServiceProviderViewController
        self.navigationController?.pushViewController(next, animated: true)

    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is LoginViewController {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
//        navigationController?.popViewController(animated: true)
    }
    
}
