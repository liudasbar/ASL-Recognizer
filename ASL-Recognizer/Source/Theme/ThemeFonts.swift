import UIKit

public protocol ThemeFonts {
    /// Avenir, Regular, 18
    static var regular: UIFont { get }
    
    /// Avenir, Medium, 18
    static var medium: UIFont { get }
    
    /// Avenir, Medium, 22
    static var mediumStatusLabel: UIFont { get }
}

public enum ThemeFont {
    case regular
    case medium
    case mediumStatusLabel
    
    public var uiFont: UIFont {
        switch self {
        case .regular:
            return DefaultThemeFonts.regular
        case .medium:
            return DefaultThemeFonts.medium
        case .mediumStatusLabel:
            return DefaultThemeFonts.mediumStatusLabel
        }
    }
}
