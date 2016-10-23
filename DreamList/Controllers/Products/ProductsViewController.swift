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
                              UITableViewDelegate,
                              ProductViewCellDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    
    let kCellIdentifier = "ProductCell"
    let kPageSize = 5
    
    var currentPage = 0
    var products = [ProductEntity]()
    var store: StoreEntity?
    var isFirstLoad = true
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
     
        return refreshControl
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupTableView()
        
        loadProducts(showSpinner: isFirstLoad)
        isFirstLoad = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Manager.sharedInstance.reloadProducts {
            Manager.sharedInstance.reloadProducts = false
            loadProducts(showSpinner: true)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) as! ProductViewCell
        cell.delegate = self
        cell.tag = indexPath.row
        
        let product = products[indexPath.row]
        
        cell.setupCell(product: product)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    // MARK: - Internal
    
    func loadProducts(showSpinner: Bool = false) {
        if showSpinner {
            Manager.sharedInstance.showLoadingSpinner(show: true)
        }
        
        let endpoint = currentEndpoint()
        
        Alamofire.request(endpoint)
            .validate().responseArray { (response: DataResponse<[ProductEntity]>) in
                
                self.tableView.finishInfiniteScroll()
                
                // Loading checks
                 Manager.sharedInstance.showLoadingSpinner(show: false)
                if (self.refreshControl.isRefreshing) { self.refreshControl.endRefreshing() }
                
                switch response.result {
                case .success(let value):
                    // TODO: Implement pagination on api
                    // self.products.append(contentsOf: value)
                    // self.currentPage += self.kPageSize
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
        let params = currentParams()
        return (store == nil ? Router.loadProducts(params: params) : Router.loadStoreProducts(storeId: store!.id, params: params))
    }
    
    func currentParams() -> Parameters {
        return ["_start": currentPage, "_end": currentPage + kPageSize]
    }
    
    func setupTableView() {
        tableView.infiniteScrollIndicatorStyle = .gray
        tableView.infiniteScrollTriggerOffset = 1000
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        
//        tableView.addInfiniteScroll { (tableView) in
//            self.loadProducts()
//        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        loadProducts()
    }
    
    func setup() {
        tableView.register(UINib(nibName: "ProductViewCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        
        if let store = store {
            navigationItem.title = store.name
        }
    }
}
