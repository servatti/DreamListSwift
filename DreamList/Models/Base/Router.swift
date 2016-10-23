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
    case saveProductWish(productId: Int, params: Parameters)
    case deleteProductWish(productId: Int, params: Parameters)
    
    case loadStores(params: Parameters)
    case loadStoreProducts(storeId: Int, params: Parameters)
    
    case loadWishlist(params: Parameters)
    
    case login(params: Parameters)
    
//    static let baseURLString = "http://localhost:3000"
    static let baseURLString = "https://dream-list.herokuapp.com/api/v1"
    static let AuthorizationHeaderKey = "token"
    
    var method: HTTPMethod {
        switch self {
        case .loadProducts:
            return .get
        case .saveProductWish:
            return .post
        case .deleteProductWish:
            return .delete
            
        case .loadStores:
            return .get
        case .loadStoreProducts:
            return .get
            
        case .loadWishlist:
            return .get
            
        case .login:
            return .post
        }
    }
    
    var path: String {
        switch self {
        // Products
        case .loadProducts:
            return "/products"
        case .saveProductWish(let productId, _):
            return "/products/\(productId)/wishes"
        case .deleteProductWish(let productId, _):
            return "/products/\(productId)/wishes"
            
        // Stores
        case .loadStores:
            return "/shops"
        case .loadStoreProducts(let storeId, _):
            return "/shops/\(storeId)/products"
            
        // Wishlist
        case .loadWishlist:
            return "/wishlist"
            
        // Login
        case .login:
            return "/login"
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
        case .saveProductWish(_, let params):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        case .deleteProductWish(_, let params):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
            
        case .loadStores(let params):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        case .loadStoreProducts(_, let params):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
            
        case .loadWishlist(let params):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
            
        case .login(let params):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        }
        
        // Adds token to header
        if let currentToken = Manager.sharedInstance.currentToken() {
            urlRequest.addValue(currentToken, forHTTPHeaderField: Router.AuthorizationHeaderKey)
        }
        
        return urlRequest
    }
}
