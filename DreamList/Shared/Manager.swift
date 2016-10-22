//
//  Manager.swift
//  DreamList
//
//  Created by Rafael Servatti on 10/22/16.
//  Copyright © 2016 Fera Solutions. All rights reserved.
//

import UIKit

class Manager {

    static let sharedInstance = Manager()
    
    // MARK: - Expose
    func showAlert(title: String? = "Dream List", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okAction)
        
        let rootViewController = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
