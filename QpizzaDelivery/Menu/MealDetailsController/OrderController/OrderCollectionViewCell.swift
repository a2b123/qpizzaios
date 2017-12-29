//
//  OrderCollectionViewCell.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/21/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

class OrderCollectionViewCell: BaseCell {
    
    let quantityLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let subTotalLabel: UILabel = {
        let label = UILabel()
        label.text = "$12.99"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    let mealNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Burger King"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()

    
    
    override func setupViews() {
        
        super.setupViews()
        
        backgroundColor = .white
        
        addSubview(quantityLabel)
        addSubview(mealNameLabel)
        addSubview(subTotalLabel)
        
        _ = quantityLabel.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        quantityLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        _ = mealNameLabel.anchor(nil, left: quantityLabel.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        mealNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        _ = subTotalLabel.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 65, heightConstant: 0)
        subTotalLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    }
}
