import UIKit

extension UIImageView {
    struct Config {
        var image: UIImage
        var tintColor: UIColor = activeTheme.colors.textDynamic
        var contentMode: UIView.ContentMode = .scaleAspectFit
    }
    
    static func defaultImageView(config: Config) -> UIImageView {
        let view = UIImageView()
        view.image = config.image
        view.tintColor = config.tintColor
        view.contentMode = config.contentMode
        return view
    }
}
