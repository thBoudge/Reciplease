//
//  YummlyProtocol.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-18.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation

import Alamofire

protocol YummlyProtocol {
    var urlStringApi: String { get }
    func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void)
}

extension YummlyProtocol {
    
    var urlStringApi: String {
        let urlString = "http://api.yummly.com/v1/api/recipes"
        return urlString
    }
}

