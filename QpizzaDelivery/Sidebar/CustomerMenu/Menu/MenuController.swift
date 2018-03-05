//
//  MenuViewController.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/8/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

class MenuController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SWRevealViewControllerDelegate {
    
    private let menuCellId = "menuCellId"
    
    var restaurant: RestaurantModel?
    var menuItems = [MenuItemsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.qpizzaWhite()
        collectionView?.register(MenuCell.self, forCellWithReuseIdentifier: menuCellId)
        collectionView?.alwaysBounceVertical = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let restaurantName = restaurant?.name {
            self.navigationItem.title = restaurantName
        }

        loadMenuItems()
        
        

    }
    
    private let activityIndicator = UIActivityIndicatorView()
    
    func loadMenuItems() {
        
        if let restaurantId = restaurant?.id {
            
            Helpers.showActivityIndicator(activityIndicator, view)
            
            APIManager.shared.getMenuItems(restaurantId: restaurantId, completionHandler: { (json) in
                if json != nil {
                    self.menuItems = []
                    
                    if let tempMenuItems = json["meals"].array {
                        for item in tempMenuItems {
                            let meal = MenuItemsModel(json: item)
                            self.menuItems.append(meal)
                            
                        }
                        
                        self.collectionView?.reloadData()
                        Helpers.hideActivityIndicator(self.activityIndicator)
                    }
                }
            })
        }
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellId, for: indexPath) as! MenuCell
        cell.menu = menuItems[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controller = MenuDetailsController(collectionViewLayout: layout)
        controller.menuModel = menuItems[indexPath.item]
        controller.restaurant = restaurant
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }

    
}
