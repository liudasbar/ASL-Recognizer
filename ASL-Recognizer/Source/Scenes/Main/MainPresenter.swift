import UIKit

protocol MainPresentationLogic {
    func presentLoadRecognitionResult(_ response: Main.LoadRecognitionResult.Response)
}

protocol MainPresenter: MainPresentationLogic {
    var displayLogic: MainDisplayLogic! { get set }
}

class DefaultMainPresenter: MainPresenter {
    weak var displayLogic: MainDisplayLogic!
}

// MARK: - Presentation Logic
extension DefaultMainPresenter {
    // MARK: - Load Recognition Result
    func presentLoadRecognitionResult(_ response: Main.LoadRecognitionResult.Response) {
        let viewModel: Main.LoadRecognitionResult.ViewModel
        if let error = response.error {
            viewModel = .error(error)
        } else {
            viewModel = .result(resultValue: response.resultValue, confidence: response.confidence)
        }
        mainAsync { [weak self] in
            self?.displayLogic.displayLoadRecognitionResult(viewModel)
        }
    }
}
