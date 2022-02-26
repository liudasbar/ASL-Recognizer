import UIKit

protocol HandPosesRoutingLogic {
    var viewController: UIViewController! { get set }

    func routeToSomewhere()
}

protocol HandPosesRouter: HandPosesRoutingLogic { }

class DefaultHandPosesRouter: HandPosesRouter {
    weak var viewController: UIViewController!
}

// MARK: - Routing Logic
extension DefaultHandPosesRouter: HandPosesRoutingLogic {
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
