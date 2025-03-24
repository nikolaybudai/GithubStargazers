
import Foundation

//MARK: - Protocol
protocol SearchViewModelProtocol {
    var repositoryName: String? { get set }
    var ownerName: String? { get set }
    
    func isInputValid(ownerName: String?, repositoryName: String?) -> Bool
}

//MARK: - SearchViewModel
final class SearchViewModel: SearchViewModelProtocol {
    
    var repositoryName: String?
    var ownerName: String?
    
    //MARK: Methods
    
    /// Checks the validity of the input
    /// - Parameters:
    ///   - ownerName: the login (username) of the repository owner
    ///   - repositoryName: the name of the repository
    /// - Returns: true if the text fields are not empty, false otherwise
    func isInputValid(ownerName: String?, repositoryName: String?) -> Bool {
        guard let ownerName = ownerName?.trimmingCharacters(in: .whitespacesAndNewlines),
              let repositoryName = repositoryName?.trimmingCharacters(in: .whitespacesAndNewlines),
              !ownerName.isEmpty, !repositoryName.isEmpty
        else {
                return false
        }
        
        return true
    }
    
}
