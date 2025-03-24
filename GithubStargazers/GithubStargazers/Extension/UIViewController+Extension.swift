
import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("okActionTitle", comment: ""), style: .default)
        alert.addAction(action)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.present(alert, animated: true)
        }
    }
}
