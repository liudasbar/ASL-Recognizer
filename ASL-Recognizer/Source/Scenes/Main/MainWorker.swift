import Foundation
import Combine

protocol MainWorker {
    func loadUserName() -> AnyPublisher<String, Error>
}

class DefaultMainWorker: MainWorker {
    func loadUserName() -> AnyPublisher<String, Error> {
        Just("John Ive")
            .setFailureType(to: Error.self)
            .delay(for: 3, scheduler: RunLoop.current)
            .eraseToAnyPublisher()
    }
}
