//
//  DriverHeader.swift
//  QpizzaDelivery
//
//  Created by Amar Bhatia on 12/9/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

class DriverHeader: UICollectionReusableView {
    
    let profilePictureImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ice-cube").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username LastName"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.qpizzaWhite()
        label.textAlignment = .center
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.qpizzaWhite()
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.qpizzaRed()
        
        //        print("Username:", UserModel.currentUser.name)
        usernameLabel.text = UserModel.currentUser.name
        
        guard let profileImageUrl = UserModel.currentUser.profileImageUrl else { return }
        guard let profileURL = URL(string: profileImageUrl) else { return }
        profilePictureImageView.image = try! UIImage(data: Data(contentsOf: profileURL))
        
        addSubview(profilePictureImageView)
        addSubview(usernameLabel)
        addSubview(seperatorView)
        
        _ = profilePictureImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 50, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 60)
        //        profilePictureImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        _ = usernameLabel.anchor(profilePictureImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 25, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        //        usernameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        _ = seperatorView.anchor(usernameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 160, heightConstant: 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

