	//
//  TabbarController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 13/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = UIColor.red
        tabBar.backgroundColor = UIColor.black
        
        // Do any additional setup after loading the view.
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
