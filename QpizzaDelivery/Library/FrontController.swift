//
//  frontViewController.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/8/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

class FrontController: SWRevealViewController {
    
    
    let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Menu", for: .normal)
//        button.addTarget(self.revealViewController(), action: #selector(revealToggle(_:)), for: .touchUpInside)
        button.backgroundColor = .white
        button.titleLabel?.textColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu2-black-32").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))

        
    }
    
}

