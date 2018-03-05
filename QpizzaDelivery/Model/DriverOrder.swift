//
//  DriverOrder.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 1/17/18.
//  Copyright © 2018 AmarBhatia. All rights reserved.
//

import Foundation
import SwiftyJSON

class DriverOrder {
    var id: Int?
    var customerName: String?
    var customerAddress: String?
    var customerProfilePicture: String?
    var restaurantName: String?
    
    init(json: JSON) {
        self.id = json["id"].int
        self.customerName = json["customer"]["name"].string
        self.customerAddress = json["address"].string
        self.customerProfilePicture = json["customer"]["avatar"].string
        self.restaurantName = json["restaurant"]["name"].string
    }
}
