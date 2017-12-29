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
        
        if self.revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu2-black-32").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        print("Restaurant Name:", restaurant?.name) // returns nil
        if let restaurantName = restaurant?.name {
            self.navigationItem.title = restaurantName
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadMenuItems()

    }
    
    func loadMenuItems() {
        print("Restaurant Id:", restaurant?.id) // returns nil
        if let restaurantId = restaurant?.id {
            APIManager.shared.getMenuItems(restaurantId: restaurantId, completionHandler: { (json) in
                
            })
        }
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellId, for: indexPath) as! MenuCell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controller = MenuDetailsController(collectionViewLayout: layout)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }

    
}
