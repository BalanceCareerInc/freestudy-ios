import UIKit

extension UIActionSheet {
    func setButton(buttonIndex: Int, enabled: Bool) {
        let selector = NSSelectorFromString("_alertController")
        if self.respondsToSelector(selector) {
            let alertController: UIAlertController = self.valueForKey("_alertController") as! UIAlertController
            if alertController.isKindOfClass(UIAlertController.self) {
                var action = alertController.actions[buttonIndex] as! UIAlertAction
                action.enabled = enabled
            }
        }
        else {
            for view in self.subviews {
                if view.isMemberOfClass(NSClassFromString("UIAlertButton")) {
                    if buttonIndex == 0 {
                        if view.respondsToSelector("setEnabled:") {
                            var button = view as! UIButton
                            button.enabled = enabled
                        }
                    }
                }
            }
        }
    }
}
