import UIKit

protocol HandPosesDisplayLogic: AnyObject {
    func displayLoadGreeting(_ viewModel: HandPoses.LoadGreeting.ViewModel)
}

class HandPosesViewController: UIViewController {
    // MARK: - Views
    private lazy var rootView = HandPosesViews.RootView()

    // MARK: - Variables
    private let interactor: HandPosesInteractor
    private let router: HandPosesRouter

    // MARK: - Life Cycle
    init(interactor: HandPosesInteractor, router: HandPosesRouter) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupViews()
    }

    // MARK: - Setup
    private func setupNavigationController() {
        guard let navigationController = navigationController else {
            return
        }
        navigationController.navigationBar.tintColor = activeTheme.colors.blank
        navigationController.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: activeTheme.colors.blank
        ]
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: activeTheme.colors.blank
        ]
    }
    
    private func setupViews() {
        view.addSubview(rootView)
        rootView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: view.topAnchor),
            rootView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            rootView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Actions
    private func start() {
        router.routeToSomewhere()
    }
}

// MARK: - Display Logic
extension HandPosesViewController: HandPosesDisplayLogic {
    // MARK: - Load Greating
    func displayLoadGreeting(_ viewModel: HandPoses.LoadGreeting.ViewModel) {
        switch viewModel {
        case .loading:
            // TODO: Show loading indicator
            ()
        case let .error(error):
            // TODO: Hide loading indicator
            ()
        case .greeting:
            // TODO: Hide loading indicator
            ()
        }
    }
}
