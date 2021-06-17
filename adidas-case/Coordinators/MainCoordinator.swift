//
//  ProductSearchCoordinator.swift
//  adidas-case
//
//  Created by PaulVaughan on 15/06/2021.
//

import Foundation
import UIKit


class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = ProductListViewModel()
        vm.navigator = self
        let vc = ProductListViewController(with: vm)
        navigationController.pushViewController(vc, animated: false)
    }
}


extension MainCoordinator: ProductSearchNavigator {
    func showProductDetails(forProduct productId: String) {
        let vm = ProductDetailsViewModel(productId)
        let vc = ProductDetailsViewController(with: vm)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showProductReviews(forProduct productId: String) {
        let vm = ProductReviewsViewModel(productId: productId)
        let vc = ReviewsViewController(with: vm)
        navigationController.pushViewController(vc, animated: false)
    }
    
}
