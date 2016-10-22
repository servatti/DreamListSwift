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
    case loadProducts()
    case loadStores()
//    case loadUser()
    
//    case createUser(parameters: Parameters)
//    case readUser(username: String)
//    case updateUser(username: String, parameters: Parameters)
//    case destroyUser(username: String)
    
    static let baseURLString = "https://jsonplaceholder.typicode.com"
    
    var method: HTTPMethod {
        switch self {
        case .loadProducts:
            return .get
        case .loadStores:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .loadProducts:
            return "/posts"
        case .loadStores:
            return "/posts"
            
//        case .createUser:
//            return "/users"
//        case .readUser(let username):
//            return "/users/\(username)"
//        case .updateUser(let username, _):
//            return "/users/\(username)"
//        case .destroyUser(let username):
//            return "/users/\(username)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .loadProducts:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .loadStores:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
//        case .createUser(let parameters):
//            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
//        case .updateUser(_, let parameters):
//            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
//        urlRequest.addValue(<#T##value: String##String#>, forHTTPHeaderField: <#T##String#>)
        
        return urlRequest
    }
}
