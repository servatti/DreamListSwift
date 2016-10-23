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
import NVActivityIndicatorView

class StoresViewController: UIViewController,
                            UITableViewDataSource,
                            UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    let kCellIdentifier = "StoreCell"
    let kPageSize = 1
    
    var currentPage = 0
    var stores = [StoreEntity]()
    var isFirstLoad = true
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        loadStores()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier)
        
        let store = stores[indexPath.row]
        
        cell?.textLabel?.text = store.name
        cell?.detailTextLabel?.text = "\(store.wishes) wish\(store.wishes != 1 ? "es" : "")"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = stores[indexPath.row]
        
        performSegue(withIdentifier: "Products", sender: store)
    }
    
    // MARK: - Internal
    
    func loadStores() {
        if isFirstLoad { Manager.sharedInstance.showLoadingSpinner(show: true) }
        
        let params = currentParams()
        Alamofire.request(Router.loadStores(params: params))
            .validate().responseArray { (response: DataResponse<[StoreEntity]>) in
                
                self.tableView.finishInfiniteScroll()
                
                if self.isFirstLoad { Manager.sharedInstance.showLoadingSpinner(show: false) }
                self.isFirstLoad = false
                
                switch response.result {
                case .success(let value):
                    self.stores.append(contentsOf: value)
                    self.tableView.reloadData()
                    
                    self.currentPage += self.kPageSize
                    break
                case .failure(let error):
                    Manager.sharedInstance.showAlert(message: error.localizedDescription)
                    break
                }
        }
    }
    
    func currentParams() -> Parameters {
        return ["_start": currentPage, "_end": currentPage + kPageSize]
    }
    
    func setupTableView() {
        tableView.infiniteScrollIndicatorStyle = .gray
        tableView.infiniteScrollTriggerOffset = 500
        tableView.tableFooterView = UIView()
        
        tableView.addInfiniteScroll { (tableView) in
            self.loadStores()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productsVC = segue.destination as? ProductsViewController {
            productsVC.store = sender as? StoreEntity
        }
    }
}
