//
//  ReviewService.swift
//  adidas-case
//
//  Created by PaulVaughan on 16/06/2021.
//

import Foundation
import Combine

class ReviewService: ReviewServiceType {
    var networkService: NetworkServiceType
    
    init( networkService: NetworkServiceType = NetworkService() ){
        self.networkService = networkService
    }
    
    func fetchReviews(for productId: String) -> AnyPublisher<Result<[Review], Error>, Never> {
        return networkService
            .load(Resource<[Review]>.productReviews(productId: productId))
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<[Review], Error>, Never> in .just(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func addReviewToProduct(for id: String, with review: Review) -> AnyPublisher<Result<Review, Error>, Never> {
        return networkService
            .load(Resource<Review>.addProductReview(productId: id, review: review))
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<Review, Error>, Never> in .just(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
