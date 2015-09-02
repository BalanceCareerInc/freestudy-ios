import SnapKit

class TagCollectionCell : UICollectionViewCell {
    
    lazy var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.label)
        label.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
