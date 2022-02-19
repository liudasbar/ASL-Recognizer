import Foundation

enum CustomError: Error {
    case generic
    case genericWith(_ localizedDescription: Error)
 }

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .generic:
            return "Generic"
        case .genericWith(let error):
            return error.localizedDescription
        default:
            return "Unknown: \(self.localizedDescription)"
        }
    }
}
