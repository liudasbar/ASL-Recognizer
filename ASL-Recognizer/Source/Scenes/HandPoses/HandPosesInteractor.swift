import Combine
import Foundation

protocol HandPosesBusinessLogic {
    func loadGreeting(_ request: HandPoses.LoadGreeting.Request)
}

protocol HandPosesDataStore {
    var userName: String? { get }
}

protocol HandPosesInteractor: HandPosesBusinessLogic, HandPosesDataStore {
    var presenter: HandPosesPresentationLogic! { get set }
}

class DefaultHandPosesInteractor: HandPosesInteractor {
    private var cancelBag = Set<AnyCancellable>()
    private let worker: HandPosesWorker
    var presenter: HandPosesPresentationLogic!
    private(set) var userName: String?

    // MARK: - Methods
    init(worker: HandPosesWorker) {
        self.worker = worker
    }
}

extension DefaultHandPosesInteractor {
    // MARK: - Load Greeting
    func loadGreeting(_ request: HandPoses.LoadGreeting.Request) {
        presenter.presentLoadGreeting(HandPoses.LoadGreeting.Response(isLoading: true, error: nil, name: nil))
        worker.loadUserName()
            .sink(
                receiveCompletion: { [weak self] in self?.receiveLoadGreetingCompletion($0) },
                receiveValue: { [weak self] in self?.receiveLoadGreetingValue($0) }
            )
            .store(in: &cancelBag)
    }
    
    private func receiveLoadGreetingValue(_ value: String) {
        userName = value
        presenter.presentLoadGreeting(HandPoses.LoadGreeting.Response(isLoading: false, error: nil, name: value))
    }
    
    private func receiveLoadGreetingCompletion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .failure(let error):
            presenter.presentLoadGreeting(HandPoses.LoadGreeting.Response(isLoading: false, error: error, name: nil))
        case .finished:
            ()
        }
    }
}
