//
//  LoginController.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/7/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginController: UIViewController {
    
    var userType: String = USERTYPE_CUSTOMER
    
    let qpizzaLabel: UILabel = {
        let label = UILabel()
        label.text = "Qpizza"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    
    let sloganLabel: UILabel = {
        let label = UILabel()
        label.text = "Quality. Quickly."
        label.textColor = UIColor.qpizzaWhite()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login With Facebook", for: .normal)
        button.setTitleColor(UIColor.qpizzaRed(), for: .normal)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.qpizzaWhite()
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let switchAccounts: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Switch Accounts", for: .normal)
        button.setTitleColor(UIColor.qpizzaWhite(), for: .normal)
        button.addTarget(self, action: #selector(switchAccountsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let segmentedControl: UISegmentedControl = {
        let arrayCustomerDriver = ["Customer", "Driver"]
        let segmentedControl = UISegmentedControl(items: arrayCustomerDriver)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.qpizzaWhite()
        segmentedControl.tintColor = UIColor.qpizzaGold()
        segmentedControl.addTarget(self, action: #selector(changeSegment), for: .valueChanged)
        return segmentedControl
    }()
    
    let logo: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "pizza-white-64")
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.qpizzaRed()
        
        view.addSubview(qpizzaLabel)
        view.addSubview(sloganLabel)
        view.addSubview(loginButton)
        view.addSubview(switchAccounts)
        view.addSubview(segmentedControl)
        view.addSubview(logo)
        
        _ = qpizzaLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 95, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 100)
        
        _ = sloganLabel.anchor(qpizzaLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 14, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 20)
        
        _ = logo.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 80)
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        _ = switchAccounts.anchor(loginButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 50)
        switchAccounts.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        _ = loginButton.anchor(nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 50)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        _ = segmentedControl.anchor(nil, left: view.leftAnchor, bottom: loginButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 30, rightConstant: 10, widthConstant: 0, heightConstant: 30)
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        print("FBSDK Access Token @ Login:", FBSDKAccessToken.current())

        if (FBSDKAccessToken.current() != nil) {
            switchAccounts.isHidden = false
            FBManager.getFBUserData(completionHandler: {
                self.loginButton.setTitle("Continue as \(UserModel.currentUser.email ?? "")", for: .normal)
            })
        } else {
            self.switchAccounts.isHidden = true
        }
    }
    
    
    
    func createSlidingMenu(){
        let layout = UICollectionViewFlowLayout()
        let frontViewController = UINavigationController(rootViewController: RestaurantController(collectionViewLayout: layout))//create instance of frontVC
        
        let rearViewController = CustomerMenuController(collectionViewLayout: layout)//create instance of rearVC(menuVC)
        
        
        //create instance of swRevealVC based on front and rear VC
        let swRevealVC = SWRevealViewController(rearViewController: rearViewController, frontViewController: frontViewController)
        swRevealVC?.toggleAnimationType = SWRevealToggleAnimationType.easeOut
        swRevealVC?.toggleAnimationDuration = 0.30
        
        //set swRevealVC as rootVC of windows
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = swRevealVC
    }
    
    var fbLoginSuccess = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (FBSDKAccessToken.current() != nil && fbLoginSuccess == true) {
            DispatchQueue.main.async {
                
                self.createSlidingMenu()

                let layout = UICollectionViewFlowLayout()
                let restaurantController = RestaurantController(collectionViewLayout: layout)
                let navRestaurantController = UINavigationController(rootViewController: restaurantController)
                
                // Using this wont present the reveal..
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.window!.rootViewController = navRestaurantController
                
                // Using this will cause a view hiearchary error:
                self.present(navRestaurantController, animated: true, completion: nil)
            }
            return
            
        }
    }

	
    @objc func loginButtonPressed() {
        print("Login Button Pressed")
        
        if (FBSDKAccessToken.current() != nil) {
            
            APIManager.shared.login(userType: userType, completionHandler: { (error) in
                if let error = error {
                    print("Error Logging In With UserType / API...:", error)
                }

                print("FBSDK Access Token UserId:", FBSDKAccessToken.current().userID)
                self.fbLoginSuccess = true
                self.viewDidAppear(true)
            })

        } else {
            let readPermissions = ["public_profile", "email"]
            FBManager.shared.logIn(withReadPermissions: readPermissions, from: self, handler: { (result, error) in
                
                if let error = error {
                    print("Error Logging In With Permissiosn..:", error)
                } else if error == nil {
                    
                    FBManager.getFBUserData(completionHandler: {
                        APIManager.shared.login(userType: self.userType, completionHandler: { (error) in
                            if let error = error {
                                print("Error Logging In With UserType / API..:", error)
                            }
                            
                            print("FBSDK Access Token UserId:", FBSDKAccessToken.current().userID)
                            self.fbLoginSuccess = true
                            self.viewDidAppear(true)
                        })
                    })
                    
                }
            })
        }
        
    }
    
    @objc func switchAccountsButtonPressed() {
        print("Switched Accounts Button Pressed")
        
        APIManager.shared.logout { (error) in
            if let error = error {
                print("Error logging out:", error)
            }
            
            FBManager.shared.logOut()
            UserModel.currentUser.resetInfo()
            self.switchAccounts.isHidden = true
            self.loginButton.setTitle("Login with Facebook", for: .normal)
        }
    }
    
    @objc func changeSegment(sender: UISegmentedControl) {
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
        
        switch sender.selectedSegmentIndex {
        case 0:
            print("0")
        case 1:
            print("1")
        default: break
        }
    }
    
    
}

