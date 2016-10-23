//
//  Router.swift
//  DreamList
//
//  Created by Rafael Servatti on 10/22/16.
//  Copyright © 2016 Fera Solutions. All rights reserved.
//

import UIKit
import Alamofire

enum Router: URLRequestConvertible {
    case loadProducts(params: Parameters)
    case saveProductWish(productId: Int)
    case deleteProductWish(productId: Int)
    
    case loadStores(params: Parameters)
    case loadStoreProducts(storeId: Int, params: Parameters)
    
    case loadWishlist(params: Parameters)
    
    static let baseURLString = "http://localhost:3000"
    
    var method: HTTPMethod {
        switch self {
        case .loadProducts:
            return .get
        case .saveProductWish:
            return .put
        case .deleteProductWish:
            return .delete
            
        case .loadStores:
            return .get
        case .loadStoreProducts:
            return .get
            
        case .loadWishlist:
            return .get
        }
    }
    
    var path: String {
        switch self {
        // Products
        case .loadProducts:
            return "/products"
        case .saveProductWish(let productId):
            return "/products/\(productId)/wish"
        case .deleteProductWish(let productId):
            return "/products/\(productId)/wish"
            
        // Stores
        case .loadStores:
            return "/stores"
        case .loadStoreProducts(let storeId):
            return "/stores/\(storeId)/products"
            
        // Wishlist
        case .loadWishlist:
            return "/wishlist"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .loadProducts(let params):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        case .saveProductWish:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .deleteProductWish:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        case .loadStores(let params):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        case .loadStoreProducts(_, let params):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
            
        case .loadWishlist(let params):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        }
        
//        urlRequest.addValue(<#T##value: String##String#>, forHTTPHeaderField: <#T##String#>)
        
        return urlRequest
    }
}
