//
//  ViewController.swift
//  adidas-case
//
//  Created by PaulVaughan on 13/06/2021.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private var cancellables: [AnyCancellable] = []
    private var viewModel: ProductListViewModel = ProductListViewModel()
    private let selection = PassthroughSubject<Int, Never>()
    private let search = PassthroughSubject<String, Never>()
    private let appear = PassthroughSubject<Void, Never>()

    @IBOutlet weak var productTableVIew: UITableView!
    
    private lazy var dataSource = makeDataSource()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(to: viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
    }
    
    private func configureUI() {
        definesPresentationContext = true
        title = NSLocalizedString("Producs", comment: "new products")
        productTableVIew.tableFooterView = UIView()
        productTableVIew.registerNib(cellClass: ProductTableViewCell.self)
        productTableVIew.dataSource = dataSource
    }

    private func bind(to viewModel: ProductListViewModel) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let input = ProductSearchViewModelInput(appear: appear.eraseToAnyPublisher(),
                                               search: search.eraseToAnyPublisher(),
                                               selection: selection.eraseToAnyPublisher())

        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
    
    private func render(_ state: ProductSearchState) {
        switch state {
        case .idle:
            update(with: [], animate: true)
        case .loading:
            update(with: [], animate: true)
        case .noResults:
            update(with: [], animate: true)
        case .failure:
            update(with: [], animate: true)
        case .success(let products):
            update(with: products, animate: true)
        }
    }
}

fileprivate extension ViewController {
    enum Section: CaseIterable {
        case products
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, ProductViewModel> {
        return UITableViewDiffableDataSource(
            tableView: productTableVIew,
            cellProvider: {  tableView, indexPath, productViewModel in
                guard let cell = tableView.dequeueReusableCell(withClass: ProductTableViewCell.self) else {
                    assertionFailure("Failed to dequeue \(ProductTableViewCell.self)!")
                    return UITableViewCell()
                }
                cell.bind(to: productViewModel)
                return cell
            }
        )
    }

    func update(with products: [ProductViewModel], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, ProductViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(products, toSection: .products)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

enum ProductSearchState {
    case idle
    case loading
    case success([ProductViewModel])
    case noResults
    case failure(Error)
}

extension ProductSearchState: Equatable {
    static func == (lhs: ProductSearchState, rhs: ProductSearchState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success(let lhsProducts), .success(let rhsProducts)): return lhsProducts == rhsProducts
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}

struct ProductSearchViewModelInput {
    /// called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
    // triggered when the search query is updated
    let search: AnyPublisher<String, Never>
    /// called when the user selected an item from the list
    let selection: AnyPublisher<Int, Never>
}

typealias ProductSearchViewModelOutput = AnyPublisher<ProductSearchState, Never>

