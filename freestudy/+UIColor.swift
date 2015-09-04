import UIKit

extension UIColor {

    class func myOrangeColor() -> UIColor {
        return UIColor(red: 244/255.0, green: 82/255.0, blue: 10/255.0, alpha: 1)
    }

    class func translucentWhiteColor() -> UIColor {
        let color = UIColor()
        return UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.7)
    }
}