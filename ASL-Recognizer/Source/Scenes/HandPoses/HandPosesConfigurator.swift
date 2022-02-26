import Foundation

class HandPosesConfigurator {
    class func configure() -> HandPosesViewController {
        let worker = DefaultHandPosesWorker()
        let interactor = DefaultHandPosesInteractor(worker: worker)
        let presenter = DefaultHandPosesPresenter()
        let router = DefaultHandPosesRouter()
        let viewController = HandPosesViewController(interactor: interactor, router: router)
        interactor.presenter = presenter
        presenter.displayLogic = viewController
        router.viewController = viewController
        return viewController
    }
}
