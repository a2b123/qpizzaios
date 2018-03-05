//
//  MenuCell.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/9/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

class MenuCell: BaseCell {
    
    
    var menu: MenuItemsModel? {
        didSet {
            
            menuItemLabel.text = menu?.name
            menuItemDetailLabel.text = menu?.short_description
            guard let menuImageUrl = menu?.image else { return }
            menuItemImageView.loadImage(urlString: menuImageUrl)
            if let price = menu?.price {
                menuItemPriceLabel.text = "$\(price)"
            }
        }
    }
    
    let menuItemLabel: UILabel = {
        let label = UILabel()
        label.text = "Restaurant King"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let menuItemImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.image = #imageLiteral(resourceName: "button_chicken").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let menuItemDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Grass fed grass, American cheese, and friez"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.qpizzaBlack()
        label.numberOfLines = 0
        return label
    }()
    
    let menuItemPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "$12.00"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.qpizzaBlack()
        return label
    }()
    
    let sepereatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = UIColor.qpizzaWhite()
        
        addSubview(menuItemLabel)
        addSubview(menuItemImageView)
        addSubview(menuItemDetailLabel)
        addSubview(menuItemPriceLabel)
        addSubview(sepereatorView)
        
        _ = menuItemImageView.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 14, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 60, heightConstant: 60)
        _ = menuItemLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: menuItemImageView.leftAnchor, topConstant: 14, leftConstant: 12, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 20)
        _ = menuItemDetailLabel.anchor(menuItemLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: menuItemImageView.leftAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 30)
        _ = menuItemPriceLabel.anchor(menuItemDetailLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 12, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 20)
        _ = sepereatorView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 1)
        
        
    }
}
