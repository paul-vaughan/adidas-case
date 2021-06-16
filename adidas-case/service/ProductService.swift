//
//  ProductService.swift
//  adidas-case
//
//  Created by PaulVaughan on 13/06/2021.
//

import Foundation
import Combine

class ProductService {
    var networkService: NetworkServiceType
    
    init( networkService: NetworkServiceType = NetworkService() ){
        self.networkService = networkService
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
        return networkService
            .load(Resource<[Product]>.productList())
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<[Product], Error>, Never> in .just(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
