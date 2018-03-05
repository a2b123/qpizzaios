//
//  PaymentCell.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/22/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit
import Stripe

protocol PaymentDelegate {
    func didTapPaymentCell(cell: PaymentCell)
    func showAlert(cell: PaymentCell)
}

class PaymentCell: BaseCell {
    
    var delegate: PaymentDelegate?
    
    let creditCardTextField: STPPaymentCardTextField = {
        let textField = STPPaymentCardTextField()
        return textField
    }()
    
    lazy var placeOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Place Order", for: .normal)
        button.setTitleColor(UIColor.qpizzaWhite(), for: .normal)
        button.addTarget(self, action: #selector(placeOrderButtonPressed), for: .touchUpInside)
        button.backgroundColor = UIColor.rgb(red: 78, green: 176, blue: 76)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = UIColor.qpizzaWhite()
        
        addSubview(creditCardTextField)
        addSubview(placeOrderButton)
        
        _ = creditCardTextField.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 22, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 50)
        creditCardTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = placeOrderButton.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 50)

    }
    
    
    @objc func placeOrderButtonPressed() {
        print("Place Order Button Pressed inside PaymentController")
        
        APIManager.shared.getLatestOrder { (json) in
            if json["order"]["status"] == .null || json["order"]["status"] == "Delivered" {
                // Processing the payment and create an Order
                
                let card = self.creditCardTextField.cardParams
                
                STPAPIClient.shared().createToken(withCard: card, completion: { (token, error) in
                    if let error = error {
                        print("Error with credit card placing order:", error)
                    } else if let stripeToken = token {
                        APIManager.shared.createOrder(stripeToken: stripeToken.tokenId, completionHandler: { (json) in
                            Order.currentOrder.reset()
                            self.delegate?.didTapPaymentCell(cell: self)
                        })
                    }
                })
            } else {
                // Show Alert
                self.delegate?.showAlert(cell: self)
            }
        }

    }
}
