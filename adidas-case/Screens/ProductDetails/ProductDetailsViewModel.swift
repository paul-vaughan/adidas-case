//
//  ProductDetailsViewModel.swift
//  adidas-case
//
//  Created by PaulVaughan on 16/06/2021.
//

import Foundation
import Combine

class ProductDetailsViewModel {
    private var productService: ProductService
    private var imageLoaderService: ImageLoaderService
    private var navigator: ProductSearchNavigator?
    
    private var cancellables: [AnyCancellable] = []
    var productId: String

    
    init (_ productId: String, service: ProductService = ProductService(), imageLoaderService: ImageLoaderService = ImageLoaderService()) {
        self.productService = service
        self.imageLoaderService = imageLoaderService
        self.productId = productId
    }
    
    func transform(input: ProductDetailsViewModelInput) -> ProductDetailsViewModelOutput {
        let productDetails = input.appear
            .flatMap({[unowned self] _ in self.productService.fetchProduct(with: self.productId) })
            .map({ result -> ProductDetailsState in
                switch result {
                    case .success(let product): return .success(self.viewModel(from: product))
                    case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        let loading: ProductDetailsViewModelOutput = input.appear.map({_ in .loading }).eraseToAnyPublisher()

        return Publishers.Merge(loading, productDetails).removeDuplicates().eraseToAnyPublisher()
    }

    private func viewModel(from product: Product) -> ProductViewModel {
        return ProductViewModelBuilder.viewModel(from: product, imageLoader: {[unowned self] product in self.imageLoaderService.loadImage(for: product) })
    }
    
}
