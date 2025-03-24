
import UIKit
@testable import protocol GithubStargazers.ImageLoaderProtocol

// MARK: - Mock Image Loader
final class MockImageLoader: ImageLoaderProtocol {
    var loadImageCalled = false
    var loadImageParameter: String?
    var loadImageResult: UIImage?

    func loadImage(from urlString: String) async -> UIImage? {
        loadImageCalled = true
        loadImageParameter = urlString
        return loadImageResult
    }
}
