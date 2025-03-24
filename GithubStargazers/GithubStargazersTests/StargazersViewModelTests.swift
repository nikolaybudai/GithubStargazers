
import XCTest
@testable import GithubStargazers

final class StargazersViewModelTests: XCTestCase {

    var viewModel: StargazersViewModel!
    var mockStargazersService: MockStargazersService!
    var mockImageLoader: MockImageLoader!

    override func setUp() {
        super.setUp()
        mockStargazersService = MockStargazersService()
        mockImageLoader = MockImageLoader()
        viewModel = StargazersViewModel(
            ownerName: "testName",
            repositoryName: "testRepo",
            stargazersService: mockStargazersService,
            imageLoader: mockImageLoader
        )
    }

    override func tearDown() {
        viewModel = nil
        mockStargazersService = nil
        mockImageLoader = nil
        super.tearDown()
    }

    func test_fetchStargazers_CallsServiceMethod() async {
        let expectation = XCTestExpectation(description: "fetchStargazers completes")

        viewModel.onStargazersFetched = {
            expectation.fulfill()
        }

        await viewModel.fetchStargazers()

        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertTrue(mockStargazersService.fetchStargazersCalled, "fetchStargazers should be called")
        XCTAssertEqual(mockStargazersService.fetchStargazersParameters?.owner, "testName", "Owner name should match")
        XCTAssertEqual(mockStargazersService.fetchStargazersParameters?.repository, "testRepo", "Repository name should match")
        XCTAssertEqual(mockStargazersService.fetchStargazersParameters?.page, 1, "Page should start at 1")
    }
    
    func test_fetchStargazers_ErrorHandling() async {
        let errorMessage = NSLocalizedString(StargazersError.requestFailed.rawValue, comment: "") 
        mockStargazersService.fetchStargazersResult = .failure(.requestFailed)

        let expectation = XCTestExpectation(description: "onError callback should be called")

        viewModel.onError = { error in
            XCTAssertEqual(error, errorMessage, "Error message should match")
            expectation.fulfill()
        }

        await viewModel.fetchStargazers()

        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after an error occurs")
    }
    
    func test_fetchStargazers_ReturnsEarly_WhenIsLoadingIsTrue() async {
        viewModel.isLoading = true

        await viewModel.fetchStargazers()

        XCTAssertFalse(mockStargazersService.fetchStargazersCalled, "fetchStargazers should not be called when isLoading is true")
    }
    
    func test_fetchStargazers_ReturnsEarly_WhenHasMorePagesIsFalse() async {
        viewModel.hasMorePages = false

        await viewModel.fetchStargazers()

        XCTAssertFalse(mockStargazersService.fetchStargazersCalled, "fetchStargazers should not be called when hasMorePages is false")
    }

    func test_fetchStargazers_LoadingState() async {
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false initially")

        let expectation = XCTestExpectation(description: "fetchStargazers completes")

        viewModel.onStargazersFetched = {
            expectation.fulfill()
        }

        await viewModel.fetchStargazers()

        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after fetching")
    }

    func test_loadImage_CallsImageLoaderMethod() async {
        let testURL = "https://example.com/avatar1"

        _ = await viewModel.loadImage(from: testURL)

        XCTAssertTrue(mockImageLoader.loadImageCalled, "loadImage should be called")
        XCTAssertEqual(mockImageLoader.loadImageParameter, testURL, "Image URL should match")
    }
    
    func test_loadImage_ReturnsImage_WhenLoadingSucceeds() async {
        let testURL = "https://example.com/avatar1"
        let testImage = UIImage(systemName: "person.circle")!
        mockImageLoader.loadImageResult = testImage

        let image = await viewModel.loadImage(from: testURL)

        XCTAssertTrue(mockImageLoader.loadImageCalled, "loadImage should be called")
        XCTAssertEqual(mockImageLoader.loadImageParameter, testURL, "Image URL should match")
        XCTAssertEqual(image, testImage, "Loaded image should match the mock result")
    }
    
    func test_loadImage_ReturnsDefaultImage_WhenLoadingFails() async {
        let testURL = "https://example.com/avatar1"
        mockImageLoader.loadImageResult = nil // Simulate a failure to load the image

        let image = await viewModel.loadImage(from: testURL)

        XCTAssertEqual(image, UIImage(systemName: "person.circle"), "Default image should be returned when loading fails")
    }
    
}
