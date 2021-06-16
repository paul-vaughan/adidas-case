//
//  Coordinator.swift
//  adidas-case
//
//  Created by PaulVaughan on 15/06/2021.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
