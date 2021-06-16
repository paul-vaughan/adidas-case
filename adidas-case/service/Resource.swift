//
//  Resource.swift
//  adidas-case
//
//  Created by PaulVaughan on 16/06/2021.
//

import Foundation

struct Resource<T: Decodable> {
    let url: URL
    let parameters: [String: CustomStringConvertible]
    var request: URLRequest? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = parameters.keys.map { key in
            URLQueryItem(name: key, value: parameters[key]?.description)
        }
        guard let url = components.url else {
            return nil
        }
        return URLRequest(url: url)
    }

    init(url: URL, parameters: [String: CustomStringConvertible] = [:]) {
        self.url = url
        self.parameters = parameters
    }
}


extension Resource {
    static func details(productId: String) -> Resource<Product> {
        let productDetailUrl = URL(string: "http://localhost:3001/product/\(productId)")!
        let parameters: [String : CustomStringConvertible] =  [String : CustomStringConvertible]()
        return Resource<Product>(url: productDetailUrl, parameters: parameters)
    }
}
