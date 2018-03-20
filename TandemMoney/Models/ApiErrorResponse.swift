//
//  Error.swift
//  TandemMoney
//
//  Created by Šimun Strukan on 16/03/2018.
//  Copyright © 2018 Sintezis. All rights reserved.
//

import Foundation

struct ApiErrorResponse: Codable {
    
    let cod: String?
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case cod
        case message
    }
}
