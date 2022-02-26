import UIKit
import AVFoundation

extension MainViews {
    class RootView: UIView {
        // MARK: - Views
        private lazy var cameraView: UIView = {
            let view = makeDefaultView(config: Config(backgroundColor: activeTheme.colors.text))
            view.layer.opacity = 0
            return view
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
        
        private lazy var openSettingsButton: UIButton = {
            let button = UIButton()
            button.setTitle(L10n.Main.Button.Settings.open, for: .normal)
            button.titleLabel?.font = activeTheme.fonts.buttonLabel
            button.setTitleColor(activeTheme.colors.buttonDefault, for: .normal)
            button.setTitleColor(activeTheme.colors.buttonDefault.withAlphaComponent(0.7), for: .highlighted)
            button.addTarget(self, action: #selector(openSettingsAction), for: .touchUpInside)
            button.layer.opacity = 0
            return button
        }()
        
        lazy var detectStatusView: DetectStatusView = {
            let view = DetectStatusView()
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 12
            view.layer.opacity = 0
            return view
        }()
        
        lazy var resultView: ResultView = {
            let view = ResultView()
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 12
            view.layer.opacity = 0
            return view
        }()
        
        lazy var alertView: AlertView = {
            let view = AlertView()
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 12
            view.layer.opacity = 0
            return view
        }()
        
        lazy var handPosesView: HandPosesView = {
            let view = HandPosesView()
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 12
            return view
        }()
        
        // MARK: - Variables
        private lazy var avCapture: AVCapture = AVCapture { [weak self] sampleBuffer in
            self?.sampleBufferOutputHandler?(sampleBuffer)
        }
        
        private var openSettingsActionHandler: (() -> Void)?
        private var sampleBufferOutputHandler: ((CMSampleBuffer) -> Void)?

        // MARK: - Life Cycle
        init() {
            super.init(frame: .zero)
            setupViews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Setup
        func setupOpenSettingsActionHandler(_ handler: @escaping () -> Void) {
            openSettingsActionHandler = handler
        }
        
        func setupSampleBufferOutputHandler(_ handler: @escaping (CMSampleBuffer) -> Void) {
            sampleBufferOutputHandler = handler
        }
        
        private func setupViews() {
            backgroundColor = activeTheme.colors.text
            setupStatusLabel()
            setupResultView()
            setupDetectStatusView()
            setupHandPosesView()
            setupAlertView()
            setupOpenSettingsButton()
        }
        
        func setupCamera() {
            setupCameraView()
            cameraView.layoutIfNeeded()
            requestCameraAuthorization()
            sendSubviewToBack(cameraView)
            UIView.animate(withDuration: Constants.defaultAnimationDuration) {
                self.cameraView.layer.opacity = 1
            }
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
        
        private func setupStatusLabel() {
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
                resultView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
                resultView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
                resultView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                resultView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
        }
        
        private func setupDetectStatusView() {
            addSubview(detectStatusView)
            detectStatusView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                detectStatusView.bottomAnchor.constraint(equalTo: resultView.topAnchor, constant: -20),
                detectStatusView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
                detectStatusView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                detectStatusView.widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
            ])
        }
        
        private func setupHandPosesView() {
            addSubview(handPosesView)
            handPosesView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                handPosesView.bottomAnchor.constraint(equalTo: resultView.topAnchor, constant: -20),
                handPosesView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
                handPosesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                handPosesView.widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
            ])
        }
        
        private func setupAlertView() {
            addSubview(alertView)
            alertView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                alertView.centerXAnchor.constraint(equalTo: centerXAnchor),
                alertView.centerYAnchor.constraint(equalTo: centerYAnchor),
                alertView.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
                alertView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
            ])
        }
        
        private func setupOpenSettingsButton() {
            addSubview(openSettingsButton)
            openSettingsButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                openSettingsButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
                openSettingsButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
                openSettingsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                openSettingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
        }

        // MARK: - Actions
        @objc private func openSettingsAction() {
            openSettingsActionHandler?()
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
                    self.statusLabel.text = ""
                    self.statusLabel.layer.opacity = 0
                    self.detectStatusView.layer.opacity = 1
                    self.resultView.layer.opacity = 1
                case .notAllowed:
                    self.statusLabel.text = L10n.Main.Status.CameraStatus.notAllowed
                    self.openSettingsButton.layer.opacity = 1
                case .unknownFailure:
                    self.statusLabel.text = L10n.Main.Status.CameraStatus.unknownFailure
                    self.openSettingsButton.layer.opacity = 1
                }
            })
        }
        
        func displayAlert(image: UIImage, title: String) {
            mainAsync(execute: {
                UIView.animate(withDuration: Constants.defaultAnimationDuration) {
                    self.alertView.layer.opacity = 1
                }
            })
            mainAsyncAfter(deadline: .now() + 1, execute: {
                UIView.animate(withDuration: Constants.defaultAnimationDuration) {
                    self.alertView.layer.opacity = 0
                }
            })
            alertView.updateAlertView(image: image, title: title)
        }
        
        func stopCameraCapture() {
            UIView.animate(withDuration: Constants.defaultAnimationDuration) {
                
            }
            
            UIView.animate(withDuration: Constants.defaultAnimationDuration, delay: 0, options: [], animations: {
                self.cameraView.layer.opacity = 0
            }, completion: { _ in
                self.avCapture.stopAVCapture()
            })
        }
    }
}
