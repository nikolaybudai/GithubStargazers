
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
    
        let searchViewModel = SearchViewModel()
        let searchViewController = SearchViewController(viewModel: searchViewModel)
        
        let navigationController = UINavigationController(rootViewController: searchViewController)
        
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }

}

