//
//  WebViewController.swift
//  ThirdPartySDKSampleApp
//
//  Created by Umang Davessar on 23/1/18.
//  Copyright © 2018 Umang Davessar. All rights reserved.


import Foundation
import WebKit
import UIKit


/**
 This class is designed and implemented to open Razer ID website in WebView.
 */
class WebViewController: UIViewController,WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler {
   
    //Authorization: Bearer c0ceafb997fb7d6185d30ea2320e724e91875ddd
    
    /**
     WebView to open razer ID Website
     
     */
    @IBOutlet var webViewSample : WKWebView?
    
    private func setupNavigationBar(){
        
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationItem.title = "Razer ID Login"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.green
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
        self.title = "Razer ID Login"
    }
    
    /**
     Called after the controller's view is loaded into memory.
     This method is called after the view controller has loaded its view hierarchy into memory. This method is called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the loadView() method. You usually override this method to perform additional initialization on views that were loaded from nib files.
     
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()

        
        let config = WKWebViewConfiguration()
        let source = "document.addEventListener('authorized', function(){ window.webkit.messageHandlers.iosListener.postMessage('click button!'); })"
        
        
        let script = WKUserScript(source: source as String, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        config.userContentController.addUserScript(script)
        config.userContentController.add(self, name: "iosListener")

        webViewSample?.translatesAutoresizingMaskIntoConstraints = false
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        config.preferences = preferences
                
        webViewSample = WKWebView(frame: view.bounds, configuration: config)
        webViewSample?.navigationDelegate = self
        webViewSample?.uiDelegate = self
        webViewSample?.allowsBackForwardNavigationGestures = true
        
        
        /**
         Load Request in webview to show Authorize Page
         
         - Parameters :
         - response_type
         - scope
         - client_id
         - redirect_uri for callback
         - nonce
         
         - Response :
         
         - Refresh Token
        
         */
        let requesturl = URL(string: "https://oauth2-staging.razerapi.com/authorize_new?response_type=id_token+token&scope=openid+profile+email&client_id=openidstaging&state=af0ifjsldkj&redirect_uri=http://54.205.51.49/callback&nonce=n-0S6_WzA2Mj")
        var request = URLRequest(url: requesturl!)
        request.httpShouldHandleCookies = true
        //let headers = HTTPCookie.requestHeaderFields(with: [(cookie)!])
        //request.allHTTPHeaderFields = headers
        request.addValue("CookieKey=value;", forHTTPHeaderField: "Cookie")
        
        
        self.view.addSubview((self.webViewSample)!)
        webViewSample?.load(request as URLRequest)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message: \(message.body)")
        // and whatever other actions you want to take
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
        
    }
    
    /**
     Called when webview finish request and send webview Url , title, frame, description in this function
     
     */

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
       // print("comes here%@%@%@",webView.url as Any,webView.title,webView.frame)
        
        let cookieProps = [
            HTTPCookiePropertyKey.domain: "oauth2.razerzone.com",
            HTTPCookiePropertyKey.path: "/services",
            HTTPCookiePropertyKey.name: "_rzru",
            HTTPCookiePropertyKey.value: "",
            HTTPCookiePropertyKey.secure: true,
            HTTPCookiePropertyKey.expires: Date().addingTimeInterval(1517370745)
            ] as [HTTPCookiePropertyKey : Any]
        
        let cookie = HTTPCookie(properties: cookieProps as Any as! [HTTPCookiePropertyKey : Any])
        HTTPCookieStorage.shared.setCookie(cookie!)
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        
        if(webView.url?.absoluteString.range(of: "access_token")) != nil {
            print("Navigation occurs")
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            vc.strAccessToken = webView.url?.absoluteString
            UserDefaults.standard.set(webView.url?.absoluteString, forKey: "token")
            UserDefaults.standard.synchronize()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if(webView.url?.absoluteString.range(of: "error")) != nil {
            print("Navigation occurs")
            _ = HTTPCookie.self
            let cookieJar = HTTPCookieStorage.shared

            for cookie in cookieJar.cookies! {
                // print(cookie.name+"="+cookie.value)
                cookieJar.deleteCookie(cookie)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        //Optional(http://54.205.51.49/callback?error=consent_required&error_description=The+user+denied+access+to+your+application&state=af0ifjsldkj)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

