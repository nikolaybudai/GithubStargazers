
import UIKit

final class StargazersViewController: UIViewController {
    
    let viewModel: StargazersViewModelProtocol
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let footerLoadingView = FooterLoadingView()
    
    //MARK: Init
    init(viewModel: StargazersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupBindings()
        
        fetchInitialStargazers()
    }
    
    //MARK: Methods
    private func setupBindings() {
        viewModel.onStargazersFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
                self?.hideActivityIndicator()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.showAlert(title: NSLocalizedString("errorTitle", comment: ""),
                            message: errorMessage)
        }
    }
    
    private func fetchInitialStargazers() {
        activityIndicator.startAnimating()
        
        Task {
            await viewModel.fetchStargazers()
        }
    }
    
    private func fetchMoreStargazers() {
        footerLoadingView.startAnimating()

        Task {
            await viewModel.fetchStargazers()
            DispatchQueue.main.async { [weak self] in
                self?.footerLoadingView.stopAnimating()
            }
        }
    }
    
    private func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
}

// MARK: - UIScrollViewDelegate
extension StargazersViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !viewModel.isLoading, viewModel.hasMorePages else { return }
            
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if offsetY >= (contentHeight - scrollViewHeight - 120) {
            fetchMoreStargazers()
        }
    }
}

//MARK: - UI Setup
private extension StargazersViewController {
    
    func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        
        setupActivityIndicator()
        setupTableView()
    }
    
    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StargazersTableViewCell.self,
                           forCellReuseIdentifier: StargazersTableViewCell.identifier)
        tableView.tableFooterView = footerLoadingView
        tableView.isHidden = true
        view.addSubview(tableView)
    }
    
    //MARK: Constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
}
