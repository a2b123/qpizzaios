//
//  OrderController.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/21/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit
import CoreLocation

class OrderController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SWRevealViewControllerDelegate, OrderFooterDelegate {
    
    private let orderCellId = "orderCellId"
    private let orderFooterId = "orderFooterId"
    
    let screenSize = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        collectionView?.backgroundColor = UIColor.qpizzaRed()
        collectionView?.register(OrderCell.self, forCellWithReuseIdentifier: orderCellId)
        collectionView?.register(OrderFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: orderFooterId)
        
        if self.revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_menu_24dp").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        checkCurrentOrder()
 
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: orderCellId, for: indexPath) as! OrderCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // FIX: This needs to change...why does view.frame.height not work?
        return CGSize(width: view.frame.width, height: view.frame.height / 2)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: orderFooterId, for: indexPath) as! OrderFooter
        footer.delegate = self
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // FIX: This needs to change...why does view.frame.height not work?
        return CGSize(width: view.frame.width, height: view.frame.height / 2)
    }
    
    
    func checkCurrentOrder() {
        print("Orders:", Order.currentOrder.items.count)
        APIManager.shared.getLatestOrder { (json) in
            if json["order"]["status"] == .null || json["order"]["status"] == "Delivered" && Order.currentOrder.items.count == 0 {
                let emptyOrderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
                emptyOrderLabel.center = self.view.center
                emptyOrderLabel.textAlignment = .center
                emptyOrderLabel.text = "You have no orders. Please select a menu item."
                self.view.addSubview(emptyOrderLabel)
                } else {
                self.collectionView?.reloadData()
            }
        }
    }
        
    //MARK: Delegate Methods

    func didTapPayent(cell: OrderFooter) {
        print("Handling button from within cell..")
        let layout = UICollectionViewFlowLayout()
        let paymentController = PaymentController(collectionViewLayout: layout)
//        navigationController?.pushViewController(paymentController, animated: true)
        let navPaymentController = UINavigationController(rootViewController: paymentController)
        present(navPaymentController, animated: true, completion: nil)
    }
    
    func showAlert(cell: OrderFooter) {
        alert(message: "Address is required for delivery", title: "No Address")
    }

}
