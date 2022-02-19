import UIKit

extension UIViewController {
    func setupNavigationControllerItems(navigationController: UINavigationController,
                                        backButtonTitle: String = L10n.Common.Button.back,
                                        rightButtonTitle: String = L10n.Common.Button.continue,
                                        action: Selector) {
        navigationController.visibleViewController?.navigationItem.backButtonTitle = backButtonTitle
        navigationController.visibleViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: rightButtonTitle,
            style: .done,
            target: self,
            action: action
        )
    }
}
