import Foundation
import Combine
import CoreML
import AVFoundation

protocol MainWorker {
}

class DefaultMainWorker: MainWorker {
    func loadMLModel() {
//        let url = try! MLModel.compileModel(at: URL(fileURLWithPath: model))
//        visionModel = try! VNCoreMLModel(for: MLModel(contentsOf: url))
        let model = ASLHandPoseClassifier16_2()
        
    }
}
