//
//  DriverMenuController.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/7/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

class DriverMenuController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SWRevealViewControllerDelegate {
    
    
    var menuOptions = [SidebarOptions]()
    
    private let driverMenuCellId = "driverMenuCellId"
    private let driverHeaderId = "driverHeaderId"
    
    let layout = UICollectionViewFlowLayout()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuOptions = setupMenuOptions()
        
        collectionView?.backgroundColor = UIColor.qpizzaRed()
        collectionView?.delegate = self
        collectionView?.register(DriverMenuCell.self, forCellWithReuseIdentifier: driverMenuCellId)
        collectionView?.register(DriverHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: driverHeaderId)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu2-black-32").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        
    }
    
    func setupMenuOptions() -> [SidebarOptions] {
        let restaurantOption = SidebarOptions()
        restaurantOption.name = "Orders"
        restaurantOption.image = #imageLiteral(resourceName: "dinner-black-32").withRenderingMode(.alwaysOriginal)
        
        let trayOption = SidebarOptions()
        trayOption.name = "Delivery"
        trayOption.image = #imageLiteral(resourceName: "menu-dinner-black-32").withRenderingMode(.alwaysOriginal)
        
        let orderOption = SidebarOptions()
        orderOption.name = "Statistics"
        orderOption.image = #imageLiteral(resourceName: "shopping-cart-black-32").withRenderingMode(.alwaysOriginal)
        
        let logoutOption = SidebarOptions()
        logoutOption.name = "Logout"
        logoutOption.image = #imageLiteral(resourceName: "logout-black-32").withRenderingMode(.alwaysOriginal)
        
        menuOptions.append(restaurantOption)
        menuOptions.append(trayOption)
        menuOptions.append(orderOption)
        menuOptions.append(logoutOption)
        
        return [restaurantOption, trayOption, orderOption, logoutOption]
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: driverHeaderId, for: indexPath) as! DriverHeader
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: driverMenuCellId, for: indexPath) as! DriverMenuCell
        
        if let name = menuOptions[indexPath.item].name {
            cell.optionLabel.text = name
            if let image = menuOptions[indexPath.item].image {
                cell.optionImage.image = image
            }
        }
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width, height: 70)
        return size
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row, indexPath.item)
        
        if indexPath.item == 0 {
            
            let restaurantControlller = UINavigationController(rootViewController: DriverOrderController(collectionViewLayout: layout))
            revealViewController().pushFrontViewController(restaurantControlller, animated: true)
            
            print("Showing Driver Order Controller")
            
        } else if indexPath.item == 1 {
            
            let driverDeliveryControlller = UINavigationController(rootViewController: DriverDeliveryController(collectionViewLayout: layout))
            
            
//            let driverDeliveryControlller = UINavigationController(rootViewController: DriverDelivController())

            revealViewController().pushFrontViewController(driverDeliveryControlller, animated: true)
            
            print("Showing Driver Delivery Status Controller")

            
        } else if indexPath.item == 2 {
            
            let driverStatisticsController = UINavigationController(rootViewController: DriverStatisticsController(collectionViewLayout: layout))
            revealViewController().pushFrontViewController(driverStatisticsController, animated: true)

            print("Showing Driver Statistics Controller")

            
        } else if indexPath.item == 3 {
            print("Logging Out..")
            APIManager.shared.logout(completionHandler: { (error) in
                
                if let error = error {
                    print("Error logging out:", error.localizedDescription)
                }
                
                FBManager.shared.logOut()
                UserModel.currentUser.resetInfo()
                
                let loginController = LoginController()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController = loginController
                
            })
            
        }
        
    }
    
    
    
}



