import Combine
import Foundation
import AVFoundation

protocol MainBusinessLogic {
    func requestCameraAuthorization()
}

protocol MainInteractor: MainBusinessLogic {
    var presenter: MainPresentationLogic! { get set }
}

class DefaultMainInteractor: MainInteractor {
    private var cancelBag = Set<AnyCancellable>()
    private let worker: MainWorker
    var presenter: MainPresentationLogic!

    // MARK: - Methods
    init(worker: MainWorker) {
        self.worker = worker
    }
}

extension DefaultMainInteractor {
    // MARK: - Request Camera Authorization
    func requestCameraAuthorization() {
        presenter.presentRequestCameraAuthorization(
            Main.RequestCameraAuthorization.Response(
                cameraStatus: worker.requestCameraAuthorization().0,
                previewLayer: worker.requestCameraAuthorization().1
            )
        )
    }
}
