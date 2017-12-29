//
//  RestaurantController.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/8/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class RestaurantController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SWRevealViewControllerDelegate, UISearchBarDelegate, RestaurantDelegate {
    
    var restaurants = [RestaurantModel]()

    
    private let restaurantCellId = "restaurantCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.qpizzaWhite()
        collectionView?.register(RestaurantCell.self, forCellWithReuseIdentifier: restaurantCellId)
        
        
        if self.revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_menu_24dp").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }
    
    // FIXME: issue with this...navigationcontroller is presenting, not pushing ontop of stack view
    func didTapRestaurantCell(cell: RestaurantCell) {
        print("Did Tap Restaurant Cell - Restaurant Controller")
        
        let layout = UICollectionViewFlowLayout()
        let controller = MenuController(collectionViewLayout: layout)
        navigationController?.pushViewController(controller, animated: true)
        
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: restaurantCellId, for: indexPath) as! RestaurantCell
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
