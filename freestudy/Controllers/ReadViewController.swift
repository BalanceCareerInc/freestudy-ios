import SnapKit
import Alamofire
import SwiftyJSON

class ReadViewController : UIViewController {
    
    var study: JSON?
    lazy var titleView = UILabel()
    lazy var contentView = UIWebView()
    
    init(studyId: Int) {
        super.init(nibName: nil, bundle: nil)
        Alamofire
            .request(
                .GET,
                "http://free.studysearch.co.kr/study/\(studyId)/", headers: ["Accept": "application/json"]
            )
            .responseJSON { _, _, data, _ in
                self.study = JSON(data!)["study"]
                self.titleView.text = self.study!["title"].stringValue
            }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.titleView)
        
        titleView.snp_makeConstraints { (make) -> Void in
            var topLayoutGuide = self.topLayoutGuide as! UIView
            make.top.equalTo(topLayoutGuide.snp_bottom).offset(10)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }
        titleView.lineBreakMode = .ByWordWrapping
        titleView.numberOfLines = 0
    }
    
}