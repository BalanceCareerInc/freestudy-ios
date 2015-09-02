import SnapKit
import Alamofire
import SwiftyJSON

class StudyListTableController: UITableViewController {
    
    lazy var label = UILabel()
    var studies: JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTags()
        fetchStudies()
        addFilterBarButtonItem()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.studies == nil {
            return 0
        }
        return self.studies!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel?.text = self.studies![indexPath.row]["title"].stringValue
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func fetchTags() {
        Alamofire
            .request(
                .POST,
                "https://ssl-app.studysearch.co.kr/mobile/launch/", headers: ["Accept": "application/json"]
            )
            .responseJSON { _, _, data, _ in
                var json = JSON(data!)
                var displayNames = Dictionary<String, String>()
                TagsManager.sharedInstance.displayNames = Dictionary(map(json["tags"]["display_names"].dictionaryValue){
                    (key, value) in (key, value.stringValue)
                    })
                TagsManager.sharedInstance.filters = Dictionary(map(json["tags"]["filters"].dictionaryValue){
                    (key:String, value:JSON) in
                    (key, map(value.arrayValue){(tagName:JSON) -> String in tagName.stringValue})
                    })
        }
    }
    
    func fetchStudies() {
        Alamofire
            .request(
                .GET,
                "https://ssl-app.studysearch.co.kr/study/", headers: ["Accept": "application/json"]
            )
            .responseJSON { _, _, data, _ in
                var json = JSON(data!)
                self.studies = json["study_list"]
                self.tableView.reloadData()
        }
    }
    
    func addFilterBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "filter", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("itemClicked"))
    }
    
    func itemClicked() {
        println("hi")
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