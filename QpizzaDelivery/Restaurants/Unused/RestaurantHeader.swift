//
//  RestaurantHeader.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/9/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

class RestaurantHeader: UICollectionReusableView, UISearchBarDelegate {
    
    
    private let restaurantHeaderId = "restaurantHeaderId"
    
    let restaurantCollectionViewController = RestaurantController()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search Restaurant"
        sb.barTintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.qpizzaWhite()
        sb.delegate = self
        return sb
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        

        backgroundColor = UIColor.qpizzaWhite()
        
        addSubview(searchBar)
        _ = searchBar.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 50)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
//
//        if searchText.isEmpty {
////            restaurantCollectionViewController.filteredRestaurants = restaurantCollectionViewController.restaurants
//        } else {
////            self.restaurantCollectionViewController.restaurants.filter { (restaurant: RestaurantModel) -> Bool in
////                return restaurant.name?.lowercased().range(of: searchText.lowercased()) != nil
//            }
//
//    }
}

    

