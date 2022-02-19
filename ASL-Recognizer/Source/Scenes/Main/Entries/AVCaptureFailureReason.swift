enum AVCaptureFailureReason {
    case couldNotCreateVideoDeviceInput(_ error: Error)
    case couldNotAddVideoDeviceInputToSession
    case couldNotAddVideoDataOutputToSession
    case failedVideoCaptureLockForConfiguration(_ error: Error)
}
