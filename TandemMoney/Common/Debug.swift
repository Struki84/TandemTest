//
//  Debug.swift
//  TandemMoney
//
//  Created by Šimun Strukan on 17/03/2018.
//  Copyright © 2018 Sintezis. All rights reserved.
//

import Foundation

class Debug {
    
    var active: Bool!
    
    init(active: Bool) {
        self.active = active
    }
    
    func printApi(data: Any, suspend: Bool = false) {
        if active && !suspend {
            print("=====> Api Data:")
            print(data)
            print("\n")
        }
    }
    
    func printApi(request: ApiRequest, suspend: Bool = false) {
        if active && !suspend {
            print("=====> Request:")
            if let urlRequest = request.urlRequest {
                print("Method: \(urlRequest.httpMethod!)")
                print("URL: \(urlRequest.url!)")
                print("\n")
            }
        }   
    }
    
    func printApi(httpResponse: HTTPURLResponse, suspend: Bool = false) {
        if active && !suspend {
            print("=====> Server Responded:")
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers: \(httpResponse.allHeaderFields)")
            print("\n")
        }
    }
    
    func printApi(decodeError: Error, suspend: Bool = false) {
        if active && !suspend {
            print("=====> JSON Decoder Error:")
            print(decodeError)
            print("\n")
        }
    }
    
    func printApiError(error: ApiError, suspend: Bool = false) {
        if active && !suspend {
            print("=====> Error:")
            if let apiError = error as? ApiError {
                print("Code: \(apiError.code!)")
                print("Msg: \(apiError.msg!)")
                if let errorDesc = apiError.desc {
                    print("Desc: \(errorDesc)")
                }
                print("\n")
            }
        }
    }
}
