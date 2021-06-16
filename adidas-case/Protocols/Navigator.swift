//
//  Navigator.swift
//  adidas-case
//
//  Created by PaulVaughan on 16/06/2021.
//

import Foundation

protocol ProductSearchNavigator: AnyObject {
    /// Presents the product details screen
    func showProductDetails(forProduct productId: String)
}
