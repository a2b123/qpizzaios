//
//  RestaurantCollectionViewCell .swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/27/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

class RestaurantCollectionViewCell: BaseCell {
    
    var restauarnt: RestaurantModel? {
        didSet {
            print("Setting")
        }
    }

    
    let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Qpizza"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.qpizzaBlack()
        return label
    }()
    
    let restaurantAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "1234 Something Something Road"
        label.font = UIFont.italicSystemFont(ofSize: 10.0)
        label.textColor = UIColor.qpizzaBlack()
        return label
    }()
    
    
    let restaurantLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "taylor-swift").withRenderingMode(.alwaysOriginal)
//        iv.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
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
        
        backgroundColor = UIColor.qpizzaRed()
        
        addSubview(restaurantLogoImageView)
        addSubview(containerView)
        
        _ = restaurantLogoImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 125)
        restaurantLogoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        _ = containerView.anchor(restaurantLogoImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 14, leftConstant: 10, bottomConstant: 6, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        //        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        containerView.addSubview(restaurantNameLabel)
        containerView.addSubview(restaurantAddressLabel)
        
        _ = restaurantNameLabel.anchor(restaurantLogoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 30)
        
        _ = restaurantAddressLabel.anchor(restaurantNameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 12, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 20)
        
    }
}
