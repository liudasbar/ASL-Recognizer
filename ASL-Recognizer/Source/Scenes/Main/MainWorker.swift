import Foundation
import Combine
import Vision
import AVFoundation

protocol MainWorker {
    func loadResult(sampleBuffer: CMSampleBuffer)
    func setupResultHandler(_ handler: @escaping (_ value: String?, _
                                                  confidence: VNConfidence?,
                                                  _ error: CustomError?) -> Void)
}

class DefaultMainWorker: MainWorker {
    // MARK: - Variables
    let handPoseRequest: VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 1
        return request
    }()
    private var imageRequestHandler: VNImageRequestHandler?
    private var model: ASLHandPoseClassifier17?
    private var result: ASLHandPoseClassifier17Output?
    private var multiarray: MLMultiArray = MLMultiArray()
    private let confidence: VNConfidence = 0.9
    private let orientatation: CGImagePropertyOrientation = .right
    private let resultThrottleDuration: CGFloat = Constants.resultDuration
    private let outputResult = PassthroughSubject<CMSampleBuffer, CustomError>()
    private var cancelBag = Set<AnyCancellable>()
    private var observationConfidence: VNConfidence = 0
    private var resultHandler: ((_ value: String?, _ confidence: VNConfidence?, _ error: CustomError?) -> Void)?
    
    // MARK: - Setup
    func setupResultHandler(_ handler: @escaping (_ value: String?, _
                                                  confidence: VNConfidence?,
                                                  _ error: CustomError?) -> Void) {
        resultHandler = handler
    }
    
    // MARK: - Methods
    init() {
        model = try? ASLHandPoseClassifier17(configuration: .init())
        initializeResultOutput()
    }
    
    // MARK: - Predict Result
    func loadResult(sampleBuffer: CMSampleBuffer) {
        outputResult.send(sampleBuffer)
    }
    
    func initializeResultOutput() {
        outputResult
            .flatMap({ [self] sampleBuffer -> AnyPublisher<String?, CustomError> in
                self.imageRequestHandler = VNImageRequestHandler(
                    cmSampleBuffer: sampleBuffer,
                    orientation: .right,
                    options: [:]
                )
                
                do {
                    try imageRequestHandler!.perform([handPoseRequest])
                    guard let observation = handPoseRequest.results?.first else {
                        return .fail(.foundNoHandPose)
                    }
                    multiarray = try observation.keypointsMultiArray()
                    result = try model?.prediction(poses: multiarray)
                    
                    observationConfidence = observation.confidence
                    guard observation.confidence > confidence else {
                        return .empty()
                    }
                } catch {
                    return .fail(.genericWith(error))
                }
                
                if let result = result?.label {
                    return .just(result.uppercased())
                } else {
                    return .fail(.failedToPredictHandPose)
                }
            })
            .throttle(for: .seconds(resultThrottleDuration), scheduler: DispatchQueue.main, latest: true)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        ()
                    case let .failure(error):
                        self?.resultHandler?(nil, nil, error)
                        self?.initializeResultOutput()
                    }
                },
                receiveValue: { [weak self] resultValue in
                    if let resultValue = resultValue {
                        self?.resultHandler?(resultValue, self?.confidence ?? 0, nil)
                    } else {
                        self?.resultHandler?(nil, nil, .failedToPredictHandPose)
                    }
                }
            )
            .store(in: &cancelBag)
    }
}
