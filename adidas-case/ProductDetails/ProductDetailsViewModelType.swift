//
//  ProductDetailsViewModelType.swift
//  adidas-case
//
//  Created by PaulVaughan on 16/06/2021.
//

import UIKit
import Combine

// INPUT
struct ProductDetailsViewModelInput {
    /// called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
}

// OUTPUT
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



