//
//  ProductDetailsViewModelType.swift
//  adidas-case
//
//  Created by PaulVaughan on 16/06/2021.
//

import UIKit
import Combine

struct ProductDetailsViewModelInput {
    let appear: AnyPublisher<Void, Never>
}

enum ProductDetailsState {
    case loading
    case success(ProductViewModel)
    case failure(Error)
}

extension ProductDetailsState: Equatable {
    static func == (lhs: ProductDetailsState, rhs: ProductDetailsState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success(let lhsProduct), .success(let rhsProduct)): return lhsProduct == rhsProduct
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias ProductDetailsViewModelOutput = AnyPublisher<ProductDetailsState, Never>



