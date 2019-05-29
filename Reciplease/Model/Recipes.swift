//
//  Recipe.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-18.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation

struct Recipes: Codable {
    let matches: [Match]?
}

struct Match: Codable {
    let imageUrlsBySize: ImageUrlsBySize?
    let sourceDisplayName: String?
    let ingredients: [String]?
    let id: String?
    let smallImageUrls: [String]?
    let recipeName: String?
    let totalTimeInSeconds: Int?
    let rating: Int?
}



struct ImageUrlsBySize: Codable {
    let the90: String?
    
    enum CodingKeys: String, CodingKey {
        case the90 = "90"
    }
}
