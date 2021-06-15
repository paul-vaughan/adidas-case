//
//  ProductService.swift
//  adidas-case
//
//  Created by PaulVaughan on 13/06/2021.
//

import Foundation
import Combine

class ProductService {
    var productUrl: URL { URL(string: "http://localhost:3001/product")! }
    
    func fetchProducts() -> AnyPublisher<[Product],Error> {
        return URLSession
            .shared
            .dataTaskPublisher(for: productUrl)
            .tryMap { $0.data }
            .decode(type: [Product].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func searchProducts(with name: String) -> AnyPublisher<Result<[Product], Error>, Never> {
        return fetchProducts()
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<[Product], Error>, Never> in .just(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
