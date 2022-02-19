import Combine
import Foundation

protocol MainBusinessLogic {
    func loadGreeting(_ request: Main.LoadGreeting.Request)
}

protocol MainDataStore {
    var userName: String? { get }
}

protocol MainInteractor: MainBusinessLogic, MainDataStore {
    var presenter: MainPresentationLogic! { get set }
}

class DefaultMainInteractor: MainInteractor {
    private var cancelBag = Set<AnyCancellable>()
    private let worker: MainWorker
    var presenter: MainPresentationLogic!
    private(set) var userName: String?

    // MARK: - Methods
    init(worker: MainWorker) {
        self.worker = worker
    }
}

extension DefaultMainInteractor {
    // MARK: - Load Greeting
    func loadGreeting(_ request: Main.LoadGreeting.Request) {
        presenter.presentLoadGreeting(Main.LoadGreeting.Response(isLoading: true, error: nil, name: nil))
        worker.loadUserName()
            .sink(
                receiveCompletion: { [weak self] in self?.receiveLoadGreetingCompletion($0) },
                receiveValue: { [weak self] in self?.receiveLoadGreetingValue($0) }
            )
            .store(in: &cancelBag)
    }
    
    private func receiveLoadGreetingValue(_ value: String) {
        userName = value
        presenter.presentLoadGreeting(Main.LoadGreeting.Response(isLoading: false, error: nil, name: value))
    }
    
    private func receiveLoadGreetingCompletion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .failure(let error):
            presenter.presentLoadGreeting(Main.LoadGreeting.Response(isLoading: false, error: error, name: nil))
        case .finished:
            ()
        }
    }
}
