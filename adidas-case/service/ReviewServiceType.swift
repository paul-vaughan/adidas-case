//
//  ReviewServiceType.swift
//  adidas-case
//
//  Created by PaulVaughan on 17/06/2021.
//

import Foundation
import Combine

protocol ReviewServiceType: AnyObject {
    func fetchReviews(for productId: String) -> AnyPublisher<Result<[Review], Error>, Never>
    func addReviewToProduct(for id: String, with review: Review) -> AnyPublisher<Result<Review, Error>, Never>
}

