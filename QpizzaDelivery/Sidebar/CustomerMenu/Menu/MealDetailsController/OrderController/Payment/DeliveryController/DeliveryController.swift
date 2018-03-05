//
//  DeliveryController.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/22/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit
import MapKit

class DeliveryController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SWRevealViewControllerDelegate {
    
    private let deliveryCellId = "deliveryCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(DeliveryCell.self, forCellWithReuseIdentifier: deliveryCellId)
        
        print("RV in Delivery Status:", self.revealViewController())
        if self.revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_menu_24dp").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deliveryCellId, for: indexPath) as! DeliveryCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
}
