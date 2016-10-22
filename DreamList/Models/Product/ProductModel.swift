//
//  ProductModel.swift
//  DreamList
//
//  Created by Rafael Servatti on 10/22/16.
//  Copyright © 2016 Fera Solutions. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class ProductModel: NSObject {

    // MARK: - Expose
    func loadProducts() {
//        Alamofire.request(Router.loadProducts()).validate().responseObject { (response: DataResponse<ProductEntity>) in
//            print(response);
//        }
        Alamofire.request(Router.loadProducts())
            .validate()
            .responseArray { (response: DataResponse<[ProductEntity]>) in
            print(response);
        }
    }
    
}
