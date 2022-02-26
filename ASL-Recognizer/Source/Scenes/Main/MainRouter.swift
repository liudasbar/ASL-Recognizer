import UIKit

protocol MainRoutingLogic {
    var viewController: UIViewController! { get set }

    func routeToHandPoses()
}

protocol MainRouter: MainRoutingLogic { }

class DefaultMainRouter: MainRouter {
    weak var viewController: UIViewController!
}

// MARK: - Routing Logic
extension DefaultMainRouter: MainRoutingLogic {
    // MARK: - Hand Poses
    func routeToHandPoses() {
        guard let navigationController = viewController.navigationController else {
            return
        }
        let handPosesViewController = HandPosesConfigurator.configure()
        handPosesViewController.title = "Available Hand Poses"
        navigationController.pushViewController(handPosesViewController, animated: true)
    }
}
