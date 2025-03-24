
import UIKit

//MARK: - Protocol
protocol ImageLoaderProtocol {
    func loadImage(from urlString: String) async -> UIImage?
}

//MARK: - ImageLoader

/// Handles the logic of loading the image
final class ImageLoader: ImageLoaderProtocol {
    
    private let cache = NSCache<NSString, UIImage>()
    private let urlSession = URLSession.shared

    //MARK: Methods
    
    /** Loads an image from the given URL asynchronously
         - Parameters:
           - urlString: The url string to load the image
         - Returns: loaded image or nil in case of error
    */
    func loadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)

        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }

        guard let url = URL(string: urlString) else {
            return nil
        }

        do {
            let (data, _) = try await urlSession.data(from: url)

            if let image = UIImage(data: data) {
                cache.setObject(image, forKey: cacheKey)
                return image
            }
        } catch {
            return nil
        }

        return nil
    }
}
