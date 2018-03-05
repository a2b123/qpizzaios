//
//  MenuDetailsController.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/9/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

class MenuDetailsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SWRevealViewControllerDelegate, MenuDelegate {
    
    
    var menuModel: MenuItemsModel?
    var restaurant: RestaurantModel?
    
    private let menuDetailsCellId = "menuDetailsCellId"
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.qpizzaRed()
        collectionView?.register(MenuDetailsCell.self, forCellWithReuseIdentifier: menuDetailsCellId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "button_tray").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(rightBarButtonPressed))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuDetailsCellId, for: indexPath) as! MenuDetailsCell
        cell.menuModel = menuModel
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let navHeight = self.navigationController?.navigationBar.intrinsicContentSize.height
        // FIXME: This needs to change...why does view.frame.height not work?
        return CGSize(width: view.frame.width, height: view.frame.height - (navHeight! * 1.7))
//        return CGSize(width: view.frame.width, height: view.frame.height - 74)
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)

    }
    
    func createSlidingMenu(){
        let layout = UICollectionViewFlowLayout()
        let frontViewController = UINavigationController(rootViewController: OrderController(collectionViewLayout: layout))//create instance of frontVC
        
        let rearViewController = CustomerMenuController(collectionViewLayout: layout)//create instance of rearVC(menuVC)
        
        
        //create instance of swRevealVC based on front and rear VC
        let swRevealVC = SWRevealViewController(rearViewController: rearViewController, frontViewController: frontViewController)
        swRevealVC?.toggleAnimationType = SWRevealToggleAnimationType.easeOut
        swRevealVC?.toggleAnimationDuration = 0.30
        
        //set swRevealVC as rootVC of windows
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = swRevealVC
    }

    
    @objc func rightBarButtonPressed() {
        print("Right Bar Button Pressed")
        self.createSlidingMenu()
    }
    
    func handleOrder(cell: MenuDetailsCell, quantity: Int) {
        guard let menu = self.menuModel else { return }
        let orderItem = OrderModel(menuItem: menu, quantity: quantity)
        print("Orddderrr", Order.currentOrder.restaurant)
        print("Restaurantttt", self.restaurant)

        guard let order = Order.currentOrder.restaurant, let currentRestaurant = self.restaurant else {
            // If the requirements are not met...
            print("Orddderrr", Order.currentOrder.restaurant)
            print("Restaurantttt", self.restaurant)
            Order.currentOrder.restaurant = self.restaurant
            Order.currentOrder.items.append(orderItem)
            return
        }
        
        
        // If ordering meal from the same restaurant
        print("Order Id:", order)
        print("Current Restaurant Id:", currentRestaurant)
        if order.id == currentRestaurant.id {
            let inOrder = Order.currentOrder.items.index(where: { (item) -> Bool in
                return item.menuItem?.id == orderItem.menuItem?.id
            })
            
            if let index = inOrder {
                let alertView = UIAlertController(title: "Add More?", message: "Your order already has this meal. Do you want to add more?", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Add more", style: .default, handler: { (action: UIAlertAction) in
                    Order.currentOrder.items[index].quantity += quantity
                })
                
                alertView.addAction(okAction)
                alertView.addAction(cancelAction)
                
                present(alertView, animated: true, completion: nil)

            } else {
                Order.currentOrder.items.append(orderItem)
            }
        } else { // If ordering meal from another restaurant
            let alertView = UIAlertController(title: "Start New Order?", message: "You're ordering an item from another restaurant. Would you like to clear the current order?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "New Order", style: .default, handler: { (action: UIAlertAction) in
                Order.currentOrder.items = []
                Order.currentOrder.items.append(orderItem)
            })
            
            alertView.addAction(okAction)
            alertView.addAction(cancelAction)
            
            present(alertView, animated: true, completion: nil)
        }

    }
    
    func showSameMealAlert() {
    }
    
    func showDifferentRestaurantAlert() {
    }

    
    
}
