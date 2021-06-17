//
//  ReviewViewModel.swift
//  adidas-case
//
//  Created by PaulVaughan on 16/06/2021.
//

import Foundation


struct ProductReviewViewModelBuilder {
    static func viewModel(from review: Review) -> ReviewViewModel {
        return ReviewViewModel(productId: review.productId, locale: review.locale, rating: review.rating, text: review.text)
    }
}

struct ReviewViewModel {
    var uuid: UUID
    
    var productId: String
    var locale: String
    var rating: Int
    var text: String

    init(productId: String, locale: String, rating: Int, text: String) {
        self.uuid = UUID()
        self.productId = productId
        self.locale = locale
        self.rating = rating
        self.text = text
    }
}

extension ReviewViewModel: Hashable {
    static func == (lhs: ReviewViewModel, rhs: ReviewViewModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
