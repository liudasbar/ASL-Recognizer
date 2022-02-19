import UIKit

public protocol ThemeColors {
    /// White
    static var blank: UIColor { get }
    /// Black
    static var text: UIColor { get }
}

public enum ThemeColor {
    case blank
    case text
    
    public var uiColor: UIColor {
        switch self {
        case .blank:
            return DefaultThemeColors.blank
        case .text:
            return DefaultThemeColors.text
        }
    }
}
