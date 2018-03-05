//
//  APIManager.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/25/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKLoginKit
import CoreLocation

class APIManager {
    
    
    static let shared = APIManager()
    let baseURL = NSURL(string: BASE_URL)
    
    var accessToken = ""
    var refreshToken = ""
    var expired = Date()
    
    // API to Login a User
    func login(userType: String, completionHandler: @escaping (NSError?) -> Void) {
        
        let baseURL = NSURL(string: BASE_URL)
        
        let path = "api/social/convert-token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "grant_type": "convert_token",
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "backend": "facebook",
            "token": FBSDKAccessToken.current().tokenString,
            "user_type": userType
        ]
        
        print("Acceess Token:", (FBSDKAccessToken.current().tokenString))

        guard let urlConvertible = url else { return }
        Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON { (response) in
                        
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                self.accessToken = jsonData["access_token"].string!
                self.refreshToken = jsonData["refresh_token"].string!
                self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                
                completionHandler(nil)
                break
                
            case .failure(let error):
                completionHandler(error as NSError)
                break
            }
            
        }
    }
    
    
    // API to Logout a User
    func logout(completionHandler: @escaping (NSError?) -> Void) {
        let path = "api/social/revoke-token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "token": self.accessToken
        ]
    
        
        guard let urlConvertible = url else { return }
        Alamofire.request(urlConvertible, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseString { (response) in
            switch response.result {
            case .success:
                completionHandler(nil)
                break
                
            case .failure(let error):
                completionHandler(error as NSError?)
                break
            }
        }
    }
    
    // API to refresh the token when it's expired
    func refreshTokenIfNeed(completionHandler: @escaping () -> Void) {
        let path = "api/social/refresh-token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "access_token": self.accessToken,
            "refresh_token": self.refreshToken
        ]
        
        if (Date() > self.expired) {
            guard let urlConvertiable = url else { return }
            Alamofire.request(urlConvertiable, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    self.accessToken = jsonData["access_token"].stringValue
                    self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].intValue))
                    completionHandler()
                    break
                    
                case .failure:
                    break
                    
                }
                
            })
        } else {
            completionHandler()
        }
        
    }
    
    
    // Request Server Function
    func requestServer(_ method: HTTPMethod, _ path: String, _ params: [String: Any]? , _ encoding: ParameterEncoding, _ completionHandler: @escaping (JSON) -> Void) {
        
        let url = baseURL?.appendingPathComponent(path)
        
        refreshTokenIfNeed {
            
            guard let urlConvertible = url else { return }
            Alamofire.request(urlConvertible, method: method, parameters: params, encoding: encoding, headers: nil).responseJSON{response in
                
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    completionHandler(jsonData)
                    break
                    
                case .failure:
                    completionHandler(nil)
                    break
                }
            }
        }
    }
    
    
    // API getting Restaurants List
    func getRestaurants(completionHandler: @escaping (JSON) -> Void) {
        let path = "api/customer/restaurants/"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
    }
    
    // API - Getting List of Meal of a Restaurants
    func getMenuItems(restaurantId: Int, completionHandler: @escaping (JSON) -> Void) {
        let path = "api/customer/meals/\(restaurantId)"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
    }
    
    // API - Creating a New Order
    func createOrder(stripeToken: String, completionHandler: @escaping (JSON) -> Void) {
        let path = "api/customer/order/add/"
        let orderArray = Order.currentOrder.items
        let jsonArray = orderArray.map { item in
            return [
                "meal_id": item.menuItem?.id,
                "quantity": item.quantity
            ]
        }
        
        if JSONSerialization.isValidJSONObject(jsonArray) {
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                if let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    guard let restaurant_id = Order.currentOrder.restaurant?.id else { return }
                    guard let address = Order.currentOrder.address else { return }
                    let params: [String: Any] = [
                        "access_token": self.accessToken,
                        "stripe_token": stripeToken,
                        "restaurant_id": "\(restaurant_id)",
                        "order_details": dataString,
                        "address": address
                    ]
                    
                    requestServer(.post, path, params, URLEncoding(), completionHandler)
                }
            }
            
            catch {
                print("JSON Serialization failed:", error)
            }
        }
    } 
    
    //API - Getting the latest order (Customer)
    func getLatestOrder(completionHandler: @escaping (JSON) -> Void) {
        let path = "api/customer/order/latest/"
        let params: [String: Any] = [
            "access_token": self.accessToken
        ]
        
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    
    // API - Getting Driver's location
    func getDriverLocation(completionHandler: @escaping (JSON) -> Void) {
        let path = "api/customer/driver/location/"
        let params: [String: Any] = [
            "access_token": self.accessToken
        ]
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }

    /***** DRIVERS *****/
    
    // API - Getting list of orders that are ready
    func getDriverOrders(completionHandler: @escaping (JSON) -> Void) {
        let path = "api/driver/orders/ready/"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
    }
    
    // API - Picking up a ready order
    
    func pickOrder(orderId: Int, completionHandler: @escaping (JSON) -> Void) {
        let path = "api/driver/order/pick/"
        let params: [String: Any] = [
            "order_id": "\(orderId)",
            "access_token": self.accessToken
        ]
        
        requestServer(.post, path, params, URLEncoding(), completionHandler)
    }
    
    // API - Gettting the latest order for the driver
    func getCurrentDriverOrder(completionHandler: @escaping (JSON) -> Void) {
        let path = "api/driver/order/latest/"
        let params: [String: Any] = [
            "access_token": self.accessToken
        ]
        
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    
    // API - Updating Driver's Location
    func updateLocatin(location: CLLocationCoordinate2D, completionHandler: @escaping (JSON) -> Void) {
        let path = "api/driver/location/update/"
        let params: [String: Any] = [
            "access_token": self.accessToken,
            "location": "\(location.latitude), \(location.longitude)"
        ]
        
        requestServer(.post, path, params, URLEncoding(), completionHandler)
    }
    
    // API - Complete Order
    func completeOrder(orderId: Int, completionHandler: @escaping (JSON) -> Void) {
        let path = "api/driver/order/complete/"
        let params: [String: Any] = [
            "order_id": "\(orderId)",
            "access_token": self.accessToken
        ]
        
        requestServer(.post, path, params, URLEncoding(), completionHandler)
    }
    
}











