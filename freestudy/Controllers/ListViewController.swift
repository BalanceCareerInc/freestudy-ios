import SnapKit
import Alamofire
import SwiftyJSON

class ListViewController: UITableViewController {
    
    lazy var label = UILabel()
    var studies: JSON?

    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()

        fetchStudies()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.barTintColor = UIColor(hex: "#f48210")
        self.navigationController!.navigationBar.alpha = 1.0
        self.navigationController!.navigationBar.translucent = false
    }

    func initLayout() {
        initNavigationBar()

        tableView.backgroundColor = UIColor.grayColor()
        tableView.registerClass(StudyListItemTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        let inset = UIEdgeInsetsMake(7, 0, 7, 0);
        tableView.contentInset = inset
    }

    func initNavigationBar() {
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        navigationItem.title = "무료 스터디"

        navigationController?.navigationBar.barTintColor = UIColor.myOrangeColor()

        let filterButton = UIBarButtonItem(title: "필터", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showFilterDialog"))
        filterButton.tintColor = UIColor.translucentWhiteColor()
        self.navigationItem.rightBarButtonItem = filterButton
    }

    // MARK: Load Data
    
    func fetchStudies(areas: Array<String>=Array<String>(), categories: Array<String>=Array<String>()) {
        var parameters = "?"
        for area in areas {
            parameters = parameters + "area=" + area + "&"
        }
        for category in categories {
            parameters = parameters + "category=" + category + "&"
        }
        Alamofire
            .request(
                .GET,
                "http://free.studysearch.co.kr/study/" + parameters, headers: ["Accept": "application/json"]
            )
            .responseJSON { _, _, data, _ in
                var json = JSON(data!)
                self.studies = json["study_list"]
                self.tableView.reloadData()
            }
    }


    // MARK: Cell
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.studies == nil {
            return 0
        }
        return self.studies!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! StudyListItemTableViewCell
        let study = self.studies![indexPath.row]
        cell.bindStudy(study)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let studyId = self.studies![indexPath.row]["id"].intValue
        self.navigationController!.pushViewController(ReadViewController(studyId: studyId), animated: true)
    }

    func showFilterDialog() {
        let tagFilterViewController = TagFilterViewController(listViewController: self)
        let navigatedTagFilterViewController = UINavigationController(rootViewController: tagFilterViewController)
        
        presentViewController(navigatedTagFilterViewController, animated: true, completion: nil)
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