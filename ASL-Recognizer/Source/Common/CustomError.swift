import Foundation
import UIKit

enum CustomError: Error {
    case generic
    case genericWith(_ error: Error)
    case foundNoHandPose
    case failedToPredictHandPose
 }

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .generic:
            return L10n.Alert.generic
        case .genericWith(let error):
            return L10n.Alert.genericWithError(error.localizedDescription)
        case .foundNoHandPose:
            return L10n.Alert.noHandPoseDetected
        case .failedToPredictHandPose:
            return ""
        }
    }
    
    public var image: UIImage? {
        switch self {
        case .generic,
             .genericWith:
            return nil
        case .foundNoHandPose,
             .failedToPredictHandPose:
            return UIImage(systemName: "exclamationmark.octagon")
        }
    }
}
