import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else {
            return
        }
        self.window = UIWindow(windowScene: scene)
        let navViewController = UINavigationController(rootViewController: MainConfigurator.configure())
        
        navViewController.navigationBar.prefersLargeTitles = true
        navViewController.navigationBar.isTranslucent = false
        navViewController.interactivePopGestureRecognizer?.isEnabled = false
        
        // Fixes iOS 13 navigation bar background - make it transparent
        navViewController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navViewController.navigationBar.shadowImage = UIImage()
        navViewController.navigationBar.isTranslucent = true
        navViewController.view.backgroundColor = .clear
        
        UIScrollView.appearance().keyboardDismissMode = .onDrag
        
        window?.rootViewController = navViewController
        window?.makeKeyAndVisible()
    }
}

