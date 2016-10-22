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

class ProductViewCell: UITableViewCell
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var wishesLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    var productId: NSInteger = 0
    
    // MARK: - expose
    
    func setupCell(productId: Int = 0, productName: String?, vendor: String?, wishes: Int = 0, imageURL: String?) {
        self.productId = productId
        nameLabel.text = productName
        vendorLabel.text = vendor
        wishesLabel.text = String(format: "%ld wishes", arguments: [wishes])
        if let imageURL = imageURL {
            productImageView.sd_setImage(with: URL(string: imageURL))
        }
    }
    
    // MARK: - actions
    @IBAction func wishesDidTap(sender: UIButton) {
        print("wishes ", productId)
    }
}
