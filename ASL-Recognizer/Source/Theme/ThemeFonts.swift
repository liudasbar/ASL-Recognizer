import UIKit

public protocol ThemeFonts {
    /// Avenir, Regular, 18
    static var regular: UIFont { get }
    
    /// Avenir, Medium, 18
    static var medium: UIFont { get }
    
    /// Avenir, Medium, 24
    static var resultLabel: UIFont { get }
    
    /// Avenir, Regular, 22
    static var buttonLabel: UIFont { get }
    
    /// Avenir, Bold, 28
    static var handPoseLabel: UIFont { get }
}

public enum ThemeFont {
    case regular
    case medium
    case resultLabel
    case buttonLabel
    case handPoseLabel
    
    public var uiFont: UIFont {
        switch self {
        case .regular:
            return DefaultThemeFonts.regular
        case .medium:
            return DefaultThemeFonts.medium
        case .resultLabel:
            return DefaultThemeFonts.resultLabel
        case .buttonLabel:
            return DefaultThemeFonts.buttonLabel
        case .handPoseLabel:
            return DefaultThemeFonts.handPoseLabel
        }
    }
}
