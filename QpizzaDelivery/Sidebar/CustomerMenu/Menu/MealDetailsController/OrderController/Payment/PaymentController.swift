//
//  PaymentController.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/22/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit
import Stripe

class PaymentController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PaymentDelegate, SWRevealViewControllerDelegate {
    
    
    private let paymentControllerId = "paymentControllerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(PaymentCell.self, forCellWithReuseIdentifier: paymentControllerId)
        self.hideKeyboardWhenTappedAround()
        
        print("RV: In Payment", self.revealViewController())
        if self.revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_menu_24dp").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
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
        createDeliverySlidingMenu()
    }
    
    func showAlert(cell: PaymentCell) {
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        let okAction = UIAlertAction(title: "Go to Order", style: .default) { (action) in
            self.createDeliverySlidingMenu()
        }
        
        let alertView = UIAlertController(title: "Already Order?", message: "Go to order", preferredStyle: .alert)
        alertView.addAction(okAction)
        alertView.addAction(cancelAction)
        
        self.present(alertView, animated: true, completion: nil)
    }
    
        
    func createDeliverySlidingMenu(){
        
        let layout = UICollectionViewFlowLayout()
        let frontViewController = UINavigationController(rootViewController: DeliveryController(collectionViewLayout: layout))//create instance of frontVC
        
        let rearViewController = CustomerMenuController(collectionViewLayout: layout)//create instance of rearVC(menuVC)
        
        
        //create instance of swRevealVC based on front and rear VC
        let swRevealVC = SWRevealViewController(rearViewController: rearViewController, frontViewController: frontViewController)
        swRevealVC?.toggleAnimationType = SWRevealToggleAnimationType.easeOut
        swRevealVC?.toggleAnimationDuration = 0.30
        
        //set swRevealVC as rootVC of windows
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = swRevealVC
    }

}
