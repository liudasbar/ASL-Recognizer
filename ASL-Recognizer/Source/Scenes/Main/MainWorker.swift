import Foundation
import Combine
import Vision
import AVFoundation

protocol MainWorker {
    func loadResult(sampleBuffer: CMSampleBuffer) -> AnyPublisher<String, CustomError>
}

class DefaultMainWorker: MainWorker {
    let handPoseRequest: VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 1
        return request
    }()
    private var imageRequestHandler: VNImageRequestHandler?
    private var model: ASLHandPoseClassifier16_2?
    private var result: ASLHandPoseClassifier16_2Output?
    private var multiarray: MLMultiArray = MLMultiArray()
    private let confidence: VNConfidence = 0.9
    private let orientatation: CGImagePropertyOrientation = .right
    
    func loadResult(sampleBuffer: CMSampleBuffer) -> AnyPublisher<String, CustomError> {
        
        imageRequestHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: orientatation, options: [:])
        
        do {
            model = try ASLHandPoseClassifier16_2(configuration: .init())
            try imageRequestHandler!.perform([handPoseRequest])
            guard let observation = handPoseRequest.results?.first else {
                // No hand pose results
                return .empty()
            }
            multiarray = try observation.keypointsMultiArray()
            result = try model?.prediction(poses: multiarray)
            
            guard observation.confidence > confidence else {
                return .empty()
            }
        } catch {
            print(error.localizedDescription)
            return .fail(.genericWith(error))
        }
        
        if let result = result?.label {
            print(result.uppercased()) // TODO: Remove
            return .just(result.uppercased())
        } else {
            return .empty()
        }
    }
}
