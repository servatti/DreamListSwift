//
//  MyWishesViewController.swift
//  DreamList
//
//  Created by Rafael Servatti on 10/22/16.
//  Copyright © 2016 Fera Solutions. All rights reserved.
//

import UIKit

class MyWishesViewController: ProductsViewController {
    
    // MARK: - Override
    
    override func currentEndpoint() -> Router {
        let params = currentParams()
        
        return Router.loadWishlist(params: params)
    }
    
    // MARK: - ProductViewCellDelegate
    
    func productViewCellDidDeleteWish(index: Int) {
        products.remove(at: index)
        
        let indexPath = IndexPath(row: index, section: 0)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        tableView.endUpdates()
    }
    
}
