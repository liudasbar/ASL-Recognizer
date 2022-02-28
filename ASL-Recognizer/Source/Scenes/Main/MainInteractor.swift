import Foundation
import AVFoundation

protocol MainBusinessLogic {
    func loadResult(_ request: Main.LoadRecognitionResult.Request)
}

protocol MainInteractor: MainBusinessLogic {
    var presenter: MainPresentationLogic! { get set }
}

class DefaultMainInteractor: MainInteractor {
    private let worker: MainWorker
    var presenter: MainPresentationLogic!

    // MARK: - Methods
    init(worker: MainWorker) {
        self.worker = worker
    }
}

extension DefaultMainInteractor {
    // MARK: - Load Recognition Result
    func loadResult(_ request: Main.LoadRecognitionResult.Request) {
        worker.loadResult(sampleBuffer: request.sampleBuffer)
        worker.setupResultHandler { [weak self] value, confidence, error in
            self?.presenter.presentLoadRecognitionResult(Main.LoadRecognitionResult.Response(resultValue: value, confidence: confidence, error: error))
        }
    }
}
