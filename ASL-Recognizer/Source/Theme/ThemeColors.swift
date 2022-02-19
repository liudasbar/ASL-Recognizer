import UIKit

public protocol ThemeColors {
    /// White
    static var blank: UIColor { get }
    /// Black
    static var text: UIColor { get }
    /// System Blue
    static var buttonDefault: UIColor { get }
}

public enum ThemeColor {
    case blank
    case text
    case buttonDefault
    
    public var uiColor: UIColor {
        switch self {
        case .blank:
            return DefaultThemeColors.blank
        case .text:
            return DefaultThemeColors.text
        case .buttonDefault:
            return DefaultThemeColors.buttonDefault
        }
    }
}
