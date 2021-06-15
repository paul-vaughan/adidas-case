//
//  ReusableView.swift
//  adidas-case
//
//  Created by PaulVaughan on 13/06/2021.
//

import Foundation
import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}
