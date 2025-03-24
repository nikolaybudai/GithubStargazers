
import UIKit

final class SearchViewController: UIViewController {
    
    private var viewModel: SearchViewModelProtocol
    
    private let stackView = UIStackView()
    private let ownerLabel = UILabel()
    private let ownerTextField = TextFieldWithPadding()
    private let repositoryLabel = UILabel()
    private let repositoryTextField = TextFieldWithPadding()
    private let searchButton = UIButton()
    
    //MARK: Init
    init(viewModel: SearchViewModelProtocol) {
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
    }
    
    //MARK: Methods
    @objc private func didTapSearchButton() {
        viewModel.ownerName = ownerTextField.text
        viewModel.repositoryName = repositoryTextField.text
        
        let isValid = viewModel.isInputValid(ownerName: ownerTextField.text,
                                             repositoryName: repositoryTextField.text)
        
        if isValid {
            guard let ownerName = viewModel.ownerName,
                  let repositoryName = viewModel.repositoryName
            else {
                return
            }
            
            showStargazersScreen(ownerName: ownerName, repositoryName: repositoryName)
        } else {
            showAlert(title: NSLocalizedString("invalidInputTitle", comment: ""),
                      message: NSLocalizedString("invalidInputMessage", comment: ""))
        }
    }
    
    private func showStargazersScreen(ownerName: String, repositoryName: String) {
        let stargazersSerivce = StargazersService()
        let imageLoader = ImageLoader()
        
        let stargazersViewModel = StargazersViewModel(ownerName: ownerName,
                                                      repositoryName: repositoryName,
                                                      stargazersService: stargazersSerivce,
                                                      imageLoader: imageLoader)
        
        let stargazersViewController = StargazersViewController(viewModel: stargazersViewModel)
        
        navigationController?.pushViewController(stargazersViewController, animated: true)
    }

}

//MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}

//MARK: - UI Setup
private extension SearchViewController {
    
    func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        
        setupOwnerLabel()
        setupOwnerTextField()
        setupRepositoryLabel()
        setupRepositoryTextField()
        setupStackView()
        setupSearchButton()
    }
    
    func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(ownerLabel)
        stackView.addArrangedSubview(ownerTextField)
        stackView.addArrangedSubview(repositoryLabel)
        stackView.addArrangedSubview(repositoryTextField)
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        view.addSubview(stackView)
    }
    
    func setupOwnerLabel() {
        ownerLabel.translatesAutoresizingMaskIntoConstraints = false
        ownerLabel.text = NSLocalizedString("repositoryOwnerLabelText", comment: "")
        ownerLabel.font = .systemFont(ofSize: 20)
    }
    
    func setupOwnerTextField() {
        ownerTextField.translatesAutoresizingMaskIntoConstraints = false
        ownerTextField.placeholder = NSLocalizedString(
            "repositoryTextFieldPlaceholder", comment: ""
        )
        ownerTextField.borderStyle = .none
        ownerTextField.backgroundColor = .white
        ownerTextField.layer.cornerRadius = 8
        ownerTextField.layer.borderWidth = 1
        ownerTextField.layer.borderColor = UIColor.gray.cgColor
        ownerTextField.delegate = self
    }
    
    func setupRepositoryLabel() {
        repositoryLabel.translatesAutoresizingMaskIntoConstraints = false
        repositoryLabel.text = NSLocalizedString("repositoryNameLabelText", comment: "")
        repositoryLabel.font = .systemFont(ofSize: 20)
    }
    
    func setupRepositoryTextField() {
        repositoryTextField.translatesAutoresizingMaskIntoConstraints = false
        repositoryTextField.placeholder = NSLocalizedString(
            "repositoryTextFieldPlacehilder", comment: ""
        )
        repositoryTextField.borderStyle = .none
        repositoryTextField.backgroundColor = .white
        repositoryTextField.layer.cornerRadius = 8
        repositoryTextField.layer.borderWidth = 1
        repositoryTextField.layer.borderColor = UIColor.gray.cgColor
        repositoryTextField.delegate = self
    }
    
    func setupSearchButton() {
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.backgroundColor = .systemBlue
        searchButton.setTitle(
            NSLocalizedString("searchStargazersButtonTitle", comment: ""),
            for: .normal
        )
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        searchButton.layer.cornerRadius = 8
        searchButton.clipsToBounds = true
        view.addSubview(searchButton)
        
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
    }
    
    //MARK: Constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            searchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            searchButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
}
