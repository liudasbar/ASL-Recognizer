import UIKit

extension UIView {
    struct Config {
        var backgroundColor: UIColor = activeTheme.colors.systemBackground
        var masksToBounds: Bool = false
        var cornerRadius: CGFloat = 0
        var borderWidth: CGFloat = 0
        var borderColor: UIColor = activeTheme.colors.blank
    }
    
    func makeDefaultView(config: Config) -> UIView {
        let view = UIView()
        view.backgroundColor = config.backgroundColor
        view.layer.masksToBounds = config.masksToBounds
        view.layer.cornerRadius = config.cornerRadius
        view.layer.borderWidth = config.borderWidth
        view.layer.borderColor = config.borderColor.cgColor
        return view
    }
}
