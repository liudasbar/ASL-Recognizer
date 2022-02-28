import Foundation

class HandPosesConfigurator {
    class func configure() -> HandPosesViewController {
        let worker = DefaultHandPosesWorker()
        let viewController = HandPosesViewController()
        return viewController
    }
}
