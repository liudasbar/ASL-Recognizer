import UIKit

protocol MainPresentationLogic {
    func presentLoadGreeting(_ response: Main.LoadGreeting.Response)
}

protocol MainPresenter: MainPresentationLogic {
    var displayLogic: MainDisplayLogic! { get set }
}

class DefaultMainPresenter: MainPresenter {
    weak var displayLogic: MainDisplayLogic!
}

// MARK: - Presentation Logic
extension DefaultMainPresenter {
    // MARK: - Load Greeting
    func presentLoadGreeting(_ response: Main.LoadGreeting.Response) {
        let viewModel: Main.LoadGreeting.ViewModel
        if let error = response.error {
            viewModel = .error(error)
        } else if response.isLoading {
            viewModel = .loading
        } else if let name = response.name {
            viewModel = .greeting("Hello \(name)!")
        } else {
            viewModel = .error(NSError(domain: "", code: 0))
        }
        DispatchQueue.main.async { [weak self] in
            self?.displayLogic.displayLoadGreeting(viewModel)
        }
    }
}
