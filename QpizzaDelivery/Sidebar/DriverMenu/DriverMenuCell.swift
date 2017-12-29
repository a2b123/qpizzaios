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
    
    override func setupViews() {
        super.setupViews()
        addSubview(optionLabel)
        
        
        
        backgroundColor = .orange
    }

}
