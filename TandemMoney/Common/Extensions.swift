//
//  Extensions.swift
//  TandemMoney
//
//  Created by Šimun Strukan on 17/03/2018.
//  Copyright © 2018 Sintezis. All rights reserved.
//

import Foundation

extension Error {
    var code: Int { return (self as NSError).code }
}
