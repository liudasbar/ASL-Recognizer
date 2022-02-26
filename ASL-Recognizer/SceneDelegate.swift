import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else {
            return
        }
        self.window = UIWindow(windowScene: scene)
        // TODO: - Bring back when don't want to show other screens
        let navViewController = UINavigationController(rootViewController: MainConfigurator.configure())
        
        navViewController.navigationBar.prefersLargeTitles = false
        
        // Fix iOS 13 navigation bar background - make it transparent
        navViewController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navViewController.navigationBar.shadowImage = UIImage()
        navViewController.navigationBar.isTranslucent = true
        navViewController.view.backgroundColor = .clear
        
        UIScrollView.appearance().keyboardDismissMode = .onDrag
        
        window?.rootViewController = navViewController
        window?.makeKeyAndVisible()
    }
}

