//
//  AlertViewModel.swift
//  adidas-case
//
//  Created by PaulVaughan on 16/06/2021.
//

import Foundation
import UIKit.UIImage

struct AlertViewModel {
    let title: String
    let description: String?
    let image: UIImage

    static var noResults: AlertViewModel {
        let title = NSLocalizedString("No products found!", comment: "No products found!")
        let description = NSLocalizedString("Try searching again...", comment: "Try searching again...")
        let image = UIImage(named: "search") ?? UIImage()
        return AlertViewModel(title: title, description: description, image: image)
    }

    static var dataLoadingError: AlertViewModel {
        let title = NSLocalizedString("Can't load products!", comment: "Can't load products!")
        let description = NSLocalizedString("Oops something went wrong. please try again...", comment: "Oops something went wrong. please try again..")
        let image = UIImage(named: "error") ?? UIImage()
        return AlertViewModel(title: title, description: description, image: image)
    }
}

