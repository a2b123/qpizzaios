//
//  OrderController.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/21/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

class OrderController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SWRevealViewControllerDelegate, OrderFooterDelegate {
    
    
    private let orderCellId = "orderCellId"
    private let orderFooterId = "orderFooterId"
    
    let screenSize = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.qpizzaRed()
        collectionView?.register(OrderCell.self, forCellWithReuseIdentifier: orderCellId)
        collectionView?.register(OrderFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: orderFooterId)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu2-black-32").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))



        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        

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

    func didTapPayent(cell: OrderFooter) {
        print("Handling button from within cell..")
        let layout = UICollectionViewFlowLayout()
        let paymentController = PaymentController(collectionViewLayout: layout)
        let navPaymentController = UINavigationController(rootViewController: paymentController)
        present(navPaymentController, animated: true, completion: nil)
    }

    @objc func doit() {
        self.revealViewController().revealToggle(self)
    }
}
