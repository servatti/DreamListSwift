//
//  AccountViewController.swift
//  DreamList
//
//  Created by Rafael Servatti on 10/23/16.
//  Copyright © 2016 Fera Solutions. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    // MARK: - Actions
    
    @IBAction func logOutDidTap(sender: UIButton) {
        logOut()
    }
    
    // MARK: - Internal
    
    func logOut() {
        Manager.sharedInstance.logOut()
    }
}
