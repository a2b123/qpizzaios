//
//  DriverDeliveryCell.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 1/17/18.
//  Copyright © 2018 AmarBhatia. All rights reserved.
//

import UIKit
import MapKit

class DriverDeliveryCell: BaseCell, MKMapViewDelegate, CLLocationManagerDelegate {
    
    private let driverDeliveryCollectionViewCell = "driverDeliveryCollectionViewCell"
    let screenSize = UIScreen.main.bounds
    
    var orderId: Int?
    
    var destination: MKPlacemark?
    var source: MKPlacemark?
    
    var locationManager: CLLocationManager!
    var driverPin: MKPointAnnotation!
    var lastLocation: CLLocationCoordinate2D!
    
    var timer = Timer()
    
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

    
    let mapView: MKMapView = {
        let mV = MKMapView()
        mV.clipsToBounds = true
        mV.backgroundColor = .blue
        return mV
    }()
        
    lazy var statusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete Order", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(statusButtonPressed), for: .touchUpInside)
        button.setTitleColor(UIColor.qpizzaWhite(), for: .normal)
        button.backgroundColor = UIColor.qpizzaGold()
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        loadData()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            self.mapView.showsUserLocation = false
        }

        
        /// Running the updating location process
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLocation(_ :)), userInfo: nil, repeats: true)
        
        backgroundColor = .white
        mapView.delegate = self
        showDriversLocation()
        
        addSubview(mapView)
        addSubview(statusButton)
        addSubview(containerView)
        
        containerView.addSubview(customerLogoImageView)
        containerView.addSubview(customerNameLabel)
        containerView.addSubview(customerAddressLabel)
        
        _ = mapView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: screenSize.height * (3/5))
        
        _ = containerView.anchor(mapView.bottomAnchor, left: leftAnchor, bottom: statusButton.topAnchor, right: rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: screenSize.height * (3/5))
        
        _ = customerLogoImageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 60)
        
        _ = customerNameLabel.anchor(containerView.topAnchor, left: customerLogoImageView.rightAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 30)
        
        _ = customerAddressLabel.anchor(customerNameLabel.bottomAnchor, left: customerLogoImageView.rightAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 30)

        
        _ = statusButton.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)

    }
    

    @objc func statusButtonPressed() {
        print("Status Button Pressed")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            APIManager.shared.completeOrder(orderId: self.orderId!, completionHandler: { (json) in
                
            })
        }
        
        
    }
    
    @objc func updateLocation(_ sender: AnyObject) {
        APIManager.shared.updateLocatin(location: self.lastLocation) { (json) in
            
        }
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
                
                self.getLocation(from, "Customer", { (sou) in
                    self.source = sou
                    print("Check:", self.source!)
                    //                    print("Check:", self.driverDeliveryCell.source!)
                    
                    self.getLocation(to, "Restaurant", { (des) in
                        self.destination = des
                        print("Check:", self.destination!)
                    })
                })
            } else {
                
                self.containerView.isHidden = true
                self.mapView.isHidden = true
                self.statusButton.isHidden = true
                
                // Showing a message here
                
                let lbMessage = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40))
                lbMessage.center = self.center
                lbMessage.textAlignment = NSTextAlignment.center
                lbMessage.text = "You don't have any orders for delivery."
                
                self.addSubview(lbMessage)
                
            }
        }
    }

    
    
    func showDriversLocation() {
        // Show Driver's Currrent Location
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            self.mapView.showsUserLocation = false
        }
    }
    
    
    // MKMapViewDelegate Methods
    
    // #1 - Delegate method of MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    // #2 - Convert an address string to a location on the map
    func getLocation(_ address: String,_ title: String,_ completionHandler: @escaping (MKPlacemark) -> Void) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            
            if (error != nil) {
                print("Error: ", error)
            }
            
            if let placemark = placemarks?.first {
                
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                
                // Create a pin
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = title
                
                self.mapView.addAnnotation(dropPin)
                completionHandler(MKPlacemark.init(placemark: placemark))
            }
        }
    }

////    // #3 - Get direction and zoom to address
//    func getDirections() {
//
//        let request = MKDirectionsRequest()
//        request.source = MKMapItem.init(placemark: source!)
//        request.destination = MKMapItem.init(placemark: destination!)
//        request.requestsAlternateRoutes = false
//
//        let directions = MKDirections(request: request)
//        directions.calculate { (response, error) in
//
//            if error != nil {
//                print("Error: ", error)
//            } else {
//                // Show route
//                self.showRoute(response: response!)
//            }
//        }
//
//    }
//
//    // #4 - Show route between locations and make a visible zoom
//    func showRoute(response: MKDirectionsResponse) {
//
//        for route in response.routes {
//            self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
//            print("Time in Mins:", route.expectedTravelTime / 60)
//        }
//
//        // Reset zoom rect to cover 3 locations
//        var zoomRect = MKMapRectNull
//        for annotation in self.mapView.annotations {
//            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
//            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1)
//            zoomRect = MKMapRectUnion(zoomRect, pointRect)
//        }
//
//        let insetWidth = -zoomRect.size.width * 0.2
//        let insetHeight = -zoomRect.size.height * 0.2
//        let insetRect = MKMapRectInset(zoomRect, insetWidth, insetHeight)
//
//        self.mapView.setVisibleMapRect(insetRect, animated: true)
//
//    }

    

    // CLLLocationManager Delegate Method
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        self.lastLocation = location.coordinate
        
        // Create pin annotation for Driver
        if driverPin != nil {
            driverPin.coordinate = self.lastLocation
        } else {
            driverPin = MKPointAnnotation()
            driverPin.coordinate = self.lastLocation
            self.mapView.addAnnotation(driverPin)
        }
        
        // Reset zoom rect to cover 3 locations
        var zoomRect = MKMapRectNull
        for annotation in self.mapView.annotations {
            print("Annontation", annotation.coordinate)
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1)
            zoomRect = MKMapRectUnion(zoomRect, pointRect)
        }
        
        let insetWidth = -zoomRect.size.width * 0.2
        let insetHeight = -zoomRect.size.height * 0.2
        let insetRect = MKMapRectInset(zoomRect, insetWidth, insetHeight)
        
        self.mapView.setVisibleMapRect(insetRect, animated: true)

    }
    
}
