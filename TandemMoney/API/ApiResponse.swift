//
//  APIResponse.swift
//  TandemMoney
//
//  Created by Šimun Strukan on 14/03/2018.
//  Copyright © 2018 Sintezis. All rights reserved.
//

import Foundation

class ApiResponse {
    
    enum ApiResponseStatus {
        case success
        case failure
    }
    
    var status: ApiResponseStatus
    var data: Any?
    var error: ApiError?
    var rawData: Data?
    private var decoder = JSONDecoder()
    
    init(status: ApiResponseStatus, errors: [String: Any]) {
        self.status = status
        self.error = ApiError(error: errors)
    }
    
    init(status: ApiResponseStatus, data: Data) {
        self.rawData = data
        self.status = status
        do {
            if status == .success {
                self.data = try decoder.decode(Forecast.self, from: data)
            }
            else {
                let apiError = try decoder.decode(ApiErrorResponse.self, from: data) as ApiErrorResponse
                self.error = ApiError(error: apiError)
            }
        }
        catch let error {
            debug.printApi(decodeError: error, suspend: true)
            self.status = .failure
            let error = [
                "msg": error.localizedDescription,
                "desc": error.localizedDescription.debugDescription,
                "code": "000"
            ]
            self.error = ApiError(error: error)
        }
    }
}
