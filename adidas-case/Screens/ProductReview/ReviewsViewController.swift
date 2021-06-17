//
//  ReviewsViewController.swift
//  adidas-case
//
//  Created by PaulVaughan on 16/06/2021.
//

import UIKit
import Combine
import SwiftUI

class ReviewsViewController: UIViewController {
    
    var viewModel: ProductReviewsViewModel
    private let appear = PassthroughSubject<Void, Never>()
    private let newReview = PassthroughSubject<Review, Never>()
    private var cancellables: [AnyCancellable] = []
    private lazy var dataSource = makeReviewDataSource()

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addReview(_ sender: Any) {
        let addReviewModel = AddReviewViewModel(productId: viewModel.productId)
        let hostingController = UIHostingController(rootView: AddReviewView(
            dismissAction: {  self.dismiss( animated: true,
                                            completion: {  self.pushReview(with: addReviewModel)}
            )}
        ).environmentObject(addReviewModel))
        self.present(hostingController, animated: true, completion: nil)
    }
    
    init( with productReviewsViewModel: ProductReviewsViewModel){
        viewModel = productReviewsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(to: viewModel)
    }
    
    private func configureUI() {
        definesPresentationContext = true
        tableView.tableFooterView = UIView()
        tableView.registerNib(cellClass: ReviewTableViewCell.self)
        tableView.dataSource = dataSource
        setAdidasNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appear.send(())
    }

    private func bind(to viewModel: ProductReviewsViewModel) {
        let input = ReviewsViewModelInput(appear: appear.eraseToAnyPublisher(),
                                          addReview: newReview.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
    
    private func render(_ state: ReviewsState) {
        switch state {
        case .loading:
            update(with: [], animate: true)
            print("loading")
        case .failure:
            update(with: [], animate: true)
            print("failure")
        case .success(let reviews):
            update(with: reviews)
        }
    }
    
    
    private func pushReview(with review: AddReviewViewModel){
        newReview.send(Review(productId: review.productId,
                              locale: "en-GB,en;q=0.9,en-US;q=0.8,nl;q=0.7",
                              rating: Int(review.rank),
                              text: review.comment))
    }
}

fileprivate extension ReviewsViewController {
    enum Section: CaseIterable {
        case reviews
    }

    func makeReviewDataSource() -> UITableViewDiffableDataSource<Section, ReviewViewModel> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, reviewViewModel in
                guard let cell = tableView.dequeueReusableCell(withClass: ReviewTableViewCell.self) else {
                    assertionFailure("Failed to dequeue \(ReviewTableViewCell.self)!")
                    return UITableViewCell()
                }
                cell.bind(to: reviewViewModel)
                return cell
            }
        )
    }

    func update(with reviews: [ReviewViewModel], animate: Bool = false) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, ReviewViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(reviews, toSection: .reviews)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}


