//
//  ProductReviewViewModel.swift
//  adidas-case
//
//  Created by PaulVaughan on 16/06/2021.
//

import Foundation
import Combine

class ProductReviewsViewModel {
    private var reviewService: ReviewServiceType
    
    var reviews = CurrentValueSubject<[Review], Never>([Review]())
    private var cancellables: [AnyCancellable] = []
    var productId: String
    
    init (productId: String, service: ReviewServiceType = ReviewService()) {
        self.productId = productId
        self.reviewService = service
    }
    
    func transform(input: ReviewsViewModelInput) -> ReviewsStateViewModelOutput {
        let productReviews = input.appear
            .flatMap({[unowned self] _ in self.reviewService.fetchReviews(for: self.productId)})
            .map({ result -> ReviewsState in
                switch result {
                    case .success(let reviews): return .success(self.viewModels(from: reviews))
                    case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        let newReview = input.addReview
            .flatMap({[unowned self] review in self.reviewService.addReviewToProduct(for: self.productId, with: review)})
            .map({ result -> ReviewsState in
                switch result {
                    case .success(let review): return .success(self.viewModels(from: [review]))
                    case .failure(let error): return .failure(error)
                }
            })
            .flatMap({[unowned self] _ in self.reviewService.fetchReviews(for: self.productId)})
            .map({ result -> ReviewsState in
                switch result {
                    case .success(let reviews): return .success(self.viewModels(from: reviews))
                    case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        let loading: ReviewsStateViewModelOutput = input.appear.map({_ in .loading })
            .eraseToAnyPublisher()

        let allReviews: ReviewsStateViewModelOutput = Publishers.Merge(productReviews, newReview).eraseToAnyPublisher()

        return Publishers.Merge(loading, allReviews).removeDuplicates().eraseToAnyPublisher()
    }
    
    private func viewModels(from reviews: [Review]) -> [ReviewViewModel] {
        return reviews.map({ review in
            return ProductReviewViewModelBuilder.viewModel(from: review)
        })
    }
}
