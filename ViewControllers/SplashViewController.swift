//
//  SplashViewController.swift
//  PickNGo-Driver
//
//  Created by Excellent Webworld on 09/02/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    
    @IBOutlet var imgSplashLogo: UIImageView!
    
    @IBOutlet var viewSplash: UIView!
    @IBOutlet var lblPickNGo: UILabel!
    @IBOutlet var imgLogoWithoutText: UIImageView!
    
    @IBOutlet var constrainLabelYPosition: NSLayoutConstraint!
    @IBOutlet var ConstrainLabelPickNGoXPosition: NSLayoutConstraint!
    
    @IBOutlet var ConstrainImgLogoYPosistion: NSLayoutConstraint!
    
    
    
    //MARK: - View Cycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()

        imgSplashLogo.isHidden = true
        lblPickNGo.isHidden = true
     constrainLabelYPosition.constant = ((self.view.frame.size.height/2) + (imgLogoWithoutText.frame.size.height/2))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews()
    
    {
        super.viewDidLayoutSubviews()
        ConstrainImgLogoYPosistion.constant = ((-self.view.frame.size.height/2) - imgLogoWithoutText.frame.size.height)
        ConstrainLabelPickNGoXPosition.constant = -self.lblPickNGo.frame.size.width
        
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        let y_Posistion : CGFloat = 0
        ConstrainImgLogoYPosistion.constant = y_Posistion
        
        UIView.animate(withDuration: 2, delay: 0.0, options: .curveEaseOut, animations:
            {
                self.viewSplash.layoutIfNeeded()
        })
        { (done) in
            self.lblPickNGo.isHidden = false
            self.ConstrainLabelPickNGoXPosition.constant = 0
            UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations:
                {
                    self.viewSplash.layoutIfNeeded()
            })
            { (done) in
                
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(viewController, animated: true)

                
            }
        }
    }
    


}
