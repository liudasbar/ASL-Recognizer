import UIKit

enum Main {
    struct LoadGreeting {
        struct Request {
            let parameter: Bool
        }
        struct Response {
            let isLoading: Bool
            let error: Error?
            let name: String?
        }
        enum ViewModel {
            case error(Error)
            case loading
            case greeting(String)
        }
    }
}
