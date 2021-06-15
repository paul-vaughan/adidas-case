//
//  Review.swift
//  adidas-case
//
//  Created by PaulVaughan on 13/06/2021.
//

import Foundation

struct Review: Codable {
    var id: String
    var name: String
    var description: String
    var currency: String
    var price: String
    var imgUrl: String
}
