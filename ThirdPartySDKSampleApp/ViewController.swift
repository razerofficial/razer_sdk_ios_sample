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

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
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
        getClientInfo()
        
    }
    
    
    
    func getClientInfo()
    {
        //     "https://oauth2-staging.razerapi.com/clientinfo?client_id=openidstaging&client_secret=openidpasswdstaging&scope=openid+profile&locale=en"
        //e8a995fd9a0c54e9003530379204f90e8bf6f7e6
        //bb403a03ecc3eb594fe619c6baaf7352bbb58ac4
        
        Alamofire.request("https://oauth2-staging.razersynapse.com/clientinfo?client_id=e8a995fd9a0c54e9003530379204f90e8bf6f7e6&client_secret=bb403a03ecc3eb594fe619c6baaf7352bbb58ac4&scope=openid+profile&locale=en", method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    
                    let dict = data as! NSDictionary
                    print(dict)
                    
                    let Urlstring = String(format:"rzmobilekitdemo://?clientid=%@&clientname=%@&clientlogo=%@&scope=%@",dict["client_id"]as! String,dict["client_name"]as! String,dict["client_logo"]as! String, "Profile")
                    
                    let appURLScheme = Urlstring .removingWhitespaces()

                    //dict["scope"]as! [String : AnyObject]
                    
                    
                    guard let appURL = URL(string: appURLScheme) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(appURL) {
                        
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(appURL)
                        }
                        else {
                            UIApplication.shared.openURL(appURL)
                        }
                    }
                    else {
                        // Here you can handle the case when your other application cannot be opened for any reason.
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                        //self.present(vc, animated: false, completion: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    
                }
                break
                
            case .failure(_):
                print(response.result.error)
                break
                
            }
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


