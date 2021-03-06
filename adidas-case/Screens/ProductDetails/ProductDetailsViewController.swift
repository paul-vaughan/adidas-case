//
//  ProductDetailsViewController.swift
//  adidas-case
//
//  Created by PaulVaughan on 15/06/2021.
//

import UIKit
import Combine

class ProductDetailsViewController: UIViewController {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var ratingview: UIView!
    
    var viewModel: ProductDetailsViewModel
    private var cancellables: [AnyCancellable] = []
    private let appear = PassthroughSubject<Void, Never>()
    
    init( with producViewModel: ProductDetailsViewModel){
        viewModel = producViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addReviews()
        appear.send(())
    }

    private func bind(to viewModel: ProductDetailsViewModel) {
        let input = ProductDetailsViewModelInput(appear: appear.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
    
    private func render(_ state: ProductDetailsState) {
        switch state {
        case .loading:
            productName.isHidden = true
        case .failure:
            productName.isHidden = true
        case .success(let prductDetails):
            productName.isHidden = false
            show(prductDetails)
        }
    }

    private func show(_ prductDetails: ProductViewModel) {
        productName.text = prductDetails.name
        price.text = "\(prductDetails.currency)\(prductDetails.price)"
        productDescription.text = prductDetails.description
        prductDetails.image
            .assign(to: \UIImageView.image, on: self.productImage)
            .store(in: &cancellables)
    }
    
    private func addReviews() {
        let viewModel = ProductReviewsViewModel(productId: viewModel.productId)
        let viewController = ReviewsViewController(with: viewModel)
        addChild(viewController)
        ratingview.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}

extension UIViewController {
    func setAdidasNavBar() {
        self.navigationController!.navigationBar.barStyle = UIBarStyle.black
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.isTranslucent = false
        let titleView = UIView(frame: CGRect(x:0, y:0, width:35, height:35))
        let titleImageView = UIImageView(image: UIImage(named: "adidas-logo"))
        titleImageView.frame = CGRect(x:0, y:0,width: titleView.frame.width, height: titleView.frame.height)
        titleView.addSubview(titleImageView)
        navigationItem.titleView = titleView
    }
}
