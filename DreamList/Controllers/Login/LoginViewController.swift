//
//  LoginViewController.swift
//  DreamList
//
//  Created by Rafael Servatti on 10/22/16.
//  Copyright © 2016 Fera Solutions. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class LoginViewController: UIViewController {

    // MARK: - Actions
    
    @IBAction func loginDidTap(sender: UIButton) {
        login()
    }
    
    // MARK: - Internal
    // TODO: Refactor: Create LoginModel and put all login methods there
    
    func login() {
        let loginManager = LoginManager()
        
        loginManager.logIn([ReadPermission.publicProfile, ReadPermission.email, ReadPermission.userFriends], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                Manager.sharedInstance.showAlert(message: error.localizedDescription)
            case .cancelled:
                print("User cancelled login.")
//            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            case .success(_, _, let accessToken):
                print("Logged in! \(accessToken.authenticationToken)")
                self.facebookFieldsAndLogin()
            }
        }
    }
    
    func facebookFieldsAndLogin() {
        Manager.sharedInstance.showLoadingSpinner(show: true)
        
        let connection = GraphRequestConnection()
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod.GET, apiVersion: GraphAPIVersion.defaultVersion)
        connection.add(request, batchEntryName: "") { (response, result) in
            print(result)
            
            switch (result) {
            case .success(let response):
                print(response.dictionaryValue?["email"])
                
                self.doLogin(email: response.dictionaryValue!["email"] as! String, token: AccessToken.current!.authenticationToken)
                
                break
            case .failed(let error):
                Manager.sharedInstance.showLoadingSpinner(show: false)
                Manager.sharedInstance.showAlert(message: error.localizedDescription)
                break
            }
            
        }
        connection.start()
    }

    func doLogin(email: String, token: String) {
        let params = ["email": email, "token": AccessToken.current!.authenticationToken]
        
        Alamofire.request(Router.login(params: params))
            .validate().responseData { response in
                
                Manager.sharedInstance.showLoadingSpinner(show: false)
                
                switch response.result {
                case .success(_):
                    Manager.sharedInstance.setCurrentToken(token: AccessToken.current!.authenticationToken)
                    Manager.sharedInstance.setRootViewController()
                    
                    break
                case .failure(let error):
                    Manager.sharedInstance.showAlert(message: error.localizedDescription)
                    break
                }
        }

    }
    
}
