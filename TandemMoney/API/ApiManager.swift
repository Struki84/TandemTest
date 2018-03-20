//
//  APIMAnager.swift
//  TandemMoney
//
//  Created by Šimun Strukan on 14/03/2018.
//  Copyright © 2018 Sintezis. All rights reserved.
//

import Foundation
import UIKit

class ApiManager {
    
    var request: ApiRequest?
    var response: ApiResponse?
    var session: URLSession?
    
    private var APIReponseHandle: (Data?, URLResponse?, Error?) -> Void = { (data, URLresponse, error) in }
    
    init() {
        self.session = URLSession.shared
    }
    
    func send(request: ApiRequest) -> ApiManager {
        self.request = request
        debug.printApi(request: request, suspend: true)
        return self
    }
    
    func getImage(request: ApiRequest) -> ApiManager {
        self.request = request
        debug.printApi(request: request, suspend: true)
        return self
    }
    
    func responseImage(image: @escaping(UIImage) -> Void) {
        DispatchQueue.global().async {
            do {
                if let data = try? Data(contentsOf: self.request!.url) {
                    DispatchQueue.main.async {
                        if let downloadedImg = UIImage(data: data) {
                            image(downloadedImg)
                        }
                    }
                }
            }
            catch let error {
                print("Error Getting Image!")
                print(error)
            }
        }
    }
    
    func response(data: @escaping(ApiResponse) -> Void) {
        let task = session!.dataTask(with: self.request!.urlRequest!) { (responseData, URLResponse, error) in
            if let _ = error {
                let errors = [
                    "msg": error!.localizedDescription,
                    "desc": error!.localizedDescription.debugDescription,
                    "code": "\(error!.code)"
                ]
                self.response = ApiResponse(status: .failure, errors: errors)
            }
            else {
                if let httpResponse = URLResponse as? HTTPURLResponse {
                    debug.printApi(httpResponse: httpResponse, suspend: true)
                    if httpResponse.statusCode == 200 {
                        self.response = ApiResponse(status: .success, data: responseData!)
                    }
                    else {
                        self.response = ApiResponse(status: .failure, data: responseData!)
                    }
                }
            }
            data(self.response!)
        }
        task.resume()
    }

}
