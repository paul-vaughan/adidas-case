//
//  ReviewTableViewCell.swift
//  adidas-case
//
//  Created by PaulVaughan on 16/06/2021.
//

import UIKit

class ReviewTableViewCell: UITableViewCell, NibProvidable, ReusableView {

    @IBOutlet weak var rangeLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(to viewModel: ReviewViewModel) {
       commentLabel.text = viewModel.text
       rangeLabel.text = viewModel.rating.description
    }    
}
