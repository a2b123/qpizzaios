//
//  MenuDetailsCell.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/9/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

protocol MenuDelegate {
    func handleOrder(cell: MenuDetailsCell, quantity: Int)
}

class MenuDetailsCell: BaseCell {
    
    var delegate: MenuDelegate?

    var quantity = 1
    let menuDetailsController = MenuDetailsController()

    var menuModel: MenuItemsModel? {
        didSet {
            menuItemLabel.text = menuModel?.name
            menuItemDetailsLabel.text = menuModel?.short_description
            quantityLabel.text = "\(quantity)"
            if let menuItemImageUrl = menuModel?.image {
                menuItemImageView.loadImage(urlString: menuItemImageUrl)
            }
            
            if let price = menuModel?.price {
                menuItemPriceLabel.text = "$\(price)"
            }
        }
    }
    
    let menuItemImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.image = #imageLiteral(resourceName: "button_chicken").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let menuItemLabel: UILabel = {
        let label = UILabel()
        label.text = "Restaurant King"
        label.textColor = UIColor.qpizzaWhite()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let menuItemDetailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Grass fed grass, American cheese, and friez. This is very good food yes it is stop checking yelp"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.qpizzaWhite()
//        label.numberOfLines = 0
        label.textAlignment = .center
        label.numberOfLines = 4
        return label
    }()
    
    lazy var addMenuItemButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Meal To Order", for: .normal)
        button.setTitleColor(UIColor.qpizzaWhite(), for: .normal)
        button.addTarget(self, action: #selector(addMealButtonPressed), for: .touchUpInside)
        button.backgroundColor = UIColor.rgb(red: 78, green: 176, blue: 76)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let menuItemPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "$12.00"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.qpizzaWhite()
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    let quantityLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.qpizzaWhite()
        label.textAlignment = .center
        return label
    }()

    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.qpizzaWhite(), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()

    lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.qpizzaWhite(), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(minusButtonPressed), for: .touchUpInside)
        return button
    }()

    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = UIColor.qpizzaRed()
        
        addConstraintsAndViews()
    
        
    }
    
    func addConstraintsAndViews() {
        
        let screenSize = UIScreen.main.bounds
        let dividerView = UIView()
        dividerView.backgroundColor = UIColor.qpizzaWhite()

        
        addSubview(containerView)
        _ = containerView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 90)
        
        addSubview(menuItemImageView)
        addSubview(menuItemLabel)
        addSubview(menuItemDetailsLabel)
        addSubview(dividerView)
        
        containerView.addSubview(addMenuItemButton)
        containerView.addSubview(menuItemPriceLabel)
        
        containerView.addSubview(quantityLabel)
        containerView.addSubview(addButton)
        containerView.addSubview(minusButton)
        
        _ = menuItemImageView.anchor(topAnchor, left: nil, bottom: nil, right: nil, topConstant: screenSize.height / 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 200)
        menuItemImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        
        _ = menuItemLabel.anchor(menuItemImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 14, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 40)
        menuItemLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = dividerView.anchor(menuItemLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: screenSize.width / 4, heightConstant: 4)
        dividerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        
        _ = menuItemDetailsLabel.anchor(dividerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 64)
        menuItemDetailsLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        _ = addMenuItemButton.anchor(nil, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 4, rightConstant: 8, widthConstant: 0, heightConstant: 50)
        
        _ = quantityLabel.anchor(nil, left: addButton.rightAnchor, bottom: addMenuItemButton.topAnchor, right: minusButton.leftAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 30)
        
        _ = addButton.anchor(nil, left: leftAnchor, bottom: addMenuItemButton.topAnchor, right: nil, topConstant: 0, leftConstant: 4, bottomConstant: 4, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
        _ = minusButton.anchor(nil, left: nil, bottom: addMenuItemButton.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 4, widthConstant: 30, heightConstant: 30)
        
        _ = menuItemPriceLabel.anchor(nil, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 14, widthConstant: 76, heightConstant: 0)

    }
    
    @objc func addMealButtonPressed() {
        print("Add Meal Button Pressed")
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        imageView.image = #imageLiteral(resourceName: "button_chicken").withRenderingMode(.alwaysOriginal)
        imageView.center = CGPoint(x: frame.width / 2, y: frame.height - 100)
        self.addSubview(imageView)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
            imageView.center = CGPoint(x: self.frame.width - 40, y: 24)
        }) { (true) in
            imageView.removeFromSuperview()
            
            self.delegate?.handleOrder(cell: self, quantity: self.quantity)
            
        }
    }
    
    @objc func addButtonPressed() {
        print("Add Button Pressed")
        
        if quantity < 99 {
            quantity += 1
            quantityLabel.text = String(quantity)
            if let price = menuModel?.price {
                menuItemPriceLabel.text = "$\(price * Float(quantity))"
            }
        }
    }
    
    @objc func minusButtonPressed() {
        print("Minus Button Pressed")
        
        if quantity >= 2 {
            quantity -= 1
            quantityLabel.text = String(quantity)
            if let price = menuModel?.price {
                menuItemPriceLabel.text = "$\(price * Float(quantity))"
            }
        }
    }
}
