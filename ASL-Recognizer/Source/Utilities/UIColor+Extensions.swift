import UIKit

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1.0
        )
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    var hexString: String? {
        guard let components = self.cgColor.components else {
            return nil
        }
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return String(format: "%02X%02X%02X", (Int)(red * 255), (Int)(green * 255), (Int)(blue * 255))
    }
}
