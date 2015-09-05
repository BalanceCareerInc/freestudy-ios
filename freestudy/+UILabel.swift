import UIKit

extension UILabel {
    func setHtml(html: String) {
        var err: NSError?
        self.attributedText = NSAttributedString(
            data: html.dataUsingEncoding(NSUTF16StringEncoding)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil,
            error: &err
        )
        if err != nil {
            println("Unable to parse label text: \(err)")
        }
    }
}