//
//  RestaurantModel.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/26/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import Foundation
import SwiftyJSON

class RestaurantModel {
    var id: Int?
    var name: String?
    var address: String?
    var logo: String?

    init(json: JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        self.address = json["address"].string
        self.logo = json["logo"].string
    }
}

