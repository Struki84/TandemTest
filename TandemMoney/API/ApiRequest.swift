//
//  APIRequest.swift
//  TandemMoney
//
//  Created by Šimun Strukan on 14/03/2018.
//  Copyright © 2018 Sintezis. All rights reserved.
//

import Foundation

class ApiRequest {
    
    var urlPath: String!
    var url: URL!
    var urlRequest: URLRequest!
    
    enum Router {
        case forecast(String)
        case image(String)
        
        var rootUrl: String {
            switch self {
            case .forecast:
                return "http://api.openweathermap.org/data/2.5"
            case .image:
                return "http://openweathermap.org/img/w/"
            }
        }
        
        var path: String {
            switch self {
            case .forecast:
                let url = "forecast"
                return url
            case .image(let id):
                let url = "\(id).png"
                return url
            }
        }
        
        var params: [URLQueryItem]? {
            var items: [URLQueryItem] = []
            switch self {
            case .forecast(let cityId):
                items.append(URLQueryItem(name: "APPID", value: "85679cbcaf6bd70490800c71f4db1db0"))
                items.append(URLQueryItem(name: "id", value: cityId))
                return items
            default:
                return nil
            }
        }
        
        var method: String {
            switch self {
            case .forecast:
                return "GET"
            default:
                return "GET"
                
            }
        }
        
        var headers: [String: String] {
            switch self {
            case .forecast:
                return  ["Content-Type": "application/json"]
            default:
                return  ["Content-Type": "application/json"]
            }
        }
    }
    
    init(router: Router) {
        var urlComponents = URLComponents(string: router.rootUrl)
        urlComponents?.queryItems = router.params
        self.url = urlComponents?.url
        self.urlRequest = URLRequest(url: self.url.appendingPathComponent(router.path))
        self.urlRequest.httpMethod = router.method
        self.urlRequest.allHTTPHeaderFields = router.headers
    }
    
}
