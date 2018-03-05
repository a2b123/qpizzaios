//
//  DriverStatisticsController.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 1/17/18.
//  Copyright © 2018 AmarBhatia. All rights reserved.
//

import UIKit

class DriverStatisticsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let driverStatisticsCell = "driverStatisticsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(DriverStatisticsCell.self, forCellWithReuseIdentifier: driverStatisticsCell)
        collectionView?.backgroundColor = .white
        
        if self.revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_menu_24dp").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: driverStatisticsCell, for: indexPath) as! DriverStatisticsCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    
    
    
    
    
    
}
