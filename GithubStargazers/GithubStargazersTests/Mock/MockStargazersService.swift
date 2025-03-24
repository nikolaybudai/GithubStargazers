
@testable import protocol GithubStargazers.StargazersServiceProtocol
@testable import struct GithubStargazers.Stargazer
@testable import enum GithubStargazers.StargazersError

final class MockStargazersService: StargazersServiceProtocol {
    var fetchStargazersCalled = false
    var fetchStargazersParameters: (owner: String, repository: String, page: Int)?
    var fetchStargazersResult: Result<[Stargazer], StargazersError> = .success([])

    func fetchStargazers(owner: String, repository: String, page: Int) async throws -> [Stargazer] {
        fetchStargazersCalled = true
        fetchStargazersParameters = (owner, repository, page)

        switch fetchStargazersResult {
        case .success(let stargazers):
            return stargazers
        case .failure(let error):
            throw error
        }
    }
}
