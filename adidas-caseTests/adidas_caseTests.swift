//
//  adidas_caseTests.swift
//  adidas-caseTests
//
//  Created by PaulVaughan on 13/06/2021.
//

import XCTest
import Combine
@testable import adidas_case

class adidas_caseTests: XCTestCase {
    
    var reviewsViewModel: ProductReviewsViewModel!
    private var cancellables: [AnyCancellable] = []
    let appear = PassthroughSubject<Void, Never>()
    let newReview = PassthroughSubject<Review, Never>()


    override func setUp() {
        reviewsViewModel = .init(productId: "w344", service: ReviewServiceMock())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetReviews() throws {
        let input = ReviewsViewModelInput(appear: appear.eraseToAnyPublisher(),
                                          addReview: newReview.eraseToAnyPublisher())
        
        let output = reviewsViewModel.transform(input: input)

        output.sink(receiveValue: { state in
            switch state {
            case .success(let reviews):
                XCTAssert(reviews.count == 1)
            default:
                print(state)
            }
        }).store(in: &cancellables)
        appear.send()
    }
    
    func testSaveReview() throws {
        let review = Review(productId: "1", locale: "NL", rating: 2, text: "Test")
        
        let input = ReviewsViewModelInput(appear: appear.eraseToAnyPublisher(),
                                          addReview: newReview.eraseToAnyPublisher())
        
        let output = reviewsViewModel.transform(input: input)

        output.sink(receiveValue: { state in
            switch state {
            case .success(let reviews):
                XCTAssert(reviews.first?.text == "Test")
            default:
                print(state)
            }
        }).store(in: &cancellables)
        newReview.send(review)
    }
}
