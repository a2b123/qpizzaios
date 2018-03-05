//
//  OrderModel.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/30/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import Foundation

class OrderModel {
    var menuItem: MenuItemsModel?
    var quantity: Int
    
    init(menuItem: MenuItemsModel, quantity: Int) {
        self.menuItem = menuItem
        self.quantity = quantity
    }
}

class Order {
    static let currentOrder = Order()
    var restaurant: RestaurantModel?
    var items = [OrderModel]()
    var address: String?
    
    func getTotalOrderPrice() -> Float {
        var total: Float = 0
        for item in self  .items {
            if let price = item.menuItem?.price {
                let quantity = item.quantity
                total = total + Float(quantity) * price
            }
        }
        
        return total
    }
    
    func reset() {
        self.restaurant = nil
        self.items = []
        self.address = nil
    }
    
    
}
