//
//  DeliveryCell.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/22/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit
import MapKit

class DeliveryCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let deliveryCollectionViewCellId = "deliveryCollectionViewCellId"
    let screenSize = UIScreen.main.bounds
    
    let mapView: MKMapView = {
        let mV = MKMapView()
        mV.clipsToBounds = true
        mV.backgroundColor = .blue
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
        
        addSubview(mapView)
        addSubview(collectionView)
        addSubview(statusLabel)
        
        backgroundColor = .green
        collectionView.backgroundColor = .red
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DeliveryCollectionViewCell.self, forCellWithReuseIdentifier: deliveryCollectionViewCellId)
        
        _ = mapView.anchor(topAnchor, left: leftAnchor, bottom: collectionView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
        _ = statusLabel.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        _ = collectionView.anchor(mapView.bottomAnchor, left: leftAnchor, bottom: statusLabel.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deliveryCollectionViewCellId, for: indexPath) as! DeliveryCollectionViewCell
        return cell
    }
    
    
}
