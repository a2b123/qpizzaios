//
//  Helpers.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/29/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class Helpers {
    
    static func getLatestOrder() {
        
    }

    
    static func createSlidingMenu(controller: UINavigationController){
        let layout = UICollectionViewFlowLayout()
        let frontViewController = controller //create instance of frontVC
        
        let rearViewController = CustomerMenuController(collectionViewLayout: layout)//create instance of rearVC(menuVC)
        
        
        //create instance of swRevealVC based on front and rear VC
        let swRevealVC = SWRevealViewController(rearViewController: rearViewController, frontViewController: frontViewController)
        swRevealVC?.toggleAnimationType = SWRevealToggleAnimationType.easeOut
        swRevealVC?.toggleAnimationDuration = 0.30
        
        //set swRevealVC as rootVC of windows
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = swRevealVC
    }

    
    private let activityIndicator = UIActivityIndicatorView()

    static func showActivityIndicator(_ activityIndicator: UIActivityIndicatorView,_ view: UIView) {
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = UIColor.qpizzaBlack()
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    static func hideActivityIndicator(_ activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
    }


    
    
    
}
