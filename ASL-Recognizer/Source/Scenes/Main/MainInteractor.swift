import Combine
import Foundation
import AVFoundation

protocol MainBusinessLogic {
    func loadResult(_ request: Main.LoadResult.Request)
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
    // MARK: - Load Recognition Result
    func loadResult(_ request: Main.LoadResult.Request) {
        worker.loadResult(sampleBuffer: request.sampleBuffer)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    ()
                case let .failure(error):
                    print(error)
                }
            }, receiveValue: { resultValue in
                print(resultValue)
//                presenter.
            })
            .store(in: &cancelBag)
    }
}
