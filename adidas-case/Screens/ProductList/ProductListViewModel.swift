//
//  ProductViewModel.swift
//  adidas-case
//
//  Created by PaulVaughan on 13/06/2021.
//

import Foundation
import Combine

class ProductListViewModel {
    private var productService: ProductService
    private var imageLoaderService: ImageLoaderService
    
    var navigator: ProductSearchNavigator?
    
    var products = CurrentValueSubject<[Product], Never>([Product]())
    private var cancellables: [AnyCancellable] = []

    
    init (_ service: ProductService = ProductService(), imageLoaderService: ImageLoaderService = ImageLoaderService()) {
        self.productService = service
        self.imageLoaderService = imageLoaderService
    }
    
    func transform(input: ProductSearchViewModelInput) -> ProductSearchViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        input.selection
            .sink(receiveValue: { [unowned self] productId in self.navigator?.showProductDetails(forProduct: productId) })
            .store(in: &cancellables)

        let searchInput = input.search
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
        
        let products = input.appear
            .flatMapLatest({ [unowned self] in self.productService.searchProducts(with: "") })
            .map({ result -> ProductSearchState in
                switch result {
                case .success(let products) where products.isEmpty: return .noResults
                case .success(let products): return .success(self.viewModels(from: products))
                case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()

        let initialState: ProductSearchViewModelOutput = .just(.idle)
        let emptySearchString: ProductSearchViewModelOutput = searchInput.filter({ $0.isEmpty }).map({ _ in .idle }).eraseToAnyPublisher()
        let idle: ProductSearchViewModelOutput = Publishers.Merge(initialState, emptySearchString).eraseToAnyPublisher()

        return Publishers.Merge(idle, products).removeDuplicates().eraseToAnyPublisher()
    }

    private func viewModels(from products: [Product]) -> [ProductViewModel] {
        return products.map({[unowned self] product in
            return ProductViewModelBuilder.viewModel(from: product, imageLoader: {[unowned self] product in self.imageLoaderService.loadImage(for: product) })
        })
    }
}



