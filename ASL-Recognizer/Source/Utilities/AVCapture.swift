import UIKit
import AVFoundation
import Vision

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
    private let handPoseRequest: VNDetectHumanHandPoseRequest = {
      // 1
      let request = VNDetectHumanHandPoseRequest()
      
      // 2
      request.maximumHandCount = 2
      return request
    }()
    
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
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
        do {
            try handler.perform([handPoseRequest])
            guard let results = handPoseRequest.results?.prefix(2), !results.isEmpty else {
                return
            }
            print(results)
        } catch {
            stopAVCapture()
        }
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
