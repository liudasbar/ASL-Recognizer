import UIKit

public protocol ThemeColors {
    /// White
    static var blank: UIColor { get }
    /// Black
    static var text: UIColor { get }
    /// System Label
    static var textDynamic: UIColor { get }
    /// System Blue
    static var buttonDefault: UIColor { get }
    /// System Background
    static var systemBackground: UIColor { get }
}

public enum ThemeColor {
    case blank
    case text
    case textDynamic
    case buttonDefault
    case systemBackground
    
    public var uiColor: UIColor {
        switch self {
        case .blank:
            return DefaultThemeColors.blank
        case .text:
            return DefaultThemeColors.text
        case .textDynamic:
            return DefaultThemeColors.textDynamic
        case .buttonDefault:
            return DefaultThemeColors.buttonDefault
        case .systemBackground:
            return DefaultThemeColors.systemBackground
        }
    }
}
