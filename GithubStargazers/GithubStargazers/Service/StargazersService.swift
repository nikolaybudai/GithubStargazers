
import Foundation

//MARK: - Protocol
protocol StargazersServiceProtocol {
    func fetchStargazers(owner: String, repository: String, page: Int) async throws -> [Stargazer]
}

//MARK: - StargazersError
enum StargazersError: String, Error {
    
    case invalidURL = "invalidURLErrorMessage"
    case requestFailed = "requestFailedErrorMessage"
    
    var localizedMessage: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

//MARK: - StargazersService

/// Handles the logic of loading stargazers
final class StargazersService: StargazersServiceProtocol {
    
    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()

    /// Loads the stargazers for a given repository
    /// - Parameters:
    ///   - owner: login (username) of the repository owner
    ///   - repository: name of the repository
    ///   - page: number of the page parameter
    /// - Returns: the list of stargazers for a given repository
    func fetchStargazers(owner: String, repository: String, page: Int) async throws -> [Stargazer] {
        let urlString = "https://api.github.com/repos/\(owner)/\(repository)/stargazers?page=\(page)&per_page=30"
        guard let url = URL(string: urlString) else {
            throw StargazersError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw StargazersError.requestFailed
        }

        return try decoder.decode([Stargazer].self, from: data)
    }
}
