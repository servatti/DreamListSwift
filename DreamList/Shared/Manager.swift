//
//  Manager.swift
//  DreamList
//
//  Created by Rafael Servatti on 10/22/16.
//  Copyright © 2016 Fera Solutions. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView

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
    
    func userDefaults(key: String) -> Any {
        return UserDefaults.standard.value(forKey: key)
    }
    
    func setUserDefaultsValue(key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func showLoading(show: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
    }
    
    func showLoadingSpinner(show: Bool) {
        showLoading(show: show)
        
        let tag = 500
        let window = (UIApplication.shared.delegate as! AppDelegate).window!
        
        if let container = window.viewWithTag(tag) {
            if (!show) {
                container.removeFromSuperview()
            }
        } else {
            if show {
                let size = CGFloat(60)
                let frame = CGRect(x: (UIScreen.main.bounds.width - size) / 2, y: (UIScreen.main.bounds.height - size) / 2, width: size, height: size)
                let spinner = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.ballScaleMultiple, color: UIColor(red: 0, green: 191/255.0, blue: 136/255.0, alpha: 1), padding: 0)
                spinner.startAnimating()
                
                let container = UIView(frame: UIScreen.main.bounds)
                container.backgroundColor = UIColor(white: 0, alpha: 0.1)
                container.addSubview(spinner)
                container.tag = tag
                
                window.addSubview(container)
            }
        }
    }
    
}
