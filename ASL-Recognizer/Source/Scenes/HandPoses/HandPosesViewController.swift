import UIKit

class HandPosesViewController: UIViewController {
    // MARK: - Views
    private lazy var rootView = HandPosesViews.RootView()

    // MARK: - Life Cycle
    init() {
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
        navigationController.navigationBar.tintColor = activeTheme.colors.buttonDefault
        navigationController.navigationBar.isHidden = false
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
}
