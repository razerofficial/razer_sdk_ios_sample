//
//  NativeAppViewController.swift
//  ThirdPartySDKSampleApp
//
//  Created by Umang Davessar on 2/2/18.
//  Copyright © 2018 Umang Davessar. All rights reserved.
//

import Foundation
import UIKit

class NativeAppViewController: UIViewController
{
     @IBOutlet var btnAuthorize : UIButton?
     @IBOutlet var btnDeny : UIButton?
    var refreshtoken : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAuthorize?.layer.borderColor = UIColor.white.cgColor
        btnAuthorize?.layer.cornerRadius = 3.0
        btnAuthorize?.layer.borderWidth = 1.0
        
        btnDeny?.layer.borderColor = UIColor.white.cgColor
        btnDeny?.layer.cornerRadius = 3.0
        btnDeny?.layer.borderWidth = 1.0
    }
    
    
    @IBAction func btnAutorizeAction()
    {
        let alertController = UIAlertController(title: "Refresh Token is :", message:
            self.refreshtoken, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnDenyAction()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}
