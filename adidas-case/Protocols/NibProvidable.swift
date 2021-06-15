//
//  NibProvidable.swift
//  adidas-case
//
//  Created by PaulVaughan on 13/06/2021.
//

import Foundation
import UIKit

protocol NibProvidable {
    static var nibName: String { get }
    static var nib: UINib { get }
}


extension NibProvidable {
    static var nibName: String {
        return "\(self)"
    }
    static var nib: UINib {
        return UINib(nibName: self.nibName, bundle: nil)
    }
}
