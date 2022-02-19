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
        }
        
        func setupCamera() {
            setupCameraView()
            cameraView.layoutIfNeeded()
            requestCameraAuthorization()
            bringSubviewToFront(statusLabel)
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




class AVCapture: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    
    private func setupAVCapture(completion: @escaping (AVCaptureFailureReason?) -> Void) {
        var deviceInput: AVCaptureDeviceInput
        let videoDataOutput = AVCaptureVideoDataOutput()
        var bufferSize: CGSize = .zero
        let videoDataOutputQueue = DispatchQueue(
            label: "VideoDataOutput",
            qos: .userInitiated,
            attributes: [],
            autoreleaseFrequency: .workItem
        )
        let videoDevice = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .back
        ).devices.first
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            completion(.couldNotCreateVideoDeviceInput(error))
            return
        }

        session.beginConfiguration()
        session.sessionPreset = .high
        
        guard session.canAddInput(deviceInput) else {
            completion(.couldNotAddVideoDeviceInputToSession)
            session.commitConfiguration()
            return
        }
        
        session.addInput(deviceInput)
        
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            completion(.couldNotAddVideoDataOutputToSession)
            session.commitConfiguration()
            return
        }
        
        let captureConnection = videoDataOutput.connection(with: .video)
        captureConnection?.isEnabled = true
        
        do {
            try videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice!.unlockForConfiguration()
        } catch {
            completion(.failedVideoCaptureLockForConfiguration(error))
            return
        }
        
        session.commitConfiguration()
        completion(nil)
    }
    
    private func setupCaptureVideoPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput,
                       didDrop didDropSampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        print("frame dropped")
    }
    
    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case .portraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = .left
        case .landscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case .landscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case .portrait:            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//            guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
//            let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
//                guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
//                guard let Observation = results.first else { return }
//                
//                DispatchQueue.main.async(execute: {
//                    self.label.text = "\(Observation.identifier)"
//                })
//            }
//            guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//            
//            // executes request
//            try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        }
    
    public func createAVSessionPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        setupAVCapture(completion: { error in
            guard error != nil else {
                return
            }
        })
        setupCaptureVideoPreviewLayer()
        startCaptureSession()
        return previewLayer
    }
    
    public func startCaptureSession() {
        session.startRunning()
    }
    
    public func stopAVCapture() {
        previewLayer.removeFromSuperlayer()
        previewLayer = nil
    }
}
