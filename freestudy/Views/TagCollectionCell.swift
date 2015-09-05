import SnapKit

class TagCollectionCell : UICollectionViewCell {
    
    lazy var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.label)
        label.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
        label.font = label.font.fontWithSize(15)

        self.layer.cornerRadius = 2
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func deselect() {
        self.label.textColor = UIColor(hex: "#918ea1")
        self.backgroundColor = UIColor(hex: "#f9f8f9")

    }

    func select() {
        self.label.textColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.myOrangeColor()
    }
}
