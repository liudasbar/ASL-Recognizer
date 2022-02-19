import UIKit

protocol MainRoutingLogic {
    var viewController: UIViewController! { get set }

    func routeToSomewhere()
}

protocol MainRouter: MainRoutingLogic { }

class DefaultMainRouter: MainRouter {
    weak var viewController: UIViewController!
}

// MARK: - Routing Logic
extension DefaultMainRouter: MainRoutingLogic {
    // MARK: - Somewhere
    func routeToSomewhere() {
        guard let navigationController = viewController.navigationController else {
            return
        }
        let targetViewController = UIViewController()
        targetViewController.view.backgroundColor = .red
        targetViewController.title = "Somewhere"
        navigationController.pushViewController(targetViewController, animated: true)
    }
}
