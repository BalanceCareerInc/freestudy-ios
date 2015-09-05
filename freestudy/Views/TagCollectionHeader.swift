import UIKit

class TagCollectionHeader: UICollectionReusableView {

    lazy var label = UILabel(frame: CGRectMake(0, 0, 300, 20))

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(label)
        label.textColor = UIColor.myOrangeColor()
        label.font = label.font.fontWithSize(12)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
