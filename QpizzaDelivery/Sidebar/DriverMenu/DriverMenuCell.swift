//
//  DriverMenuCell.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/7/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

class DriverMenuCell: BaseCell {
    
    let optionLabel: UILabel = {
        let label = UILabel()
        label.text = "Option"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    
    let optionImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "icon_order")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = UIColor.qpizzaRed()
        
        addSubview(optionLabel)
        addSubview(optionImage)
        
        
        _ = optionImage.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        optionImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        _ = optionLabel.anchor(nil, left: optionImage.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        optionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
    }
}
