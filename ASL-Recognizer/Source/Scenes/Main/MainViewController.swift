import UIKit
import CoreMedia
import Combine

protocol MainDisplayLogic: AnyObject {
    func displayLoadRecognitionResult(_ viewModel: Main.LoadRecognitionResult.ViewModel)
}

class MainViewController: UIViewController {
    // MARK: - Views
    private lazy var rootView = MainViews.RootView()

    // MARK: - Variables
    private let interactor: MainInteractor
    private let router: MainRouter
    private let thermalState: ThermalState = ThermalStateManager()
    private var cancelBag = Set<AnyCancellable>()
    private var shouldDetect: Bool = false
    private var firstCameraInit: Bool = true

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
        
        setupNavigationController()
        guard firstCameraInit else {
            rootView.setupCamera(cameraAuthorizationNeeded: false)
            return
        }
        rootView.setupCamera(cameraAuthorizationNeeded: true)
        firstCameraInit = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupViews()
        setupActions()
        setupThermalState()
    }

    // MARK: - Setup
    private func setupNavigationController() {
        if let navigationController = navigationController {
            navigationController.navigationBar.isHidden = true
        }
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
        
        rootView.infoView.setupInfoActionHandler { [weak self] in
            self?.displayInfoAlert()
        }
    }
    
    func setupThermalState() {
        thermalState.registerForThermalNotifications()
            .sink { thermalState in
                switch thermalState {
                case .canContinue:
                    self.rootView.dismissAlert(shouldStartAVCapture: true)
                case .canNotContinue:
                    self.rootView.displayAlert(
                        image: UIImage(systemName: "thermometer") ?? UIImage(),
                        title: L10n.Alert.thermalCanNotContinue,
                        dismissAfter: nil,
                        shouldStopAVSession: true
                    )
                }
            }
            .store(in: &cancelBag)
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
        rootView.hideCameraView(stopAVCapture: false)
        router.routeToHandPoses()
    }
    
    private func displayInfoAlert() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        if let appVersion = appVersion, let buildNumber = buildNumber {
            rootView.displayAlert(
                image: UIImage(systemName: "info.circle") ?? UIImage(),
                title: L10n.Main.info(appVersion, buildNumber),
                dismissAfter: Constants.noHandPoseDetectedViewAppearDuration
            )
        } else {
            rootView.displayAlert(
                image: UIImage(systemName: "info.circle") ?? UIImage(),
                title: L10n.Main.info(L10n.Common.notAvailable, L10n.Common.notAvailable),
                dismissAfter: Constants.noHandPoseDetectedViewAppearDuration
            )
        }
    }
    
    private func handleAbnormalThermalState(for condition: ThermalStateCondition) {
        switch condition {
        case .canContinue:
            rootView.requestCameraAuthorization(shouldAddDeviceInput: true)
        case .canNotContinue:
            rootView.displayAlert(
                image: UIImage(systemName: "exclamationmark.octagon") ?? UIImage(),
                title: L10n.ThermalState.warning,
                dismissAfter: Constants.noHandPoseDetectedViewAppearDuration
            )
            rootView.hideCameraView(stopAVCapture: true)
        }
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
            rootView.displayAlert(
                image: error.image!,
                title: error.errorDescription!,
                dismissAfter: Constants.noHandPoseDetectedViewAppearDuration
            )
        }
    }
}
