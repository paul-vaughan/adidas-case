//
//  ProductSearchModelType.swift
//  adidas-case
//
//  Created by PaulVaughan on 16/06/2021.
//

import Foundation
import Combine

enum ProductSearchState {
    case idle
    case loading
    case success([ProductViewModel])
    case noResults
    case failure(Error)
}

extension ProductSearchState: Equatable {
    static func == (lhs: ProductSearchState, rhs: ProductSearchState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success(let lhsProducts), .success(let rhsProducts)): return lhsProducts == rhsProducts
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}

struct ProductSearchViewModelInput {
    /// called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
    // triggered when the search query is updated
    let search: AnyPublisher<String, Never>
    /// called when the user selected an item from the list
    let selection: AnyPublisher<String, Never>
}

typealias ProductSearchViewModelOutput = AnyPublisher<ProductSearchState, Never>
