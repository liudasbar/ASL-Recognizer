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
    private let handPoseRequest: VNDetectHumanHandPoseRequest = {
      let request = VNDetectHumanHandPoseRequest()
      request.maximumHandCount = 1
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
        session.sessionPreset = .vga640x480
        
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
        
        let model = ASLHandPoseClassifier16_2()
        let multiarray: MLMultiArray
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
        do {
            try handler.perform([handPoseRequest])
            guard let observation = handPoseRequest.results?.first else {
                return
            }
            
            multiarray = try observation.keypointsMultiArray()
            
            let result = try? model.prediction(poses: multiarray)
            
            print("--------")
            print(result?.featureNames)
            print(result?.label)
            print(result?.labelProbabilities)
            
        } catch {
            print(error)
        }
        
        
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
        
//        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
//        do {
//            try handler.perform([handPoseRequest])
//            guard let results = handPoseRequest.results?.prefix(2), !results.isEmpty else {
//                return
//            }
//            print(results)
//        } catch {
//            stopAVCapture()
//        }
        
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { fatalError("pixel buffer is nil") }
//        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
//        let context = CIContext(options: nil)
//
//        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { fatalError("cg image") }
//        let uiImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .leftMirrored)
        
       
        
//        print(model.prediction(poses: preprocess(image: uiImage) ?? MLMultiArray()))
        
//        let model = try! VNCoreMLModel(for: ASLHandPoseClassifier16_2().model)
//        let request = VNCoreMLRequest(model: model, completionHandler: results)
//        let handler = VNSequenceRequestHandler()
//        try! handler.perform([request], on: uiImage)
        
//        guard let array = try? MLMultiArray(shape: [1, 3, 21], dataType: .float32) else {
//            return
//        }
        
        
//        guard let marsHabitatPricerOutput = try? model.prediction(poses: uiImage.pixelBuffer()!) else {
//            fatalError("Unexpected runtime error.")
//        }
//        print(marsHabitatPricerOutput)
        
        
        
//        let error: NSError! = nil
//        var requests = [VNRequest]()
//
//        do {
//            let visionModel = try VNCoreMLModel(for: ASLHandPoseClassifier16_2().model)
//            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
//                DispatchQueue.main.async(execute: {
//                    // perform all the UI updates on the main queue
//                    if let results = request.results {
//                        print(results)
//                    }
//                })
//            })
//            requests = [objectRecognition]
//            print(requests)
//        } catch let error as NSError {
//            print("Model loading went wrong: \(error)")
//        }
        
//            let imageConstraint = model.model.modelDescription
//                .inputDescriptionsByName["image"]!
//                .imageConstraint!
//
//            let imageOptions: [MLFeatureValue.ImageOption: Any] = [
//                .cropAndScale: VNImageCropAndScaleOption.scaleFill.rawValue
//            ]
//            let imagePublisher = PassthroughSubject<UIImage, Never>()
//
//            imagePublisher
//                .compactMap { image in
//                    try? MLFeatureValue(cgImage: image.cgImage!,
//                                        orientation: .up,
//                                        constraint: imageConstraint,
//                                        options: imageOptions)
//                }
//                .map { featureValue in
//                    ASLHandPoseClassifier16_2Input(image: featureValue.imageBufferValue!)
//                }
//                .prediction(model: squeezeNet.model)
//                .compactMap { try? $0.get() }
//                .map { SqueezeNetFP16Output(features: $0) }
//                .map { $0.classLabelProbs.sorted { $0.value > $1.value }.prefix(5) }
//                .sink(receiveCompletion: { completion in
//                    print("Received completion event")
//                }, receiveValue: { value in
//                    print("Received value:", value)
//                    /* do something with the predicted value here */
//                })
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

extension UIImage {
    func pixelData() -> [UInt8]? {
            let dataSize = size.width * size.height * 4
            var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: &pixelData, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 4 * Int(size.width), space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)

            guard let cgImage = self.cgImage else { return nil }
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

            return pixelData
        }
    
    func resize(to newSize: CGSize) -> UIImage? {

        guard self.size != newSize else { return self }

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))

        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func pixelBuffer() -> CVPixelBuffer? {

        let width = Int(self.size.width)
        let height = Int(self.size.height)

        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
            return nil
        }

        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }
}
