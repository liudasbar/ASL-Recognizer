import UIKit
import AVFoundation
import Vision
import Combine

class AVCapture: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
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
    
    init(_ captureOutputHandler: @escaping (CMSampleBuffer) -> Void) {
        self.captureOutputHandler = captureOutputHandler
    }
    private func setupAVCapture(completion: @escaping (AVCaptureFailureReason?) -> Void) {
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
//        print("frame dropped")
    }
}

// MARK: - Public Methods
extension AVCapture {
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

extension AVCapture {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        captureOutputHandler?(sampleBuffer)
    }
}
