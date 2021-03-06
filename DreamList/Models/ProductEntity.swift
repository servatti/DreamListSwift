//
//  ProductEntity.swift
//  DreamList
//
//  Created by Rafael Servatti on 10/22/16.
//  Copyright © 2016 Fera Solutions. All rights reserved.
//

import ObjectMapper

class ProductEntity: NSObject, Mappable {
    var id: Int = 0
    var name: String?
    var vendor: String?
    var price: String?
    var urlPath: String?
    var wishes: Int = 0
    var imageURLPath: String?
    var isWished: Bool = false
    var shopId: Int = 0
    
    // MARK: - Override
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["title"]
        vendor <- map["vendor"]
        price <- map["variants.0.price"]
        urlPath <- map["link"]
        wishes <- map["wishes"]
        imageURLPath <- map["image.src"]
        isWished <- map["is_wished"]
        shopId <- map["shop_id"]
    }
    
    // MARK: - Expose
    
    func imageURL() -> URL? {
        if let path = imageURLPath {
            if let url = URL(string: path) {
                return url
            }
        }
        
        return nil
    }
    
    func url() -> URL? {
        if let path = urlPath {
            if let url = URL(string: path) {
                return url
            }
        }
        
        return nil
    }
}
