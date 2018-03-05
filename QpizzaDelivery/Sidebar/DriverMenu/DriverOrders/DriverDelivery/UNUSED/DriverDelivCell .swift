//
//  DriverDelivCell .swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 3/4/18.
//  Copyright © 2018 AmarBhatia. All rights reserved.
//

import UIKit

class DriverDelivCell: BaseCell {
    
    let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Restaurant Name"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.qpizzaBlack()
        return label
    }()
    
    let customerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Customer Name Name"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.qpizzaBlack()
        return label
    }()
    
    
    let customerAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "1234 Something Something Road"
        label.font = UIFont.italicSystemFont(ofSize: 10.0)
        label.textColor = UIColor.qpizzaBlack()
        return label
    }()
    
    
    let customerLogoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.image = #imageLiteral(resourceName: "taylor-swift").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.qpizzaWhite()
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
                
        addSubview(restaurantNameLabel)
        
        _ = restaurantNameLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 30)
        
        addSubview(containerView)
        
        _ = containerView.anchor(restaurantNameLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        containerView.addSubview(customerLogoImageView)
        containerView.addSubview(customerNameLabel)
        containerView.addSubview(customerAddressLabel)
        
        _ = customerLogoImageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 60)
        
        _ = customerNameLabel.anchor(containerView.topAnchor, left: customerLogoImageView.rightAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 30)
        
        _ = customerAddressLabel.anchor(customerNameLabel.bottomAnchor, left: customerLogoImageView.rightAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 30)
        
        
    }
}
