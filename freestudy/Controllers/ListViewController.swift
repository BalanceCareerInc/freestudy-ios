import SnapKit
import Alamofire
import SwiftyJSON

class ListViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {

    var searchController: UISearchController!
    var filterResultEmptyView: FilterResultEmptyView!

    var studies: [JSON] = []

    var selectedAreas = Array<String>()
    var selectedCategories = Array<String>()
    var query = ""
    var page = 1
    var loading = false
    var hitEndPage = false

    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initSearchController()

        searchStudies()
        initFilterResultEmptyView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        initNavigationBar()
    }
    
    func initTableView() {
        self.tableView.registerClass(StudyListItemTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func initSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.sizeToFit()
        
        let grayColor = UIColor(hex: "#efefef")
        self.searchController.searchBar.backgroundImage = UIImage.imageWithColor(grayColor)
        self.searchController.searchBar.barTintColor = grayColor
        
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar
    }

    func initFilterResultEmptyView() {
        self.filterResultEmptyView = FilterResultEmptyView(frame: CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height))
        self.filterResultEmptyView.filterButton.addTarget(self, action: Selector("showFilterDialog"), forControlEvents: UIControlEvents.TouchUpInside)
    }

    func initNavigationBar() {
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController!.navigationBar.barTintColor = UIColor.myOrangeColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.alpha = 1.0
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
        if (self.studies.count != 0 && !self.hitEndPage && contentOffSet + frameHeight > contentSize - 10) {
            getNextPage()
        }
    }

    func showFilterDialog() {
        let tagFilterViewController = TagFilterViewController(listViewController: self, selectedAreas: selectedAreas, selectedCategories: selectedCategories)
        let navigatedTagFilterViewController = UINavigationController(rootViewController: tagFilterViewController)
        
        presentViewController(navigatedTagFilterViewController, animated: true, completion: nil)
    }

    // MARK: Load Data
    
    func searchStudies(areas: Array<String>=Array<String>(), categories: Array<String>=Array<String>(), query: String="") {
        if self.loading {
            return
        }
        self.loading = true

        self.hitEndPage = false
        refreshTableView()

        self.page = 1
        self.selectedAreas = areas
        self.selectedCategories = categories
        self.query = query
        self.studies = []

        initFooterLoadingIndicator()

        fetchStudies(areas: areas, categories: categories, query: query, page: self.page)
    }

    func refreshTableView() {
        self.tableView.scrollEnabled = true
        self.tableView.alwaysBounceVertical = true
    }

    func getNextPage() {
        if self.loading {
            return
        }
        
        self.loading = true
        self.page += 1

        fetchStudies(areas: self.selectedAreas, categories: self.selectedCategories, query: self.query, page: self.page)
    }

    func fetchStudies(areas: Array<String>=Array<String>(), categories: Array<String>=Array<String>(), query: String="", page: Int = 1) {
        let parameter = getFilterParameters(areas: areas, categories: categories, query: query, page: page)
        Alamofire
            .request(
                .GET,
                "http://free.studysearch.co.kr/study/\(parameter)", headers: ["Accept": "application/json"]
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

                if page == 1 {
                    self.tableView.setContentOffset(CGPointMake(0, -70), animated: false)
                }
            }
    }

    func initFooterLoadingIndicator() {
        var spinner = UIActivityIndicatorView()
        spinner.frame.size.height = 44
        spinner.startAnimating()
        tableView.tableFooterView = spinner

    }

    func getFilterParameters(areas: Array<String>=Array<String>(), categories: Array<String>=Array<String>(), query: String="", page: Int = 1) -> String {
        var parameters = "?"
        if count(query) > 0 {
            parameters += "q=\(query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)&"
        }
        for area in areas{
            parameters = parameters + "area=" + area + "&"
        }
        for category in categories {
            parameters = parameters + "category=" + category + "&"
        }
        parameters = parameters + "page=" + String(page)
        println(parameters)
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

    // MARK: tableview dataSource, delegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! StudyListItemTableViewCell
        let study = self.studies[indexPath.row]
        cell.bindStudy(study)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let studyId = self.studies[indexPath.row]["id"].intValue
        self.navigationController!.pushViewController(ReadViewController(studyId: studyId), animated: true)
    }
    
    
    // MARK: searchController delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchStudies(areas: self.selectedAreas, categories: self.selectedCategories, query: searchBar.text)
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