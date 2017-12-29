//
//  PaymentController.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/22/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

class PaymentController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PaymentDelegate, SWRevealViewControllerDelegate {
    
    
    private let paymentControllerId = "paymentControllerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(PaymentCell.self, forCellWithReuseIdentifier: paymentControllerId)
        
        print("RV", self.revealViewController())
        if self.revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu2-black-32").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: paymentControllerId, for: indexPath) as! PaymentCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    func didTapPaymentCell(cell: PaymentCell) {
        let layout = UICollectionViewFlowLayout()
        let deliveryController = DeliveryController(collectionViewLayout: layout)
        let navDeliveryController = UINavigationController(rootViewController: deliveryController)
        present(navDeliveryController, animated: true, completion: nil)
    }
    
    
    
}
