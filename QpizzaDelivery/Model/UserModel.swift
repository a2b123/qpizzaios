//
//  UserModel.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/25/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import Foundation
import SwiftyJSON


class UserModel {
    var name: String?
    var email: String?
    var profileImageUrl: String?
    
    static let currentUser = UserModel()
    
    func setInfo(json: JSON) {
        self.name = json["name"].string
        self.email = json["email"].string
        
        let image = json["picture"].dictionary
        let imageData = image?["data"]?.dictionary
        self.profileImageUrl = imageData?["url"]?.string
    }
    
    
    func resetInfo() {
        self.name = nil
        self.email = nil
        self.profileImageUrl = nil
    }
    
    
}
