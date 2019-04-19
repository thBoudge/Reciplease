//
//  YummlySession.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-18.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import Alamofire

class YummlySession: YummlyProtocol {
    func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        Alamofire.request(url).responseJSON { responseData in
            completionHandler(responseData)
        }
    }
}
