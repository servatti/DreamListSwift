//
//  ProductViewCell.swift
//  DreamList
//
//  Created by Rafael Servatti on 10/22/16.
//  Copyright © 2016 Fera Solutions. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class ProductViewCell: UITableViewCell
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var wishesLabel: UILabel!
    @IBOutlet weak var wishButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var product: ProductEntity?
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Expose
    
    func setupCell(product: ProductEntity) {
        self.product = product
        nameLabel.text = product.name
        vendorLabel.text = product.vendor
        
        if let price = product.price {
            priceLabel.isHidden = false
            priceLabel.text = "$\(price)"
        } else {
            priceLabel.isHidden = true
        }
        
        if let imageURL = product.imageURL() {
            spinner.startAnimating()
            productImageView.sd_setImage(with: imageURL)
        } else {
            spinner.stopAnimating()
            productImageView.image = nil
        }
        
        updateWishes(wishes: product.wishes, isWished: product.isWished)
    }
    
    // MARK: - Actions
    
    @IBAction func wishesDidTap(sender: UIButton) {
        toogleWish()
    }
    
    @IBAction func imageDidTap(sender: UIButton) {
        openStoreURL()
    }
    
    // MARK: - Internal
    
    func toogleWish() {
        // Gives tap feedback
        let wishes = product!.wishes + (product!.isWished ? -1 : 1)
        updateWishes(wishes: wishes, isWished: !product!.isWished)
        
        let endpoint = (product!.isWished ? Router.deleteProductWish(productId: product!.id) : Router.saveProductWish(productId: product!.id))
        
        Manager.sharedInstance.showLoading(show: true)
        Alamofire.request(endpoint)
            .validate().responseData { response in
                Manager.sharedInstance.showLoading(show: false)
                
                switch response.result {
                case .success:
                    self.product!.wishes += 1
                    break
                    
                case .failure(let error):
                    self.updateWishes(wishes: self.product!.wishes, isWished: self.product!.isWished)
                    
                    Manager.sharedInstance.showAlert(message: error.localizedDescription)
                    break
                }
        }
    }
    
    func openStoreURL() {
        if let url = product!.url() {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func updateWishes(wishes: Int, isWished wished: Bool) {
        wishesLabel.text = "\(wishes) wish\(wishes != 1 ? "es" : "")"
        wishButton.isSelected = wished
    }
    
    func setup() {
        wishButton.setImage(wishButton.image(for: UIControlState.selected), for: [UIControlState.selected, UIControlState.highlighted])
    }
}
