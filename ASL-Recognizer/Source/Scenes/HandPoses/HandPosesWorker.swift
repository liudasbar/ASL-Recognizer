import Foundation
import Combine

protocol HandPosesWorker {
    func loadUserName() -> AnyPublisher<String, Error>
}

class DefaultHandPosesWorker: HandPosesWorker {
    func loadUserName() -> AnyPublisher<String, Error> {
        Just("John Ive")
            .setFailureType(to: Error.self)
            .delay(for: 3, scheduler: RunLoop.current)
            .eraseToAnyPublisher()
    }
}
