//
//  DriverMenuController.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/7/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

class DriverMenuController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let driverMenuCellId = "driverMenuCellId"
    private let driverHeaderId = "driverHeaderId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Driver"
        
        collectionView?.backgroundColor = UIColor.qpizzaWhite()
        collectionView?.register(DriverMenuCell.self, forCellWithReuseIdentifier: driverMenuCellId)
        collectionView?.register(DriverHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: driverHeaderId)

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu2-black-32").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))

    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: driverMenuCellId, for: indexPath) as! DriverMenuCell
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width, height: 150)
        return size
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: driverHeaderId, for: indexPath) as! DriverHeader
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }


}

