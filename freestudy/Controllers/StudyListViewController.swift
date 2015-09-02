import SnapKit
import Alamofire
import SwiftyJSON

class StudyListViewController: UITableViewController {
    
    lazy var label = UILabel()
    var studies: JSON?

    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()

        fetchStudies()
    }

    func initLayout() {
        addFilterBarButtonItem()
        tableView.backgroundColor = UIColor.grayColor()
        tableView.registerClass(StudyListItemTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.estimatedRowHeight = 44
        let inset = UIEdgeInsetsMake(7, 0, 7, 0);
        tableView.contentInset = inset
    }

    func addFilterBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "filter", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("itemClicked"))
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
        cell.studyTitle.text = self.studies![indexPath.row]["title"].stringValue
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

    func itemClicked() {
        let tagFilterViewController = TagFilterViewController(studyListViewController: self)
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