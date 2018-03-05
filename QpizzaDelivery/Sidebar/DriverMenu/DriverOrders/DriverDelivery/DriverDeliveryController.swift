//
//  DriverDeliveryController.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 1/17/18.
//  Copyright © 2018 AmarBhatia. All rights reserved.
//

import UIKit
import MapKit

class DriverDeliveryController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let driverDeliveryCell = "driverDeliveryCell"


    var orderId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let driverDeliveryCollectionViewCell = DriverDeliveryCollectionViewCell()
//        driverDeliveryCollectionViewCell.loadData()
        
        collectionView?.register(DriverDeliveryCell.self, forCellWithReuseIdentifier: driverDeliveryCell)
        collectionView?.backgroundColor = UIColor.qpizzaRed()
        
        if self.revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_menu_24dp").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    func didLoadData(cell: DriverDeliveryCollectionViewCell) {
        print("Loading Data")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: driverDeliveryCell, for: indexPath) as! DriverDeliveryCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    
    
}
