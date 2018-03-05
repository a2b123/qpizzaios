//
//  DeliveryCell.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/22/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class DeliveryCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MKMapViewDelegate {
    
    private let deliveryCollectionViewCellId = "deliveryCollectionViewCellId"
    let screenSize = UIScreen.main.bounds
    
    var customerAddress: MKPlacemark?
    var restaurantLocation: MKPlacemark?
    
    var driverPin: MKPointAnnotation!
    var timer = Timer()
    
    var order = [JSON]()
    
    let mapView: MKMapView = {
        let mV = MKMapView()
        mV.clipsToBounds = true
        mV.backgroundColor = .blue
//        mV.delegate = self
        return mV
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "On The Way"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.qpizzaWhite()
        label.textAlignment = .center
        label.backgroundColor = UIColor.qpizzaRed()
        return label
    }()

    
    override func setupViews() {
        super.setupViews()
        
        getLatestOrder()
        
        addSubview(mapView)
        addSubview(collectionView)
        addSubview(statusLabel)
        
        mapView.delegate = self
        
        backgroundColor = .green
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DeliveryCollectionViewCell.self, forCellWithReuseIdentifier: deliveryCollectionViewCellId)
        
        _ = mapView.anchor(topAnchor, left: leftAnchor, bottom: collectionView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
        _ = statusLabel.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        _ = collectionView.anchor(mapView.bottomAnchor, left: leftAnchor, bottom: statusLabel.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: UIScreen.main.bounds.height / 3)

    }
    
    
    func getLatestOrder() {
        APIManager.shared.getLatestOrder { (json) in
            print(json)
            
            let order = json["order"]
            
            if order["status"] != .null {
                if let orderDetails = json["order"]["order_details"].array {
                    self.order = orderDetails
                    self.statusLabel.text = order["status"].string?.uppercased()
                    self.collectionView.reloadData()
                }
                
                let from = order["restaurant"]["address"].string!
                let to = order["address"].string!
                
                print("Check To: \(to) and From: \(from)")
                self.getLocation(from, "Restaurant", { (placemark) in
                    self.restaurantLocation = placemark
                    
                    self.getLocation(to, "Customer", { (placemark) in
                        self.customerAddress = placemark
                        self.getDirectionsAndZoom()
                    })
                })
                
                if order["status"] != "Delivered" {
                    self.setTimer()
                }
            }
        }
    }
    
    @objc func getDriverLocation(_ sender: AnyObject) {
        APIManager.shared.getDriverLocation { (json) in
            print("JSON for Location:", json)
            
            if let location = json["location"].string {
                print("Locatio Location Location")
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return order.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deliveryCollectionViewCellId, for: indexPath) as! DeliveryCollectionViewCell
        let item = order[indexPath.item]
        
        
        cell.quantityLabel.text = String(describing: item["quantity"].int!)
        cell.mealNameLabel.text = item["meal"]["name"].string
        cell.subTotalLabel.text = "$\(String(describing: item["sub_total"].float!))"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 100)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getDriverLocation(_:)), userInfo: nil, repeats: true)
    }
    
    func getLocation(_ address: String, _ title: String,_ completionHandler: @escaping (MKPlacemark) -> Void) {
            let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Error with geocoding address string in DeliveryCell:", error)
            }
            
            if let placemark = placemarks?.first {
                if let location = placemark.location?.coordinate {
                    let coordiantes:  CLLocationCoordinate2D = location
                    
                    // Create Pin
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = coordiantes
                    dropPin.title = title
                    self.mapView.addAnnotation(dropPin)
                    completionHandler(MKPlacemark.init(placemark: placemark))
                }
            }
        }
    }
    
    func getDirectionsAndZoom() {
        let request = MKDirectionsRequest()
        request.source = MKMapItem.init(placemark: restaurantLocation!)
        request.destination = MKMapItem.init(placemark: customerAddress!)
        request.requestsAlternateRoutes = false
        
        let direction = MKDirections(request: request)
        direction.calculate { (response, error) in
            
            if error != nil {
                print("Error getting directions and zooming inside of DeliveryCell:", error)
            } else {
                // show route
                self.showRoute(response: response!)
            }
        }
    }
    
    func showRoute(response: MKDirectionsResponse) {
        for route in response.routes {
            self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
        
//        var zoomRect = MKMapRectNull
//        for annotation in self.mapView.annotations {
//            let annontationPoint = MKMapPointForCoordinate(annotation.coordinate)
//            let pointRect = MKMapRectMake(annontationPoint.x, annontationPoint.y, 0.1, 0.1)
//            zoomRect = MKMapRectUnion(zoomRect, pointRect)c
//        }
//        
//        let insetWidth = -zoomRect.size.width * 0.2
//        let insetHeight = -zoomRect.size.height * 0.2
//        let insetRect = MKMapRectInset(zoomRect, insetWidth, insetHeight)
//        self.mapView.setVisibleMapRect(insetRect, animated: true)
    }
    
    // #5 - Customize pin point image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annontationIdentifier = "MyPin"
        var annonatationView: MKAnnotationView?
        if let dequeueAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annontationIdentifier) {
            
            annonatationView = dequeueAnnotationView
            annonatationView?.annotation = annotation
            
        } else {
            
            annonatationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annontationIdentifier)
            
        }
        
        if let annontationView = annonatationView, let name = annotation.title! {
            switch name {
            case "DRI":
                annonatationView?.canShowCallout = true
                annonatationView?.image = UIImage(named: "pin_car")
            case "RES":
                annonatationView?.canShowCallout = true
                annonatationView?.image = UIImage(named: "pin_restaurant")
            case "CUS":
                annonatationView?.canShowCallout = true
                annonatationView?.image = UIImage(named: "pin_customer")
            default:
                annonatationView?.canShowCallout = true
                annonatationView?.image = UIImage(named: "pin_car")

            }
        }
        
        return annonatationView
    }
}
