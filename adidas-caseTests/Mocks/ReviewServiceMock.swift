//
//  ReviewServiceMock.swift
//  adidas-caseTests
//
//  Created by PaulVaughan on 17/06/2021.
//

import Foundation
import Combine
@testable import adidas_case


final class ReviewServiceMock: ReviewServiceType {
    
    let review = Review(productId: "1", locale: "NL", rating: 2, text: "Test")
    
    func fetchReviews(for productId: String) -> AnyPublisher<Result<[Review], Error>, Never> {
        let reviews = [review]
        return .just(Result { reviews })
    }
    
    func addReviewToProduct(for id: String, with review: Review) -> AnyPublisher<Result<Review, Error>, Never> {
      
        return .just(Result { self.review })
    }
}
