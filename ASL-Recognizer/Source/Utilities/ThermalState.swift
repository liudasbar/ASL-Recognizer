import Foundation
import Combine

enum ThermalStateCondition {
    case canContinue
    case canNotContinue
}

protocol ThermalState {
    func registerForThermalNotifications() -> AnyPublisher<ThermalStateCondition, Never>
}

class ThermalStateManager: ThermalState {
    func registerForThermalNotifications() -> AnyPublisher<ThermalStateCondition, Never> {
        NotificationCenter
            .Publisher(center: .default, name: ProcessInfo.thermalStateDidChangeNotification)
            .flatMap({ [weak self] notification -> AnyPublisher<ThermalStateCondition, Never> in
                print(notification)
                guard let responseToHeat = self?.responseToHeat(notification) else {
                    return .just(.canNotContinue)
                }
                return responseToHeat
            })
            .eraseToAnyPublisher()
    }
    
    private func responseToHeat(_ notification: Notification) -> AnyPublisher<ThermalStateCondition, Never> {
        let state = ProcessInfo.processInfo.thermalState
        switch state {
        case .nominal:
            return .just(.canContinue)
        case .fair:
            return .just(.canContinue)
        case .serious:
            return .just(.canContinue)
        case .critical:
            return .just(.canNotContinue)
        @unknown default:
            return .just(.canNotContinue)
        }
    }
}
