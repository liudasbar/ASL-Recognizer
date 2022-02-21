import UIKit
import AVFoundation

enum Main {
    struct LoadResult {
        struct Request {
            let sampleBuffer: CMSampleBuffer
        }
        struct Response {
            let resultValue: String
        }
        enum ViewModel {
            case result(_ resultValue: String)
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
