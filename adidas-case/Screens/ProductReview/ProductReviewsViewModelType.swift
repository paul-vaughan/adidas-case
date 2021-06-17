//
//  ProductReviewsViewModelType.swift
//  adidas-case
//
//  Created by PaulVaughan on 16/06/2021.
//

import UIKit
import Combine

// INPUT
struct ReviewsViewModelInput {
    /// called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
    let addReview: AnyPublisher<Review, Never>
}

// OUTPUT
enum ReviewsState {
    case loading
    case success([ReviewViewModel])
    case failure(Error)
}

extension ReviewsState: Equatable {
    static func == (lhs: ReviewsState, rhs: ReviewsState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success(let lhsProduct), .success(let rhsProduct)): return lhsProduct == rhsProduct
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias ReviewsStateViewModelOutput = AnyPublisher<ReviewsState, Never>



