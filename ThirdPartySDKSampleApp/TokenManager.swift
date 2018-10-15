//
//  RzToken.swift
//  razerMobileKit
//
//  Created by arun kuttappan on 29/6/17.
//  Copyright © 2017 razer. All rights reserved.
//

import UIKit

/**
 This class is designed and implemented represents an immutable Token for using Razer APIs
 */

class Token
{
    /**
     Token contains the access token info receive from the other App.
     */
    public var token : String?
    
    /**
     tokenExpiryTime contains the access token Expiry Time
     */
    
    public var tokenExpiryTime : Date!
    
    /**
     Token contains the access token Updated Time
     */
    public var tokenUpdatedTime : Date!
    
    
    /**
    
    Method to access token related info in any class
     - Parameters:
       - token: Can access token
       - tokenUpdated: Can Access token updated Time
       - tokenExpiry: Can Access token Expiry Time
    */
    required init(token:String! , tokenUpdated:Date!, tokenExpiry:Date! ) {
        self.token = token
        self.tokenExpiryTime = tokenExpiry
        self.tokenUpdatedTime = tokenUpdated
    }
    
    func isValidToSave() -> Bool
    {
        var isValid : Bool = false
        if(self.token != nil && (self.token?.count)! > 0 && self.tokenExpiryTime != nil && self.tokenUpdatedTime != nil)
        {
            isValid = true
        }
        
        return isValid
    }
}

/**
 Extension to provide time in String
 */

public extension Date {
    
    public func timeInString() -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        let  string = dateFormatter.string(from: self)
        
        return string
    }
}

public extension String {
    
    public func stringToTime() -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
        let dataDate = dateFormatter.date(from:self)
        return dataDate
    }
}

