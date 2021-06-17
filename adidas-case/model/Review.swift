//
//  Review.swift
//  adidas-case
//
//  Created by PaulVaughan on 13/06/2021.
//

import Foundation

struct Review: Codable {
    var productId: String
    var locale: String
    var rating: Int
    var text: String
}
