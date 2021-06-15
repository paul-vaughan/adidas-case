//
//  ImageServiceLoadable.swift
//  adidas-case
//
//  Created by PaulVaughan on 13/06/2021.
//

import Foundation
import UIKit.UIImage
import Combine

protocol ImageServiceLoadable: AnyObject {
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}
