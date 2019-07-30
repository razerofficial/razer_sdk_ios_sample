//
//  ViewController.swift
//  ThirdPartySDKSampleApp
//
//  Created by Umang Davessar on 23/1/18.
//  Copyright © 2018 Umang Davessar. All rights reserved.
//

import UIKit
import Security
import NVActivityIndicatorView
import Foundation
import Alamofire
import RazerAUTHSDK


/**
This class is designed and implemented to Login with Third Party SDK.
 */

class ViewController: UIViewController,NVActivityIndicatorViewable {
    /**
       Access Token receives from Demo App
     */
    var accessToken : String?
    /**
     Message String if user denies the authorization request from Demo App
     */
    var messageAppDeny : String?
    
    /**
     Label to show message if user denies the authorization request from Demo App
     */
    @IBOutlet var lblMessage : UILabel?
    
    /**
      Login button designed to logion with Razer ID
     */
    @IBOutlet var btnLogin : UIButton?
    
    let rzAuthSDK = RzLoginView()
    /**
    Set Up Navigation Bar for the View Controller
     */
    
    private func setupNavigationBar(){
        
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.isHidden = true
    }
    
   /**
    Notifies the view controller that its view is about to be added to a view hierarchy.
    This method is called before the view controller's view is about to be added to a view hierarchy and before any animations are configured for showing the view. You can override this method to perform custom tasks associated with displaying the view. For example, you might use this method to change the orientation or style of the status bar to coordinate with the orientation or style of the view being presented. If you override this method, you must call super at some point in your implementation.
 
   */
    
    override func viewWillAppear(_ animated: Bool) {
         setupNavigationBar()
    }
    
    /**
     Called after the controller's view is loaded into memory.
     This method is called after the view controller has loaded its view hierarchy into memory. This method is called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the loadView() method. You usually override this method to perform additional initialization on views that were loaded from nib files.
     
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(messageAppDeny != nil)
        {
            lblMessage?.text = messageAppDeny
        }
        else
        {
            lblMessage?.text = ""
        }
        btnLogin?.layer.cornerRadius = 3.0
        
        // Do any additional setup after loading the view, typically from a nib.
    }


    /**
     
      This button Action will check if there is app installed with provided Urlscheme . If it exits, then it will open the app else it open Razer ID Account in Browser .
      Below parameters will send with Query Scheme to show on Authorize Screen in other App.
     - App Logo
     - App name
     - Client ID
     */

    @IBAction func btnLoginClick(_sender: UIButton)
    {
        messageAppDeny = ""
        let appURLScheme = "rzmobilekitdemo://?ThirdPartySDK"
        
        
       // https://oauth2.razer.com/clientinfo?client_id=5fd0106be31fd6bf41b991c9cf6b1f8936e0b6cb&client_secret=f53a4b41cf0bb68672e986cab811e7110609ccba&scope=openid+profile&locale=en
        
        rzAuthSDK.loginRazerID(urlScheme: appURLScheme, clientID: "4393c97fdc97b8fcf30092df8eb5e3afd259b0fa", clientSecret: "5e4eca2809aef4647f87688d49a8e5f97e29c4c0", scope: "openid+profile", { (accessToken) in
            print("access::%@",accessToken)
            if (accessToken != nil)
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                vc.strAccessToken = accessToken
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
           
        }, {
            
        }) { (error) in
            print(error.debugDescription)
        }
        
        
    }
    
    /**
     
     Sent to the view controller when the app receives a memory warning.
     Your app never calls this method directly. Instead, this method is called when the system determines that the amount of available memory is low.
     You can override this method to release any additional memory used by your view controller. If you do, your implementation of this method must call the super implementation at some point.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


