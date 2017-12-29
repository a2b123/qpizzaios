//
//  MenuDetailsController.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/9/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

class MenuDetailsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SWRevealViewControllerDelegate {
    
    private let menuDetailsCell = "menuDetailsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.qpizzaRed()
        collectionView?.register(MenuDetailsCell.self, forCellWithReuseIdentifier: menuDetailsCell)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "button_tray").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(rightBarButtonPressed))
//        collectionView?.alwaysBounceVertical = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuDetailsCell, for: indexPath) as! MenuDetailsCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let navHeight = self.navigationController?.navigationBar.intrinsicContentSize.height
        // FIX: This needs to change...why does view.frame.height not work?
        return CGSize(width: view.frame.width, height: view.frame.height - (navHeight! * 1.7))
//        return CGSize(width: view.frame.width, height: view.frame.height - 74)
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)

    }
    
    @objc func rightBarButtonPressed() {
        print("Right Bar Button Pressed")
        let layout = UICollectionViewFlowLayout()
        let orderController = OrderController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: orderController)
        present(navController, animated: true, completion: nil)
        
    }
    
    
}
