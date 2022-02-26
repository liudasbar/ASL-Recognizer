import UIKit

protocol HandPosesPresentationLogic {
    func presentLoadGreeting(_ response: HandPoses.LoadGreeting.Response)
}

protocol HandPosesPresenter: HandPosesPresentationLogic {
    var displayLogic: HandPosesDisplayLogic! { get set }
}

class DefaultHandPosesPresenter: HandPosesPresenter {
    weak var displayLogic: HandPosesDisplayLogic!
}

// MARK: - Presentation Logic
extension DefaultHandPosesPresenter {
    // MARK: - Load Greeting
    func presentLoadGreeting(_ response: HandPoses.LoadGreeting.Response) {
        let viewModel: HandPoses.LoadGreeting.ViewModel
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
