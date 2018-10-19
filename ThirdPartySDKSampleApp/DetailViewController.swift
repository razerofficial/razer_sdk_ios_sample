//
//  DetailViewController.swift
//  ThirdPartySDKSampleApp
//
//  Created by Umang Davessar on 30/1/18.
//  Copyright © 2018 Umang Davessar. All rights reserved.
//


import Foundation
import UIKit
//import Alamofire
import NVActivityIndicatorView
//import SDWebImage


/**
 Extension of UIImage View.
 */

extension UIImageView{
    
    func setImageFromURl(stringImageUrl url: String){
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}

/**
 This class is designed and implemented to show the Active user's detail (Razer ID, Open ID, Avatar, Email, Acees token and Expiry).
 
 After Authorize from other app, user will come to this screen
 
 */

class DetailViewController: UIViewController,NVActivityIndicatorViewable {
    
    /**
     Access Token receives from Demo App
     */
    var strAccessToken : String?
    /**
     Params Dictionary receives from other app with required details
     */
    var paramValue : Dictionary<String, Any>?
    var webViewValue : Dictionary<String, Any>?
    /**
     Label to show Aceess Token Value
     */
    @IBOutlet var lblAceessToken : UILabel?
    /** SCOPE_PROFILE **/
    
    @IBOutlet var lblEmail : UILabel?
    @IBOutlet var lblExpiry : UILabel?
    @IBOutlet var lblRazerID : UILabel?
    /** SCOPE_OPENID **/
    @IBOutlet var lblOpenID : UILabel?
    @IBOutlet var lbluuid : UILabel?
    @IBOutlet var imgAvatar : UIImageView?
    @IBOutlet var vw1 : UIView?
    @IBOutlet var vw2 : UIView?
    @IBOutlet var btnLogout : UIButton?
    
    /**
     Called after the controller's view is loaded into memory.
     This method is called after the view controller has loaded its view hierarchy into memory. This method is called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the loadView() method. You usually override this method to perform additional initialization on views that were loaded from nib files.
     
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        imgAvatar?.layer.cornerRadius = 64;
        imgAvatar?.clipsToBounds = true
        
        vw1?.layer.borderColor = UIColor.white.cgColor
        vw1?.layer.cornerRadius = 3.0
        vw1?.layer.borderWidth = 1.0
        
        btnLogout?.layer.borderColor = UIColor.white.cgColor
        btnLogout?.layer.cornerRadius = 3.0
        btnLogout?.layer.borderWidth = 1.0
        
        vw2?.layer.borderColor = UIColor.white.cgColor
        vw2?.layer.cornerRadius = 3.0
        vw2?.layer.borderWidth = 1.0
        
        if (paramValue != nil) {
            
            lblAceessToken?.text = String(format:"Access Token : %@", paramValue!["accesstoken"] as! CVarArg)
            lblExpiry?.text = String(format:"Expiry : %@", paramValue!["expiry"] as! CVarArg)
            callWebserviceForJSON(accessToken: paramValue!["accesstoken"] as! String)
            
            
        }
            
        else if (webViewValue != nil)
        {
            lblAceessToken?.text = String(format:"Access Token : %@", webViewValue!["access_token"] as! CVarArg)
            lblExpiry?.text = String(format:"Expiry : %@", webViewValue!["expires_in"] as! CVarArg)
            callWebserviceForJSON(accessToken: webViewValue!["access_token"] as! String)
        }
        
        else if (strAccessToken != nil || strAccessToken != "")
        {
            lblAceessToken?.text = String(format:"Access Token : %@", strAccessToken!)
            lblExpiry?.text = String(format:"Expiry : %@", "3600")
            callWebserviceForJSON(accessToken: strAccessToken!)
        }
        
        else
        {
            
        }
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func callWebserviceForJSON(accessToken : String)
    {
        startAnimating(CGSize(width: 30, height: 30), message: "Fetching data...", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballClipRotate.rawValue))
        let urlString = "https://oauth2-staging.razerapi.com/userinfo"
        guard let requestUrl = URL(string:urlString) else { return }
        var request = URLRequest(url:requestUrl)
        let authorizationKey = "Bearer ".appending(accessToken)
        request.addValue(authorizationKey, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let data = data {
                
                let string = String(data: data, encoding: String.Encoding.utf8)
                let dict = self.convertToDictionary(text: string!)
                DispatchQueue.main.async {
                    // Update UI
                    //self.lblEmail?.text = String(format:"Nickname : %@", dict!["nickname"] as! CVarArg)
                    self.lblRazerID?.text = String(format:"Razer ID : %@", dict!["razer_id"] as! CVarArg)
                    self.lbluuid?.text = String(format:"Open ID : %@", dict!["open_id"] as! CVarArg)
                    let imgURL = dict!["avatar"]
                    if (dict!["avatar"] == nil || dict!["avatar"]! is NSNull){
                        
                    }
                    else
                    {
                        self.imgAvatar?.setImageFromURl(stringImageUrl: imgURL as! String)
                    }
                    self.stopAnimating()
                }
                // print(dict) //JSONSerialization
                
            }
                
            else
            {
                self.stopAnimating()
            }
            
            }.resume()
        
    }
    
    /**
     Set up of navigation bar
     
     */
    
    private func setupNavigationBar(){
        
        UIApplication.shared.statusBarStyle = .default
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    /**
     Logout will delete the webview cookies and redirect user to main screen
     
     */
    @IBAction func logout()
    {
        UserDefaults.standard.setValue(nil, forKey: "token")
        UserDefaults.standard.synchronize()
        let cookieJar = HTTPCookieStorage.shared
        
        for cookie in cookieJar.cookies! {
            // print(cookie.name+"="+cookie.value)
            cookieJar.deleteCookie(cookie)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(vc, animated: true) {
            
        }
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        // self.navigationController?.popToRootViewController(animated: false)
    }
    
    
}

