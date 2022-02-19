import UIKit
import AVFoundation

extension MainViews {
    class RootView: UIView {
        // MARK: - Views
        private lazy var cameraView: UIView = {
            return makeDefaultView(config: Config(backgroundColor: activeTheme.colors.text))
        }()
        private lazy var statusLabel: UILabel = {
            let label = UILabel.defaultLabel(config: UILabel.Config(
                title: "",
                textColor: activeTheme.colors.blank,
                textAlignment: .center,
                font: activeTheme.fonts.regular
            ))
            return label
        }()
        private lazy var startButton: UIButton = {
            let button = UIButton()
            button.setTitle("START", for: .normal)
            button.setTitleColor(.red, for: .normal)
            button.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
            return button
        }()
        private lazy var resultView: ResultView = {
            let view = ResultView()
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 12
            return view
        }()
        
        // MARK: - Variables
        private let avCapture: AVCapture = AVCapture()
        
        private var startButtonHandler: (() -> Void)?

        // MARK: - Life Cycle
        init() {
            super.init(frame: .zero)
            setupViews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Setup
        private func setupViews() {
            backgroundColor = activeTheme.colors.text
            setupTitleLabel()
            setupResultView()
        }
        
        func setupCamera() {
            setupCameraView()
            cameraView.layoutIfNeeded()
            requestCameraAuthorization()
            sendSubviewToBack(cameraView)
//            bringSubviewToFront(statusLabel)
//            bringSubviewToFront(resultView)
        }
        
        private func setupCameraView() {
            addSubview(cameraView)
            cameraView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                cameraView.topAnchor.constraint(equalTo: topAnchor),
                cameraView.leadingAnchor.constraint(equalTo: leadingAnchor),
                cameraView.trailingAnchor.constraint(equalTo: trailingAnchor),
                cameraView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        func setupPreviewLayer(_ previewLayer: AVCaptureVideoPreviewLayer) {
            previewLayer.frame = cameraView.bounds
            cameraView.layer.addSublayer(previewLayer)
        }
        
        private func setupTitleLabel() {
            addSubview(statusLabel)
            statusLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
                statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
        }
        
        private func setupResultView() {
            addSubview(resultView)
            resultView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                resultView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -60),
                resultView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
                resultView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                resultView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
        }
        
//        private func setupStartButton() {
//            addSubview(startButton)
//            NSLayoutConstraint.activate([
//                startButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
//                startButton.centerXAnchor.constraint(equalTo: centerXAnchor)
//            ])
//        }
        
        func setupStartButtonHandler(_ handler: @escaping () -> Void) {
            startButtonHandler = handler
        }

        // MARK: - Populate
        func populate(_ viewModel: Main.LoadGreeting.ViewModel) {
            guard case let .greeting(text) = viewModel else {
                return
            }
        }
        
        // MARK: - Actions
        @objc private func startButtonAction() {
            startButtonHandler?()
        }
        
        public func requestCameraAuthorization() {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                if let previewLayer = self.avCapture.createAVSessionPreviewLayer() {
                    self.setCameraStatusLabelBasedOn(cameraStatus: .allowed)
                    setupPreviewLayer(previewLayer)
                } else {
                    self.setCameraStatusLabelBasedOn(cameraStatus: .unknownFailure)
                }
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    guard granted else {
                        self.setCameraStatusLabelBasedOn(cameraStatus: .notAllowed)
                        return
                    }
                    self.setCameraStatusLabelBasedOn(cameraStatus: .allowed)
                    if let previewLayer = self.avCapture.createAVSessionPreviewLayer() {
                        self.setupPreviewLayer(previewLayer)
                    }
                }
            case .denied:
                self.setCameraStatusLabelBasedOn(cameraStatus: .notAllowed)
            case .restricted:
                self.setCameraStatusLabelBasedOn(cameraStatus: .notAllowed)
            @unknown default:
                self.setCameraStatusLabelBasedOn(cameraStatus: .unknownFailure)
            }
        }
        
        private func setCameraStatusLabelBasedOn(cameraStatus: CameraStatus) {
            mainAsync(execute: {
                self.statusLabel.layer.opacity = 1
                switch cameraStatus {
                case .shouldRequest:
                    self.statusLabel.text = L10n.Main.Status.CameraStatus.shouldRequest
                case .loading:
                    self.statusLabel.text = L10n.Main.Status.CameraStatus.checking
                case .allowed:
                    self.statusLabel.layer.opacity = 0
                    self.statusLabel.text = ""
                case .notAllowed:
                    self.statusLabel.text = L10n.Main.Status.CameraStatus.notAllowed
                case .unknownFailure:
                    self.statusLabel.text = L10n.Main.Status.CameraStatus.unknownFailure
                }
            })
        }
    }
}
