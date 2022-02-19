import Lottie
import UIKit

extension UIView {
    public func addAnimation(withName name: String, loopMode: LottieLoopMode = .loop, contentMode: UIView.ContentMode) -> AnimationView {
        let animation = AnimationView(animation: Animation.named(name))
        animation.loopMode = loopMode
        animation.contentMode = contentMode
        return animation
    }
    
    public func playAnimation(_ animation: AnimationView, animationCompleted: (() -> Void)? = nil) {
        animation.play(completion: { completed in
            animationCompleted?()
        })
    }
}
