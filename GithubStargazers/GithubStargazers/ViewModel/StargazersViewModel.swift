

import UIKit

//MARK: - Protocol
protocol StargazersViewModelProtocol: AnyObject {
    var ownerName: String { get }
    var repositoryName: String { get }
    var isLoading: Bool { get set }
    var stargazers: [Stargazer] { get }
    var hasMorePages: Bool { get }
    
    var onStargazersFetched: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    func fetchStargazers() async
    func loadImage(from imageURL: String) async -> UIImage
}

//MARK: - StargazersViewModel
final class StargazersViewModel: StargazersViewModelProtocol {
    
    var ownerName: String
    var repositoryName: String
    var isLoading: Bool = false
    var hasMorePages = true
    
    var onStargazersFetched: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private var currentPage = 1
    
    var stargazers: [Stargazer]  = [] {
        didSet {
            onStargazersFetched?()
        }
    }
    
    private let stargazersSerivce: StargazersServiceProtocol
    private let imageLoader: ImageLoaderProtocol
    
    //MARK: Init
    init(ownerName: String,
         repositoryName: String,
         stargazersService: StargazersServiceProtocol,
         imageLoader: ImageLoaderProtocol) {
        self.ownerName = ownerName
        self.repositoryName = repositoryName
        self.stargazersSerivce = stargazersService
        self.imageLoader = imageLoader
    }
    
    //MARK: Methods
    
    ///  Loads stargazers for a given repository using stargazers service
    func fetchStargazers() async {
        guard !isLoading, hasMorePages else { return }
        
        isLoading = true
        
        Task {
            do {
                let loadedStargazers = try await stargazersSerivce.fetchStargazers(
                    owner: ownerName.trimmingCharacters(in: .whitespacesAndNewlines),
                    repository: repositoryName.trimmingCharacters(in: .whitespacesAndNewlines),
                    page: currentPage)
                
                DispatchQueue.main.async { [weak self] in
                    self?.stargazers.append(contentsOf: loadedStargazers)
                    self?.currentPage += 1
                    self?.hasMorePages = !loadedStargazers.isEmpty
                    self?.isLoading = false
                }
            } catch let error as StargazersError {
                DispatchQueue.main.async { [weak self] in
                    self?.onError?(error.localizedMessage)
                    self?.isLoading = false
                }
            }
        }
    }
    
    
    /// Loads the avatar of the user
    /// - Parameter imageURL: the URL to load the image
    /// - Returns: loaded image or a default image in case of loading failure
    func loadImage(from imageURL: String) async -> UIImage {
        if let image = await imageLoader.loadImage(from: imageURL) {
            return image
        } else {
            return UIImage(systemName: "person.circle") ?? UIImage()
        }
    }
    
}
