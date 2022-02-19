import Foundation
import Combine
import CoreML
import AVFoundation

protocol MainWorker {
    func requestCameraAuthorization() -> (CameraStatus, AVCaptureVideoPreviewLayer?)
}

class DefaultMainWorker: MainWorker {
    func loadMLModel() {
//        let url = try! MLModel.compileModel(at: URL(fileURLWithPath: model))
//        visionModel = try! VNCoreMLModel(for: MLModel(contentsOf: url))
        let model = ASLHandPoseClassifier16_2()
        
    }
    
    func requestCameraAuthorization() -> (CameraStatus, AVCaptureVideoPreviewLayer?) {
        let avCapture: AVCapture = AVCapture()
        var cameraStatus: CameraStatus = .notAllowed
        var previewLayer: AVCaptureVideoPreviewLayer?
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            if let avSessionPreviewLayer = avCapture.createAVSessionPreviewLayer() {
                cameraStatus = .allowed
                previewLayer = avSessionPreviewLayer
            } else {
                cameraStatus = .unknownFailure
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else {
                    cameraStatus = .notAllowed
                    return
                }
                cameraStatus = .allowed
                if let avSessionPreviewLayer = avCapture.createAVSessionPreviewLayer() {
                    previewLayer = avSessionPreviewLayer
                }
            }
        case .denied:
            cameraStatus = .notAllowed
        case .restricted:
            cameraStatus = .notAllowed
        @unknown default:
            cameraStatus = .unknownFailure
        }
        return (cameraStatus, previewLayer)
    }
}
