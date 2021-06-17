//
//  Resource.swift
//  adidas-case
//
//  Created by PaulVaughan on 16/06/2021.
//

import Foundation

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct Resource<T: Codable> {
    let url: URL
    let requestType:RequestType
    let body: T?
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
        
        var request =  URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        
        
        // Headers must specify that the HTTP request body is JSON-encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["Accept-Language"] = "en-GB,en;q=0.9,en-US;q=0.8,nl;q=0.7"
        request.allHTTPHeaderFields = headers
        
        if let body = body {
            // encode post struct into JSON format
            let encoder = JSONEncoder()
            do {
                let jsonData = try encoder.encode(body)
                request.httpBody = jsonData
                print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
            } catch {
                print(String(describing: error))
            }
        }
        return request
    }
    
    init(url: URL, parameters: [String: CustomStringConvertible] = [:], requestType:RequestType = .get, body: T? = nil) {
        self.url = url
        self.parameters = parameters
        self.requestType = requestType
        self.body = body
    }
}


extension Resource {    
    static func productList() -> Resource<[Product]> {
        let productDetailUrl = URL(string: "http://localhost:3001/product")!
        let parameters: [String : CustomStringConvertible] =  [String : CustomStringConvertible]()
        return Resource<[Product]>(url: productDetailUrl, parameters: parameters)
    }
    
    static func details(productId: String) -> Resource<Product> {
        let productDetailUrl = URL(string: "http://localhost:3001/product/\(productId)")!
        let parameters: [String : CustomStringConvertible] =  [String : CustomStringConvertible]()
        return Resource<Product>(url: productDetailUrl, parameters: parameters)
    }
    
    static func productReviews(productId: String) -> Resource<[Review]> {
        let productDetailUrl = URL(string: "http://localhost:3002/reviews/\(productId)")!
        let parameters: [String : CustomStringConvertible] =  [String : CustomStringConvertible]()
        return Resource<[Review]>(url: productDetailUrl, parameters: parameters)
    }
    
    static func addProductReview(productId: String, review: Review) -> Resource<Review> {
        let productDetailUrl = URL(string: "http://localhost:3002/reviews/\(productId)")!
        let parameters: [String : CustomStringConvertible] =  [String : CustomStringConvertible]()
        return Resource<Review>(url: productDetailUrl, parameters: parameters, requestType: .post, body: review)
    }
}
