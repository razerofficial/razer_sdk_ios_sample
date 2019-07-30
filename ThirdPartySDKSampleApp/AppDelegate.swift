//
//  AppDelegate.swift
//  ThirdPartySDKSampleApp
//
//  Created by Umang Davessar on 23/1/18.
//  Copyright © 2018 Umang Davessar. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import RazerAUTHSDK


@UIApplicationMain

/**
 This class is designed and implemented to receive any callbacks from other App.
 */

class AppDelegate: UIResponder, UIApplicationDelegate {
     let callBackManager = RzLoginView()
    var window: UIWindow?

    /**
     Tells the delegate that the launch process is almost done and the app is almost ready to run.
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        callBackManager.setup(isDebug: true)
        callBackManager.YPrint(value: "Working fine…")
        return true
    }
    
    
    /**
     
     Asks the delegate to open a resource specified by a URL, and provides a dictionary of launch options.
     This method will receive callback from other App and send data to Detail view controller.
     
     - Parameters:
     
     - url.abosulteString : will give query scheme from other app
     - url.query : will return dictionary receive from other app (Refresh token)
     */
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        callBackManager.application(url: url, { (params) in
      
                let params = NSMutableDictionary()
                let kvPairs : [String] = (url.query?.components(separatedBy: "&"))!
                for param in  kvPairs{
                    let keyValuePair : Array = param.components(separatedBy: "=")
                    if keyValuePair.count == 2{
                        params.setObject(keyValuePair.last!, forKey: keyValuePair.first! as NSCopying)
                    }
                }
                
                /**
                 After Authorize and receive the data from other app, user will redirect to Detail View Screen.
                 */
                
            if (params["accesstoken"] != nil)
            {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                    vc.paramValue = params as! Dictionary<String, Any>
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
            }
                print(params)
            
            
        }) { (error) in
            
            /**
             After Deny authorization from other app, user will redirect to Main Login View.
             */
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.messageAppDeny = "Sorry ,Request Denied. Please sign in to login again. "
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
        return true
        
        
    }
    
    /**
     
      Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
     */
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    /**
     
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    */
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    /**
     
     Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
     */

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

