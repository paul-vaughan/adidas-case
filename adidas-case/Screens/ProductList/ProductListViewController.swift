//
//  ProductOverviewViewController.swift
//  adidas-case
//
//  Created by PaulVaughan on 15/06/2021.
//

import UIKit
import Combine

final class ProductListViewController: UIViewController {
    
    private var cancellables: [AnyCancellable] = []
    private lazy var dataSource = makeDataSource()
    private var viewModel: ProductListViewModel
    private let selection = PassthroughSubject<String, Never>()
    private let search = PassthroughSubject<String, Never>()
    private let appear = PassthroughSubject<Void, Never>()
    private lazy var alertViewController = AlertViewController(nibName: nil, bundle: nil)

    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    init( with productListViewModel: ProductListViewModel){
        viewModel = productListViewModel
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
    }
    
    private func configureUI() {
        definesPresentationContext = true
        title = NSLocalizedString("Producs", comment: "new products")
        tableView.tableFooterView = UIView()
        tableView.registerNib(cellClass: ProductTableViewCell.self)
        tableView.dataSource = dataSource
        add(alertViewController)
        alertViewController.view.isHidden = true
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
            loadingView.isHidden = false
            update(with: [], animate: true)
        case .noResults:
            showError(state)
            update(with: [], animate: true)
        case .failure:
            showError(state)
            update(with: [], animate: true)
        case .success(let products):
            loadingView.isHidden = true
            alertViewController.view.isHidden = true
            update(with: products, animate: false)
        }
    }
    
    private func showError(_ state: ProductSearchState){
        alertViewController.view.isHidden = false
        switch state {
        case .noResults:
            alertViewController.showNoResults()
        default:
            alertViewController.showDataLoadingError()
        }
        loadingView.isHidden = true
    }
}

fileprivate extension ProductListViewController {
    enum Section: CaseIterable {
        case products
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, ProductViewModel> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
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

    func update(with products: [ProductViewModel], animate: Bool = false) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, ProductViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(products, toSection: .products)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

extension ProductListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        selection.send(snapshot.itemIdentifiers[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
