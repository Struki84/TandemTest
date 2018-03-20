//
//  Forecast.swift
//  TandemMoney
//
//  Created by Šimun Strukan on 16/03/2018.
//  Copyright © 2018 Sintezis. All rights reserved.
//

import Foundation

struct Forecast: Codable {
    let cod: String?
    let message: Double?
    let city: City?
    let list: [ListItem]?
    
    private enum CodingKeys: String, CodingKey {
        case cod
        case message
        case city
        case list
    }
    
    struct City: Codable {
        let id: Int?
        let name: String?
        let country: String?
        let coord: Coord
        
        private enum CodingKeys: String, CodingKey {
            case id
            case name
            case country
            case coord
        }
    
        struct Coord: Codable {
            let lat: Double?
            let lon: Double?

            private enum CodingKeys: String, CodingKey {
                case lat
                case lon
            }
        }
    }
    
    struct ListItem: Codable {
        let timestamp: Int?
        let date: String?
        let main: Main?
        let weather: [Weather]?

        private enum CodingKeys: String, CodingKey {
            case timestamp = "dt"
            case date = "dt_txt"
            case main
            case weather
        }

        struct Main: Codable {
            let temp: Double?
            let tempMin: Double?
            let tempMax: Double?
            let pressure: Double?

            private enum CodingKeys: String, CodingKey {
                case temp
                case tempMin = "temp_min"
                case tempMax = "temp_max"
                case pressure
            }

        }

        struct Weather: Codable {
            let id: Int?
            let main: String?
            let description: String?
            let icon: String?

            private enum CodingKeys: String, CodingKey {
                case id
                case main
                case description
                case icon
            }
        }
    }
}
