//
//  DriverDeliveryCollectionViewCell.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 1/17/18.
//  Copyright © 2018 AmarBhatia. All rights reserved.
//

import UIKit
import MapKit

class DriverDeliveryCollectionViewCell: BaseCell, MKMapViewDelegate {

    var orderId: Int?
    
    let driverDeliveryCell = DriverDeliveryCell()
    
    var destination: MKPlacemark?
    var source: MKPlacemark?

    
    var driverOrder: DriverOrder? {
        didSet {
        }
    }
    
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
        driverDeliveryCell.mapView.delegate = self
        
        loadData()
        
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
    
    func loadData() {
        APIManager.shared.getCurrentDriverOrder { (json) in
            let order = json["order"]
            
            if let id = order["id"].int, order["status"] == "On the way" {
                
                self.orderId = id
                
                let from = order["address"].stringValue
                let to = order["restaurant"]["address"].stringValue
                
                let customerName = order["customer"]["name"].stringValue
                let customerAvatar = order["customer"]["avatar"].stringValue
                
                self.customerNameLabel.text = customerName
                self.customerAddressLabel.text = from
                
                self.customerLogoImageView.image = try! UIImage(data: Data(contentsOf: URL(string: customerAvatar)!))
                self.customerLogoImageView.layer.cornerRadius = 50 / 2
                self.customerLogoImageView.clipsToBounds = true
                
                self.driverDeliveryCell.getLocation(from, "Customer", { (sou) in
                    self.source = sou
                    print("Check:", self.source!)
//                    print("Check:", self.driverDeliveryCell.source!)

                    self.driverDeliveryCell.getLocation(to, "Restaurant", { (des) in
                        self.destination = des
                        print("Check:", self.destination!)
//                        print("Check:", self.driverDeliveryCell.destination!)
//                        self.driverDeliveryCell.getDirections()
                    })
                })
            } else {
                
                self.containerView.isHidden = true
                self.driverDeliveryCell.mapView.isHidden = true
                self.driverDeliveryCell.statusButton.isHidden = true
                
                // Showing a message here
                
                let lbMessage = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40))
                lbMessage.center = self.center
                lbMessage.textAlignment = NSTextAlignment.center
                lbMessage.text = "You don't have any orders for delivery."

                self.addSubview(lbMessage)

            }
        }
    }
    
}



