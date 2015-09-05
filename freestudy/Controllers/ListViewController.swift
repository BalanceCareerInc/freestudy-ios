import SnapKit
import Alamofire
import SwiftyJSON

class ListViewController: UITableViewController {

    var searchView: UIView!
    var filterResultEmptyView: FilterResultEmptyView!

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
        initFilterResultEmptyView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        initNavigationBar()
    }

    func initLayout() {
        tableView.backgroundColor = UIColor.grayColor()
        tableView.registerClass(StudyListItemTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        let inset = UIEdgeInsetsMake(7, 0, 7, 0);
        tableView.contentInset = inset

        initSearchButton()
    }

    func initSearchButton() {
        self.searchView = UIView(frame: CGRectMake(0, -57, self.tableView.frame.width, 50))
        self.searchView.backgroundColor = UIColor.redColor()
        tableView.addSubview(self.searchView)
    }

    func initFilterResultEmptyView() {
        filterResultEmptyView = FilterResultEmptyView(frame: CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height))
        filterResultEmptyView.filterButton.addTarget(self, action: Selector("showFilterDialog"), forControlEvents: UIControlEvents.TouchUpInside)
    }

    func initNavigationBar() {
        self.navigationController!.navigationBar.barTintColor = UIColor.myOrangeColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.alpha = 1.0
        self.navigationController!.navigationBar.translucent = false
        self.navigationItem.title = "무료 스터디"

        let filterButton = UIBarButtonItem(title: "필터", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showFilterDialog"))
        filterButton.tintColor = UIColor.tranlucentWhiteColor()
        self.navigationItem.rightBarButtonItem = filterButton
    }

    // MARK: Actions

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffSet = scrollView.contentOffset.y
        let frameHeight = scrollView.frame.size.height
        let contentSize = scrollView.contentSize.height
        if (self.studies.count != 0 && !hitEndPage && contentOffSet + frameHeight > contentSize - 10) {
            getNextPage()
        }
    }

    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            searchView.resignFirstResponder()
        }

        if scrollView.contentOffset.y < 0 && tableView.contentInset.top != 57 {
            showSearchButton()
        }

        else {
            hideSearchButton()
        }
    }

    func showSearchButton() {
        tableView.contentInset = UIEdgeInsetsMake(57, 0, 0, 0)
        tableView.setContentOffset(CGPointMake(0, -57), animated: true)

    }

    func hideSearchButton() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)

        tableView.contentInset = UIEdgeInsetsMake(7, 0, 0, 0)

        UIView.commitAnimations()
    }

    func showFilterDialog() {
        let tagFilterViewController = TagFilterViewController(listViewController: self, selectedAreas: selectedAreas, selectedCategories: selectedCategories)
        let navigatedTagFilterViewController = UINavigationController(rootViewController: tagFilterViewController)
        
        presentViewController(navigatedTagFilterViewController, animated: true, completion: nil)
    }

    // MARK: Load Data
    
    func searchStudies(areas: Array<String>=Array<String>(), categories: Array<String>=Array<String>()) {
        if self.loading {
            return
        }
        self.loading = true

        hitEndPage = false
        refreshTableView()

        page = 1
        selectedAreas = areas
        selectedCategories = categories
        self.studies = []

        initFooterLoadingIndicator()

        fetchStudies(search: true)
    }

    func refreshTableView() {
        tableView.scrollEnabled = true
        tableView.alwaysBounceVertical = true
        hideSearchButton()
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

                if self.hitEndPage {
                    self.refreshFooterView()
                }

                if search {
                    self.tableView.setContentOffset(CGPointZero, animated: false)
                }
            }
    }

    func initFooterLoadingIndicator() {
        var spinner = UIActivityIndicatorView()
        spinner.frame.size.height = 44
        spinner.startAnimating()
        tableView.tableFooterView = spinner

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

    func refreshFooterView() {

        if studies.count != 0 {
            tableView.tableFooterView = nil
        }
        else if !(self.selectedAreas.count == 0 && self.selectedCategories.count == 0) {
            tableView.tableFooterView = filterResultEmptyView
            tableView.alwaysBounceVertical = false
            tableView.scrollEnabled = false
        }
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