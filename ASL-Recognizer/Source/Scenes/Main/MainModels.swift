import UIKit
import AVFoundation
import Vision

enum Main {
    struct LoadRecognitionResult {
        struct Request {
            let sampleBuffer: CMSampleBuffer
        }
        struct Response {
            let resultValue: String
            let confidence: VNConfidence
            let error: CustomError?
        }
        enum ViewModel {
            case result(resultValue: String, confidence: VNConfidence)
            case error(_ error: CustomError)
        }
    }
    
    struct RequestCameraAuthorization {
        struct Response {
            let cameraStatus: CameraStatus
            let previewLayer: AVCaptureVideoPreviewLayer?
        }
        enum ViewModel {
            case status(CameraStatus, AVCaptureVideoPreviewLayer?)
        }
    }
}
