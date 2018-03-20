//
//  APIInterface.swift
//  TandemMoney
//
//  Created by Šimun Strukan on 14/03/2018.
//  Copyright © 2018 Sintezis. All rights reserved.
//

import Foundation

class ApiInterface {
    
    var manager: ApiManager!
    
    init() {
        self.manager = ApiManager()
    }
    
    func get(forecastFor cityId: String) -> ApiManager {
        let apiRequest = ApiRequest(router: .forecast(cityId))
        return manager.send(request: apiRequest)
    }
    
    func getIcon(with id: String) -> ApiManager {
        let apiRequest = ApiRequest(router: .image(id))
        return manager.send(request: apiRequest)
    }
}
