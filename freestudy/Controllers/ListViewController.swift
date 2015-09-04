import SnapKit
import Alamofire
import SwiftyJSON

class ListViewController: UITableViewController {
    
    lazy var label = UILabel()
    var studies: [JSON] = []

    var selectedAreas = Array<String>()
    var selectedCategories = Array<String>()
    var page = 1
    var loading = false
    var hitEndPage = false

    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()

        searchStudies()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.barTintColor = UIColor.myOrangeColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.alpha = 1.0
        self.navigationController!.navigationBar.translucent = false
        self.navigationItem.title = "무료 스터디"

        let filterButton = UIBarButtonItem(title: "필터", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showFilterDialog"))
        filterButton.tintColor = UIColor.tranlucentWhiteColor()
        self.navigationItem.rightBarButtonItem = filterButton
    }

    func initLayout() {
        tableView.backgroundColor = UIColor.grayColor()
        tableView.registerClass(StudyListItemTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        let inset = UIEdgeInsetsMake(7, 0, 7, 0);
        tableView.contentInset = inset
    }

    // MARK: Actions

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (self.studies.count != 0 && !hitEndPage && scrollView.contentOffset.y > scrollView.contentOffset.y - 1000) {
            getNextPage()
        }
    }

    func showFilterDialog() {
        let tagFilterViewController = TagFilterViewController(listViewController: self, selectedAreas: selectedAreas, selectedCategories: selectedCategories)
        let navigatedTagFilterViewController = UINavigationController(rootViewController: tagFilterViewController)
        
        presentViewController(navigatedTagFilterViewController, animated: true, completion: nil)
    }

    // MARK: Load Data
    
    func searchStudies(areas: Array<String>=Array<String>(), categories: Array<String>=Array<String>()) {
        print("search!!\n")
        if self.loading {
            return
        }
        self.loading = true

        page = 1
        hitEndPage = false
        selectedAreas = areas
        selectedCategories = categories
        self.studies = []

        fetchStudies(search: true)
    }

    func getNextPage() {
        if self.loading {
            return
        }
        self.loading = true

        self.page += 1

        fetchStudies()
    }

    func fetchStudies(search: Bool = false) {
        Alamofire
            .request(
                .GET,
                "http://free.studysearch.co.kr/study/" + getFilterParameters(), headers: ["Accept": "application/json"]
            )
            .responseJSON { _, _, data, _ in
                var json = JSON(data!)
                self.studies = self.studies + json["study_list"].arrayValue
                self.hitEndPage = json["end"].boolValue
                self.tableView.reloadData()

                self.loading = false

                if search {
                    self.tableView.setContentOffset(CGPointZero, animated: false)
                }
            }
    }

    func getFilterParameters() -> String {
        var parameters = "?"
        for area in self.selectedAreas {
            parameters = parameters + "area=" + area + "&"
        }
        for category in self.selectedCategories {
            parameters = parameters + "category=" + category + "&"
        }
        parameters = parameters + "page=" + String(self.page)
        return parameters
    }

    // MARK: Cell
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! StudyListItemTableViewCell
        let study = self.studies[indexPath.row]
        cell.bindStudy(study)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let studyId = self.studies[indexPath.row]["id"].intValue
        self.navigationController!.pushViewController(ReadViewController(studyId: studyId), animated: true)
    }
}

extension Dictionary {
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
}