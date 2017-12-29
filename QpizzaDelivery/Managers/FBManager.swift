//
//  FBManager.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/24/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SwiftyJSON

class FBManager {
    
    static let shared = FBSDKLoginManager()
    
    public class func getFBUserData(completionHandler: @escaping () -> Void) {
        if (FBSDKAccessToken.current() != nil) {
            let parameters = ["fields": "name, email, picture.type(normal)"]
            FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, result, error) in
                
                if let error = error {
                    print("Error With FB Connection..:", error)
                }
                
                let json = JSON(result)
                UserModel.currentUser.setInfo(json: json)
//                print(json)X

                
                completionHandler()
                
            })
            
        }
    }
    
    
}
