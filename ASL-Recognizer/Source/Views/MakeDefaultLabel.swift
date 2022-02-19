import UIKit

extension UILabel {
    struct Config {
        var title: String
        var textColor: UIColor = .label
        var numberOfLines: Int = 0
        var textAlignment: NSTextAlignment = .left
        var lineBreakMode: NSLineBreakMode = .byWordWrapping
        var font: UIFont = activeTheme.fonts.regular
    }
    
    static func defaultLabel(config: Config) -> UILabel {
        let label = UILabel()
        label.text = config.title
        label.textColor = config.textColor
        label.numberOfLines = config.numberOfLines
        label.textAlignment = config.textAlignment
        label.lineBreakMode = config.lineBreakMode
        label.font = config.font
        return label
    }
}
