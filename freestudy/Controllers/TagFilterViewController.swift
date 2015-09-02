import SnapKit

class TagFilterViewController: UICollectionViewController {
    
    let studyListViewController: StudyListViewController!
    
    init(studyListViewController: StudyListViewController) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        self.studyListViewController = studyListViewController
        super.init(collectionViewLayout: layout)
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
        self.collectionView?.allowsMultipleSelection = true
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("closeModal"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "검색", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("searchWithSelectedTags"))
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
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.whiteColor()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.yellowColor()
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
    
    
    func searchWithSelectedTags() {
        var categories = Array<String>()
        var areas = Array<String>()
        for indexPath in self.collectionView!.indexPathsForSelectedItems() {
            if indexPath.section == 0 {
                categories.append(tags(forSection: indexPath.section)[indexPath.row])
            }
            else if indexPath.section == 1 {
                areas.append(tags(forSection: indexPath.section)[indexPath.row])
            }
        }
        studyListViewController.fetchStudies(areas: areas, categories: categories)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func closeModal() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}