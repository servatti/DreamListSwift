//
//  ProductsViewController.swift
//  DreamList
//
//  Created by Rafael Servatti on 10/22/16.
//  Copyright © 2016 Fera Solutions. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class ProductsViewController: UIViewController,
                              UITableViewDataSource,
                              UITableViewDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "ProductCell"
    
    var products: [ProductEntity]?
    var store: StoreEntity?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        loadProducts()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ProductViewCell
        let product = products![indexPath.row]
        
        cell.setupCell(productId: product.id, productName: product.name, vendor: product.vendor, wishes: product.wishes, imageURL: product.imageURL, price: product.price)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    // MARK: - Internal
    
    func loadProducts() {
        let endpoint = currentEndpoint()
        
        Alamofire.request(endpoint)
            .validate().responseArray { (response: DataResponse<[ProductEntity]>) in
                
                switch response.result {
                case .success(let value):
                    self.products = value
                    self.tableView.reloadData()
                    break
                case .failure(let error):
                    Manager.sharedInstance.showAlert(message: error.localizedDescription)
                    break
                }
            }
    }
    
    func currentEndpoint() -> Router {
        return (store == nil ? Router.loadProducts() : Router.loadStoreProducts(storeId: store!.id))
    }
    
    func setup() {
        tableView.register(UINib(nibName: "ProductViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        if let store = store {
            navigationItem.title = store.name
        }
    }
}
