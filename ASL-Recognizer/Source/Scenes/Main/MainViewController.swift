import UIKit

protocol MainDisplayLogic: AnyObject {
    func displayRequestCameraAuthorization(_ viewModel: Main.RequestCameraAuthorization.ViewModel)
}

class MainViewController: UIViewController {
    // MARK: - Views
    private lazy var rootView = MainViews.RootView()

    // MARK: - Variables
    private let interactor: MainInteractor
    private let router: MainRouter

    // MARK: - Life Cycle
    init(interactor: MainInteractor, router: MainRouter) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        rootView.setupCamera()
//        interactor.requestCameraAuthorization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupActions()
    }

    // MARK: - Setup
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
    
    private func setupActions() {
        rootView.setupOpenSettingsActionHandler { [weak self] in
            self?.openAppSettings()
        }
    }
    
    // MARK: - Actions
    private func start() {
        router.routeToSomewhere()
    }
    
    private func openAppSettings() {
        let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsUrl)
    }
}

// MARK: - Display Logic
extension MainViewController: MainDisplayLogic {
    // MARK: - Load Camera Authorization Status and Preview Layer
    func displayRequestCameraAuthorization(_ viewModel: Main.RequestCameraAuthorization.ViewModel) {
        switch viewModel {
        case .status:
            ()
//            rootView.updateViewBasedOnCameraAuthorizationStatus(viewModel)
        }
    }
}
