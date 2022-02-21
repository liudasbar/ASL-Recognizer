import Combine

extension AnyPublisher {
    public static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        return Just(output)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
    
    public static func empty() -> AnyPublisher<Output, Failure> {
        return Empty(outputType: Output.self, failureType: Failure.self)
            .eraseToAnyPublisher()
    }
    
    public static func fail(_ error: Failure) -> AnyPublisher<Output, Failure> {
        return Fail(error: error)
            .eraseToAnyPublisher()
    }
    
    public func mapToVoid() -> Publishers.Map<AnyPublisher<Output, Failure>, Void> {
        return map({ _ in () })
    }
    
    public func mapTo(_ output: Output) -> Publishers.Map<AnyPublisher<Output, Failure>, Output> {
        return map({ _ in output })
    }
}
