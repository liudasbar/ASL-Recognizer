import Foundation

class MainConfigurator {
    class func configure() -> MainViewController {
        let worker = DefaultMainWorker()
        let interactor = DefaultMainInteractor(worker: worker)
        let presenter = DefaultMainPresenter()
        let router = DefaultMainRouter()
        let viewController = MainViewController(interactor: interactor, router: router)
        interactor.presenter = presenter
        presenter.displayLogic = viewController
        router.viewController = viewController
        return viewController
    }
}
