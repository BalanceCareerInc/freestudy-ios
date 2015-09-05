import SnapKit

class TagFilterViewController: UICollectionViewController {
    
    let listViewController: ListViewController!
    let sectionCategory = 0
    let sectionArea = 1

    var selectedAreas: Array<String>
    var selectedCategories: Array<String>
    
    init(listViewController: ListViewController, selectedAreas: Array<String>, selectedCategories: Array<String>) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        self.listViewController = listViewController
        self.selectedAreas = selectedAreas
        self.selectedCategories = selectedCategories
        super.init(collectionViewLayout: layout)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationBar()


        self.collectionView?.registerClass(TagCollectionCell.self, forCellWithReuseIdentifier: "TagCell")
        self.collectionView?.snp_makeConstraints({ (make) -> Void in
            make.edges.equalTo(self.view).insets(UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5))
        })
        self.collectionView?.allowsMultipleSelection = true
        self.view.backgroundColor = UIColor.whiteColor()
        self.collectionView?.backgroundColor = UIColor.whiteColor()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBar()

        setDefaultSelected()
    }

    func setDefaultSelected() {
        let categories = tags(forSection: sectionCategory)
        let areas = tags(forSection: sectionArea)
        for category in self.selectedCategories {
            let indexPath = NSIndexPath(forRow: find(categories, category)!, inSection: self.sectionCategory)
            self.collectionView?.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: nil)
        }
        for area in self.selectedAreas {
            let indexPath = NSIndexPath(forRow: find(areas, area)!, inSection: sectionArea)
            self.collectionView?.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: nil)
        }
    }

    func initNavigationBar() {
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.myOrangeColor()]
        self.navigationItem.title = "필터"

        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "닫기", style: .Plain, target: self, action: Selector("closeModal")
        )
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.a0a0a0()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "적용", style: .Plain, target: self, action: Selector("searchWithSelectedTags")
        )
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.a0a0a0()

    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags(forSection: section).count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TagCell", forIndexPath: indexPath) as! TagCollectionCell
        let tag = tags(forSection: indexPath.section)[indexPath.row]

        cell.label.text = TagsManager.sharedInstance.nameOf(tag)
        if find(self.selectedAreas, tag) != nil || find(self.selectedCategories, tag) != nil {
            cell.select()
        }
        else {
            cell.deselect()
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! TagCollectionCell
        let tag = tags(forSection: indexPath.section)[indexPath.row]

        cell.deselect()
        if indexPath.section == sectionCategory {
            selectedCategories.removeAtIndex(find(selectedCategories, tag)!)
        }
        else {
            selectedAreas.removeAtIndex(find(selectedAreas, tag)!)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! TagCollectionCell
        let tag = tags(forSection: indexPath.section)[indexPath.row]

        cell.select()
        if indexPath.section == sectionCategory {
            selectedCategories.append(tag)
        }
        else {
            selectedAreas.append(tag)
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let displayName = TagsManager.sharedInstance.nameOf(tags(forSection: indexPath.section)[indexPath.row])
        let displayNameString = displayName as NSString
        let size = displayNameString.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17.0)])
        return CGSize(width: size.width + 20, height: size.height + 20)
    }
    
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if section == sectionCategory{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else {
            return UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        }
    }
    
    
    func tags(forSection section: Int) -> Array<String> {
        if section == sectionCategory {
            return TagsManager.sharedInstance.categories
        }
        else if section == sectionArea {
            return TagsManager.sharedInstance.areas
        }
        return Array<String>()
    }
    
    
    func searchWithSelectedTags() {
        listViewController.searchStudies(areas: selectedAreas, categories: selectedCategories)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func closeModal() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}