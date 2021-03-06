//
//  OrderFooter.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/21/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol OrderFooterDelegate: class {
    func didTapPayent(cell: OrderFooter)
    func showAlert(cell: OrderFooter)
}

class OrderFooter: UICollectionReusableView, CLLocationManagerDelegate, UITextFieldDelegate {

    let screenSize = UIScreen.main.bounds
    var delegate: OrderFooterDelegate?
    var locationManager: CLLocationManager?


    let totalView: UIView = {
        let view = UIView()
        return view
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.00"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()

    let topSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    
    let bottomSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    
    let addressView: UIView = {
        let view = UIView()
        return view
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()

    
    let addressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Address"
        return textField
    }()
    
    let mapView: MKMapView = {
        let mp = MKMapView()
        return mp
    }()
    
    lazy var addPaymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Payment", for: .normal)
        button.setTitleColor(UIColor.qpizzaWhite(), for: .normal)
        button.addTarget(self, action: #selector(addPaymentButtonPressed), for: .touchUpInside)
        button.backgroundColor = UIColor.rgb(red: 78, green: 176, blue: 76)
        button.titleLabel?.textAlignment = .center
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        backgroundColor = .white
//        getLatestOrder()
        checkCurrentOrder()
        showUsersLocation()

        
        addSubview(totalView)
        addSubview(totalLabel)
        addSubview(totalPriceLabel)
        addSubview(topSeperatorView)
        addSubview(bottomSeperatorView)
        
        addSubview(addressView)
        addSubview(addressLabel)
        addSubview(addressTextField)
        addSubview(mapView)
        addSubview(addPaymentButton)
        
        
        // Total Label Constraints
        _ = totalView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
        
        _ = topSeperatorView.anchor(totalView.topAnchor, left: totalView.leftAnchor, bottom: nil, right: totalView.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 1)
        
        _ = totalLabel.anchor(nil, left: totalView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 65, heightConstant: 0)
        totalLabel.centerYAnchor.constraint(equalTo: totalView.centerYAnchor).isActive = true
        
        _ = totalPriceLabel.anchor(nil, left: nil, bottom: nil, right: totalView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 65, heightConstant: 0)
        totalPriceLabel.centerYAnchor.constraint(equalTo: totalView.centerYAnchor).isActive = true
        
        _ = bottomSeperatorView.anchor(nil, left: totalView.leftAnchor, bottom: totalView.bottomAnchor, right: totalView.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 1)

        // Address Label Constraints
        
        _ = addressView.anchor(totalView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
        
        _ = addressLabel.anchor(nil, left: addressView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 65, heightConstant: 0)
        addressLabel.centerYAnchor.constraint(equalTo: addressView.centerYAnchor).isActive = true

        _ = addressTextField.anchor(nil, left: addressLabel.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        addressTextField.centerYAnchor.constraint(equalTo: addressView.centerYAnchor).isActive = true
        
        _  = mapView.anchor(addressView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: screenSize.height / 5)
        _ = addPaymentButton.anchor(mapView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    
    }
    
    func getLatestOrder() {
        APIManager.shared.getLatestOrder { (json) in
            if json == .null {
                self.checkCurrentOrder()
            } else {
                print(json)
            }
            
            
            
            //            if let orderDetails = json["order"]["order_details"].array {
            //                self.order = orderDetails
            //                self.collectionView.reloadData()
            //            }
        }
    }

    
    func checkCurrentOrder() {

        if Order.currentOrder.items.count == 0 {
            totalLabel.isHidden = true
            totalPriceLabel.isHidden = true
            mapView.isHidden = true
            addressLabel.isHidden = true
            addressTextField.isHidden = true
            topSeperatorView.isHidden = true
            bottomSeperatorView.isHidden = true
            addPaymentButton.isHidden = true
            
        } else {
            totalLabel.isHidden = false
            totalPriceLabel.isHidden = false
            mapView.isHidden = false
            addressLabel.isHidden = false
            addressTextField.isHidden = false
            topSeperatorView.isHidden = false
            bottomSeperatorView.isHidden = false
            addPaymentButton.isHidden = false
            totalPriceLabel.text = "$\(Order.currentOrder.getTotalOrderPrice())"
        }

    }
    
    func showUsersLocation() {
        addressTextField.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.requestAlwaysAuthorization()
            locationManager?.startUpdatingLocation()
            
            mapView.showsUserLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let address = textField.text {
            let geocoder = CLGeocoder()
            Order.currentOrder.address = address
            
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                if let error = error {
                    print("Error with geocoding address string:", error)
                }
                
                if let placemark = placemarks?.first {
                    if let location = placemark.location?.coordinate {
                        let coordiantes:  CLLocationCoordinate2D = location
                        let region = MKCoordinateRegion(
                            center: coordiantes,
                            span: MKCoordinateSpanMake(0.01, 0.01)
                        )
                        
                        self.mapView.setRegion(region, animated: true)
                        self.locationManager?.stopUpdatingLocation()
                        
                        let dropPin = MKPointAnnotation()
                        dropPin.coordinate = coordiantes
                        self.mapView.addAnnotation(dropPin)
                    }
                }
            }
        }
        
        return true
    }
    
    @objc func addPaymentButtonPressed() {
        print("Add Payment Button Pressed")
        if addressTextField.text == "" {
            delegate?.showAlert(cell: self)
            addressTextField.becomeFirstResponder()
        } else {
            Order.currentOrder.address = addressTextField.text
            delegate?.didTapPayent(cell: self)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
