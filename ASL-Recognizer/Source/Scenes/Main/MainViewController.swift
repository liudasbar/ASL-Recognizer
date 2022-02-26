import UIKit
import CoreMedia

protocol MainDisplayLogic: AnyObject {
    func displayLoadRecognitionResult(_ viewModel: Main.LoadRecognitionResult.ViewModel)
}

class MainViewController: UIViewController {
    // MARK: - Views
    private lazy var rootView = MainViews.RootView()

    // MARK: - Variables
    private let interactor: MainInteractor
    private let router: MainRouter
    private var shouldDetect: Bool = false

    // MARK: - Life Cycle
    init(interactor: MainInteractor, router: MainRouter) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        rootView.setupCamera()
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
        
        rootView.setupSampleBufferOutputHandler { [weak self] sampleBuffer in
            self?.startDetection(with: sampleBuffer)
        }
        
        rootView.detectStatusView.setupDetectActionHandler { [weak self] in
            self?.shouldDetect = true
        }
        
        rootView.handPosesView.setupOpenHandPosesActionHandler({ [weak self] in
            self?.openHandPoses()
        })
    }
    
    // MARK: - Actions
    private func startDetection(with sampleBuffer: CMSampleBuffer) {
        guard shouldDetect else {
            return
        }
        interactor.loadResult(Main.LoadRecognitionResult.Request(sampleBuffer: sampleBuffer))
        shouldDetect = false
    }
    
    private func openAppSettings() {
        let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsUrl)
    }
    
    private func openHandPoses() {
        rootView.stopCameraCapture()
        router.routeToHandPoses()
    }
}

// MARK: - Display Logic
extension MainViewController: MainDisplayLogic {
    // MARK: - Load Camera Authorization Status and Preview Layer
    func displayLoadRecognitionResult(_ viewModel: Main.LoadRecognitionResult.ViewModel) {
        switch viewModel {
        case let .result(resultValue, confidence):
            rootView.resultView.updateResult(resultValue: resultValue, confidence: confidence)
        case let .error(error):
            rootView.displayAlert(image: error.image!, title: error.errorDescription!)
        }
    }
}
