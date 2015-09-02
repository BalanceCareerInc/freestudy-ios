import SnapKit

class TagFilterViewController: UICollectionViewController {
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        self.collectionView?.backgroundColor = UIColor.whiteColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.registerClass(TagCollectionCell.self, forCellWithReuseIdentifier: "TagCell")
        self.collectionView?.snp_makeConstraints({ (make) -> Void in
            make.edges.equalTo(self.view).insets(UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5))
        })
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "close", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("closeModal"))
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags(forSection: section).count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TagCell", forIndexPath: indexPath) as! TagCollectionCell
        cell.label.text = TagsManager.sharedInstance.displayNames[tags(forSection: indexPath.section)[indexPath.row]]!
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let displayName = TagsManager.sharedInstance.displayNames[tags(forSection: indexPath.section)[indexPath.row]]!
        let displayNameString = displayName as NSString
        let size = displayNameString.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17.0)])
        return CGSize(width: size.width + 20, height: size.height + 20)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if section == 0{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else {
            return UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        }
    }
    
    
    func tags(forSection section: Int) -> Array<String> {
        if section == 0 {
            return TagsManager.sharedInstance.categories
        }
        else if section == 1 {
            return TagsManager.sharedInstance.areas
        }
        return Array<String>()
    }
    
    func closeModal() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}