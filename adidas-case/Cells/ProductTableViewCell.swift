//
//  ProductTableViewCell.swift
//  adidas-case
//
//  Created by PaulVaughan on 13/06/2021.
//

import Foundation
import UIKit
import Combine


class ProductTableViewCell: UITableViewCell, NibProvidable, ReusableView {

    @IBOutlet private var title: UILabel!
    @IBOutlet private var subtitle: UILabel!
    @IBOutlet private var rating: UILabel!
    @IBOutlet private var productImage: UIImageView!
    private var cancellable: AnyCancellable?

    override func prepareForReuse() {
        super.prepareForReuse()
        cancelImageLoading()
    }

    func bind(to viewModel: ProductViewModel) {
        cancelImageLoading()
        title.text = viewModel.name
        subtitle.text = viewModel.description
        rating.text = "\(viewModel.price)\(viewModel.currency)"
        cancellable = viewModel.image.sink { [unowned self] image in self.showImage(image: image) }
    }

    private func showImage(image: UIImage?) {
        cancelImageLoading()
        UIView.transition(with: self.productImage,
        duration: 0.3,
        options: [.curveEaseOut, .transitionCrossDissolve],
        animations: {
            self.productImage.image = image
        })
    }

    private func cancelImageLoading() {
        productImage.image = nil
        cancellable?.cancel()
    }

}
