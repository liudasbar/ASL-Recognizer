enum AVCaptureFailureReason {
    case noCameraDeviceFound
    case couldNotCreateVideoDeviceInput
    case couldNotAddVideoDeviceInputToSession
    case couldNotAddVideoDataOutputToSession
    case failedVideoCaptureLockForConfiguration
    case noPreviewLayerAvailable
    
    var localizedError: String {
        switch self {
        case .noCameraDeviceFound:
            return L10n.AVCaptureFailure.noCameraDeviceFound
        case .couldNotCreateVideoDeviceInput:
            return L10n.AVCaptureFailure.couldNotCreateVideoDeviceInput
        case .couldNotAddVideoDeviceInputToSession:
            return L10n.AVCaptureFailure.couldNotAddVideoDeviceInputToSession
        case .couldNotAddVideoDataOutputToSession:
            return L10n.AVCaptureFailure.couldNotAddVideoDataOutputToSession
        case .failedVideoCaptureLockForConfiguration:
            return L10n.AVCaptureFailure.failedVideoCaptureLockForConfiguration
        case .noPreviewLayerAvailable:
            return L10n.AVCaptureFailure.noPreviewLayerAvailable
        }
    }
}
