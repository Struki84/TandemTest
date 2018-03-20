//
//  APIError.swift
//  TandemMoney
//
//  Created by Šimun Strukan on 14/03/2018.
//  Copyright © 2018 Sintezis. All rights reserved.
//
import Foundation

struct ApiError {
    var code: String?
    var msg: String?
    var desc: String?
    
    init(error: [String: Any]) {
        self.code = error["code"] as? String
        self.msg = error["msg"] as? String
        self.desc = error["desc"] as? String
    }
    
    init(error: ApiErrorResponse) {
        self.code = error.cod!
        self.msg = error.message!
    }
}
