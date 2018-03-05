//
//  DriverOrderControllers.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 1/17/18.
//  Copyright © 2018 AmarBhatia. All rights reserved.
//

import UIKit

class DriverOrderController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let driverOrderCellId = "driverOrderCellId"
    
    var orders = [DriverOrder]()
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(DriverOrderCell.self, forCellWithReuseIdentifier: driverOrderCellId)
        collectionView?.backgroundColor = .white
        
        if self.revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_menu_24dp").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        loadReadyOrders()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: driverOrderCellId, for: indexPath) as! DriverOrderCell
        cell.driverOrder = self.orders[indexPath.item]
        return cell
    }
    
    func pickOrder(orderId: Int) {
        APIManager.shared.pickOrder(orderId: orderId) { (json) in
            if let status = json["status"].string {
                switch status {
                case "failed":
                    let alertView = UIAlertController(title: "Error", message: json["error"].string, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel)
                    
                    alertView.addAction(okAction)
                    self.present(alertView, animated: true, completion: nil)
                default:
                    let alertView = UIAlertController(title: nil, message: "Success!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Show My Map", style: .default, handler: { (action) in
                        // present the driver delivery controller
                        let layout = UICollectionViewFlowLayout()
                        let driverDeliveryController = DriverDeliveryController(collectionViewLayout: layout)
                        self.navigationController?.pushViewController(driverDeliveryController, animated: true)
                    })
                    
                    
                    alertView.addAction(okAction)
                    self.present(alertView, animated: true, completion: nil)
                    
                }
            }
        }
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let order = orders[indexPath.item]
        guard let orderId = order.id else { return }
        self.pickOrder(orderId: orderId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 140)
    }
    
    
    func loadReadyOrders() {
        Helpers.showActivityIndicator(activityIndicator, self.view)
        
        APIManager.shared.getDriverOrders { (json) in
            print(json)
            
            if json != .null {
                self.orders = []
                if let readyOrders = json["orders"].array {
                    for item in readyOrders {
                        let order = DriverOrder(json: item)
                        self.orders.append(order)
                    }
                }
                
                self.collectionView?.reloadData()
                Helpers.hideActivityIndicator(self.activityIndicator)
            }
        }
    }
}
