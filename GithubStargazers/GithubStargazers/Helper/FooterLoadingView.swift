
import UIKit

/// Footer view with the activity indicator to show loading in the TableView while scrolling
final class FooterLoadingView: UIView {
    
    static let identifier = "FooterLoadingView"

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(spinner)
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    //MARK: Methods
    public func startAnimating() {
        spinner.startAnimating()
        isHidden = false
    }
    
    public func stopAnimating() {
        spinner.stopAnimating()
        isHidden = true
    }
    
    //MARK: Constraints
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
