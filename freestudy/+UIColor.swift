import UIKit

extension UIColor {
    class func myOrangeColor() -> UIColor {
        return UIColor(hex: "#ef6c00")
    }

    class func tranlucentWhiteColor() -> UIColor {
        return UIColor(red: 255, green: 255, blue: 255, alpha: 0.7)
    }

    class func a0a0a0() -> UIColor {
        return UIColor(hex: "#a0a0a0")
    }
    
    convenience init(var hex: String, alpha: Int=100) {
        let hexLength = count(hex)
        if hexLength != 7{
            println("improper call to 'colorFromHex', hex length must be 7 chars (#RRGGBB)")
            self.init(white: 0, alpha: 1)
            return
        }
        
        var rgb: UInt32 = 0
        var s: NSScanner = NSScanner(string: hex)
        s.scanLocation = 1
        s.scanHexInt(&rgb)
        
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha) / 100
        )
    }
}