
import XCTest
@testable import GithubStargazers

final class SearchViewModelTests: XCTestCase {

    var viewModel: SearchViewModelProtocol!

    override func setUp() {
        super.setUp()
        viewModel = SearchViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }


    func test_isInputValid_WhenBothInputsAreNonEmpty_ReturnsTrue() {
        // Given
        let ownerName = "testName"
        let repositoryName = "testRepo"

        // When
        let isValid = viewModel.isInputValid(ownerName: ownerName, repositoryName: repositoryName)

        // Then
        XCTAssertTrue(isValid, "Expected true for non-empty owner and repository names")
    }

    func test_isInputValid_WhenOwnerNameIsEmpty_ReturnsFalse() {
        // Given
        let ownerName = ""
        let repositoryName = "testRepo"

        // When
        let isValid = viewModel.isInputValid(ownerName: ownerName, repositoryName: repositoryName)

        // Then
        XCTAssertFalse(isValid, "Expected false for empty owner name")
    }

    func test_isInputValid_WhenRepositoryNameIsEmpty_ReturnsFalse() {
        // Given
        let ownerName = "testName"
        let repositoryName = ""

        // When
        let isValid = viewModel.isInputValid(ownerName: ownerName, repositoryName: repositoryName)

        // Then
        XCTAssertFalse(isValid, "Expected false for empty repository name")
    }

    func test_isInputValid_WhenBothInputsAreEmpty_ReturnsFalse() {
        // Given
        let ownerName = ""
        let repositoryName = ""

        // When
        let isValid = viewModel.isInputValid(ownerName: ownerName, repositoryName: repositoryName)

        // Then
        XCTAssertFalse(isValid, "Expected false for empty owner and repository names")
    }

    func test_isInputValid_WhenOwnerNameIsNil_ReturnsFalse() {
        // Given
        let ownerName: String? = nil
        let repositoryName = "testRepo"

        // When
        let isValid = viewModel.isInputValid(ownerName: ownerName, repositoryName: repositoryName)

        // Then
        XCTAssertFalse(isValid, "Expected false for nil owner name")
    }

    func test_isInputValid_WhenRepositoryNameIsNil_ReturnsFalse() {
        // Given
        let ownerName = "testName"
        let repositoryName: String? = nil

        // When
        let isValid = viewModel.isInputValid(ownerName: ownerName, repositoryName: repositoryName)

        // Then
        XCTAssertFalse(isValid, "Expected false for nil repository name")
    }

    func test_isInputValid_WhenBothInputsAreNil_ReturnsFalse() {
        // Given
        let ownerName: String? = nil
        let repositoryName: String? = nil

        // When
        let isValid = viewModel.isInputValid(ownerName: ownerName, repositoryName: repositoryName)

        // Then
        XCTAssertFalse(isValid, "Expected false for nil owner and repository names")
    }

    func test_isInputValid_WhenInputsContainWhitespace_ReturnsTrue() {
        // Given
        let ownerName = "  testName  "
        let repositoryName = "  testRepo  "

        // When
        let isValid = viewModel.isInputValid(ownerName: ownerName, repositoryName: repositoryName)

        // Then
        XCTAssertTrue(isValid, "Expected true for inputs with leading/trailing whitespace")
    }

    func test_isInputValid_WhenInputsAreOnlyWhitespace_ReturnsFalse() {
        // Given
        let ownerName = "   "
        let repositoryName = "   "

        // When
        let isValid = viewModel.isInputValid(ownerName: ownerName, repositoryName: repositoryName)

        // Then
        XCTAssertFalse(isValid, "Expected false for inputs with only whitespace")
    }
}
