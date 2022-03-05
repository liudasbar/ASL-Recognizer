import UIKit
import AVFoundation
import Vision

protocol AVCapture {
    func createAVSessionPreviewLayer(shouldAddDeviceInput: Bool,
                                     setupFailureReason: @escaping(AVCaptureFailureReason) -> Void,
                                     previewLayerValue: @escaping(AVCaptureVideoPreviewLayer) -> Void)
    func startAVCapture()
    func stopAVCapture()
}

class AVCaptureManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapture {
    // MARK: - Variables
    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    var deviceInput: AVCaptureDeviceInput!
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
    var captureOutputHandler: ((CMSampleBuffer) -> Void)?
    
    // MARK: - Methods
    init(captureOutputHandler: @escaping (CMSampleBuffer) -> Void) {
        self.captureOutputHandler = captureOutputHandler
    }
    
    private func setupAVCapture(shouldAddDeviceInput: Bool, completion: @escaping (AVCaptureFailureReason?) -> Void) {
        guard let videoDevice = videoDevice else {
            completion(.noCameraDeviceFound)
            return
        }
        
        guard shouldAddDeviceInput else {
            completion(nil)
            return
        }
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch {
            completion(.couldNotCreateVideoDeviceInput)
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
            try videoDevice.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice.activeFormat.formatDescription))
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice.unlockForConfiguration()
        } catch {
            completion(.failedVideoCaptureLockForConfiguration)
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
//        print("frame dropped")
    }
}

extension AVCaptureManager {
    func createAVSessionPreviewLayer(shouldAddDeviceInput: Bool,
                                     setupFailureReason: @escaping(AVCaptureFailureReason) -> Void,
                                     previewLayerValue: @escaping(AVCaptureVideoPreviewLayer) -> Void) {
        setupAVCapture(shouldAddDeviceInput: shouldAddDeviceInput, completion: { [weak self] error in
            guard shouldAddDeviceInput else {
                if let previewLayer = self?.previewLayer {
                    previewLayerValue(previewLayer)
                } else {
                    setupFailureReason(.noPreviewLayerAvailable)
                }
                return
            }
            if let error = error {
                setupFailureReason(error)
                return
            }
            self?.setupCaptureVideoPreviewLayer()
            guard let previewLayer = self?.previewLayer else {
                setupFailureReason(.noPreviewLayerAvailable)
                return
            }
            previewLayerValue(previewLayer)
            self?.session.startRunning()
        })
    }
    
    public func startAVCapture() {
        session.startRunning()
    }
    
    public func stopAVCapture() {
        session.stopRunning()
    }
}

extension AVCaptureManager {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        captureOutputHandler?(sampleBuffer)
    }
}
