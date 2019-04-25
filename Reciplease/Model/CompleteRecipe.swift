//
//  CompleteRecipe.swift
//  Reciplease
//
//  Created by Thomas Bouges on 2019-04-21.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation


struct CompleteRecipe: Codable {
    let yield: String?
    let prepTimeInSeconds: Int?
    let totalTime: String?
    let images: [Image]?
    let name: String?
    let source: Source?
    let prepTime, id: String?
    let ingredientLines: [String]?
    let numberOfServings, totalTimeInSeconds: Int?
//    let attributes: Attributes?
    let flavors: Flavors?
    let rating: Int?
}

//struct Attributes: Codable {
//    let course: [String]?
//}

struct Flavors: Codable {
    let piquant, meaty, bitter, sweet: Double?
    let sour, salty: Double?
    
    enum CodingKeys: String, CodingKey {
        case piquant = "Piquant"
        case meaty = "Meaty"
        case bitter = "Bitter"
        case sweet = "Sweet"
        case sour = "Sour"
        case salty = "Salty"
    }
}

struct Image: Codable {
    let hostedSmallURL, hostedMediumURL, hostedLargeURL: String?
    let imageUrlsBySize: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case hostedSmallURL = "hostedSmallUrl"
        case hostedMediumURL = "hostedMediumUrl"
        case hostedLargeURL = "hostedLargeUrl"
        case imageUrlsBySize
    }
}

struct Source: Codable {
    let sourceDisplayName, sourceSiteURL: String?
    let sourceRecipeURL: String?
    
    enum CodingKeys: String, CodingKey {
        case sourceDisplayName
        case sourceSiteURL = "sourceSiteUrl"
        case sourceRecipeURL = "sourceRecipeUrl"
    }
}
