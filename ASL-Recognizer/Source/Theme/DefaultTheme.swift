import UIKit

public var activeTheme: Theme.Type = DefaultTheme.self

public protocol Theme {
    static var colors: ThemeColors.Type { get }
    static var fonts: ThemeFonts.Type { get }
//    static var logo: UIImage { get }
}

public struct DefaultTheme: Theme {
    public static let colors: ThemeColors.Type = DefaultThemeColors.self
    public static let fonts: ThemeFonts.Type = DefaultThemeFonts.self
//    public static let logo: UIImage = Asset.logo.image
}

public struct DefaultThemeColors: ThemeColors {
    public static let blank: UIColor = UIColor(rgb: 0xffffff)
    public static let text: UIColor = UIColor(rgb: 0x000000)
    public static let buttonDefault: UIColor = .systemBlue
}

public struct DefaultThemeFonts: ThemeFonts {
    public static let regular: UIFont = UIFont(name: "Avenir-Regular", size: 18) ?? .systemFont(ofSize: 18)
    public static let medium: UIFont = UIFont(name: "Avenir-Medium", size: 18) ?? .systemFont(ofSize: 18)
    public static let resultLabel: UIFont = UIFont(name: "Avenir-Medium", size: 24) ?? .systemFont(ofSize: 24)
    public static let buttonLabel: UIFont = UIFont(name: "Avenir", size: 22) ?? .systemFont(ofSize: 22)
}
