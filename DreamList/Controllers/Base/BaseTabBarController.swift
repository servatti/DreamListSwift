//
//  BaseTabBarController.swift
//  DreamList
//
//  Created by Rafael Servatti on 10/23/16.
//  Copyright © 2016 Fera Solutions. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Internal
    func setup() {
        UITabBar.appearance().tintColor = UIColor(red: 0, green: 191/255.0, blue: 136/255.0, alpha: 1)
    }

}
