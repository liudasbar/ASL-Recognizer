import UIKit

protocol MainPresentationLogic {
    func presentRequestCameraAuthorization(_ response: Main.RequestCameraAuthorization.Response)
}

protocol MainPresenter: MainPresentationLogic {
    var displayLogic: MainDisplayLogic! { get set }
}

class DefaultMainPresenter: MainPresenter {
    weak var displayLogic: MainDisplayLogic!
}

// MARK: - Presentation Logic
extension DefaultMainPresenter {
    // MARK: - Load Request Camera Authorization
    func presentRequestCameraAuthorization(_ response: Main.RequestCameraAuthorization.Response) {
        let viewModel: Main.RequestCameraAuthorization.ViewModel
        viewModel = .status(response.cameraStatus, response.previewLayer)
        mainAsync(execute: { [weak self] in
            self?.displayLogic.displayRequestCameraAuthorization(viewModel)
        })
    }
}
