//
//  AlertViewController.swift
//  adidas-case
//
//  Created by PaulVaughan on 16/06/2021.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showNoResults() {
        render(viewModel: AlertViewModel.noResults)
    }

    func showDataLoadingError() {
        render(viewModel: AlertViewModel.dataLoadingError)
    }

    fileprivate func render(viewModel: AlertViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        imageView.image = viewModel.image
    }

}
