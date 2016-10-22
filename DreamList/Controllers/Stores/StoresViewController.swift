//
//  StoresViewController.swift
//  DreamList
//
//  Created by Rafael Servatti on 10/22/16.
//  Copyright © 2016 Fera Solutions. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class StoresViewController: UIViewController,
                            UITableViewDataSource,
                            UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "StoreCell"
    
    var stores: [StoreEntity]?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStores()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        let store = stores![indexPath.row]
        
        cell?.textLabel?.text = store.name
        cell?.detailTextLabel?.text = "\(store.wishes) wishe\(store.wishes != 1 ? "s" : "")"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Products", sender: indexPath)
    }
    
    // MARK: - Internal
    func loadStores() {
        Alamofire.request(Router.loadStores())
            .validate().responseArray { (response: DataResponse<[StoreEntity]>) in
                
                switch response.result {
                case .success(let value):
                    self.stores = value
                    self.tableView.reloadData()
                    break
                case .failure(let error):
                    Manager.sharedInstance.showAlert(message: error.localizedDescription)
                    break
                }
        }
    }
}
