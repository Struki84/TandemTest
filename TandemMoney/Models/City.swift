//
//  CitiesList.swift
//  TandemMoney
//
//  Created by Šimun Strukan on 20/03/2018.
//  Copyright © 2018 Sintezis. All rights reserved.
//

import Foundation

struct City: Codable {
    
    let name: String?
    let id: Int?
    let coordinates: Coordinates?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case id
        case coordinates = "coord"
    }
    
    struct Coordinates: Codable {
        let lat: Double?
        let lng: Double?

        private enum CodingKeys: String, CodingKey {
            case lat
            case lng = "lon"
        }
    }
}
