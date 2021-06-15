//
//  ProductViewModel.swift
//  adidas-case
//
//  Created by PaulVaughan on 13/06/2021.
//

import Foundation
import UIKit.UIImage
import Combine


struct ProductViewModelBuilder {
    static func viewModel(from product: Product, imageLoader: (Product) -> AnyPublisher<UIImage?, Never>) -> ProductViewModel {
        return ProductViewModel(id: product.id,
                                name: product.name,
                                description: product.description,
                                currency: product.currency,
                                price: String(product.price),
                                image: imageLoader(product))
    }
}

struct ProductViewModel {
    var uuid: UUID
    
    var id: String
    var name: String
    var description: String
    var currency: String
    var price: String
    let image: AnyPublisher<UIImage?, Never>

    init(id: String, name: String, description: String, currency: String, price: String, image: AnyPublisher<UIImage?, Never>) {
        self.uuid = UUID()
        self.id = id
        self.name = name
        self.description = description
        self.currency = currency
        self.price = price
        self.image = image
    }
}

extension ProductViewModel: Hashable {
    static func == (lhs: ProductViewModel, rhs: ProductViewModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

