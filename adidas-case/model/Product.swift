//
//  Product.swift
//  adidas-case
//
//  Created by PaulVaughan on 13/06/2021.
//

import Foundation

struct Product: Codable {
    let uuid = UUID()

    var id: String
    var name: String
    var description: String
    var currency: String
    var price: Int
    var imgUrl: String
}


extension Product: Hashable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
