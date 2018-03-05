//
//  RestaurantCell.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/8/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

protocol RestaurantDelegate {
    func didTapRestaurantCell(cell: RestaurantCell, withMenuController: MenuController)
}


class RestaurantCell: BaseCell, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: RestaurantDelegate?
    var restaurants = [RestaurantModel]()
    var filteredRestaurants = [RestaurantModel]()
    
    private let restaurantCollectionViewCell = "restaurantCollectionViewCell"
    private let activityIndicator = UIActivityIndicatorView()
        
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search Restaurant"
        sb.barTintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.qpizzaWhite()
        sb.delegate = self
        return sb
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()
        collectionView.register(RestaurantCollectionViewCell.self, forCellWithReuseIdentifier: restaurantCollectionViewCell)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        backgroundColor = UIColor.qpizzaRed()
        
        addSubview(searchBar)
        addSubview(collectionView)
        
        _ = searchBar.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 50)

        _ = collectionView.anchor(searchBar.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
         loadRestaurants()

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        filteredRestaurants = self.restaurants.filter({ (restaruant: RestaurantModel) -> Bool in
            
            return restaruant.name?.lowercased().range(of: searchText.lowercased()) != nil
        })
        
        self.collectionView.reloadData()
    }
    
    // MARK - Helper Methods
    func loadRestaurants() {
        
        Helpers.showActivityIndicator(activityIndicator, self)
        
        APIManager.shared.getRestaurants { (json) in
            if json != .null {
                //                print("Restaurant JSON:", json)
                self.restaurants = []
                
                if let restaurantList = json["restaurants"].array {
                    for item in restaurantList {
                        let restaurant = RestaurantModel(json: item)
                        self.restaurants.append(restaurant)
                    }
                    self.collectionView.reloadData()
                    Helpers.hideActivityIndicator(self.activityIndicator)
                }
            } else {
                print("Error loading JSON into Restaurant ViewController")
            }
        }
    }
    
    
    //MARK: CollectionView Delegate & DataSource Methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: restaurantCollectionViewCell, for: indexPath) as! RestaurantCollectionViewCell
        
        if searchBar.text != "" {
            cell.restauarnt = filteredRestaurants[indexPath.item]
        } else {
            cell.restauarnt = restaurants[indexPath.item]
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchBar.text != "" {
            return self.filteredRestaurants.count
        }
        
        return self.restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Did Select Item - Restaurant Cell")
        
        let layout = UICollectionViewFlowLayout()
        let controller = MenuController(collectionViewLayout: layout)
        controller.restaurant = self.restaurants[indexPath.item]
        delegate?.didTapRestaurantCell(cell: self, withMenuController: controller)
    }

    func collectionView(_ zcollectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
}
