//
//  StoreEntity.swift
//  DreamList
//
//  Created by Rafael Servatti on 10/22/16.
//  Copyright © 2016 Fera Solutions. All rights reserved.
//

import ObjectMapper

class StoreEntity: NSObject, Mappable {
    var id: Int = 0
    var name: String?
    var url: String?
    var wishes: Int = 0
    
    // MARK: - Override
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        url <- map["url"]
        wishes <- map["wishes"]
    }
}
