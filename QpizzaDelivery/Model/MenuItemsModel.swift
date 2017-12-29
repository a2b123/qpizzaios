//
//  MenuItemsModel.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/27/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import Foundation
import SwiftyJSON

class MenuItemsModel {
    var id: Int?
    var name: String?
    var short_description: String?
    var image: String?
    var price: Float?
    
    init(json: JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        self.short_description = json["short_description"].string
        self.image = json["image"].string
        self.price = json["price"].float
    }
    
}
