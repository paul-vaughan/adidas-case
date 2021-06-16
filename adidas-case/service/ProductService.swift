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
    
    var networkService: NetworkServiceType
    
    init( networkService: NetworkServiceType = NetworkService() ){
        self.networkService = networkService
    }
    
    func fetchProducts() -> AnyPublisher<[Product],Error> {
        return URLSession
            .shared
            .dataTaskPublisher(for: productUrl)
            .tryMap { $0.data }
            .decode(type: [Product].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchProductDetails(from productId: String) -> AnyPublisher<Product,Error> {
        let productDetailUrl = URL(string: "http://localhost:3001/product/\(productId)")!
        return URLSession
            .shared
            .dataTaskPublisher(for: productDetailUrl)
            .tryMap { $0.data }
            .decode(type: Product.self, decoder: JSONDecoder())
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    
    func fetchProduct(with productId: String) -> AnyPublisher<Result<Product, Error>, Never> {
        return networkService
            .load(Resource<Product>.details(productId: productId))
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<Product, Error>, Never> in .just(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
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
