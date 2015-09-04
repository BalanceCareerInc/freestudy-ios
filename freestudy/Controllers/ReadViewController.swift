import SnapKit
import Alamofire
import SwiftyJSON

class ReadViewController : UIViewController, UIWebViewDelegate, UIScrollViewDelegate {
    
    var study: JSON?
    lazy var scrollView = UIScrollView()
    
    lazy var tagNamesView = UILabel()
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
                self.showStudy(self.study!)
            }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        initScrollView()
        initTitleViewLayout()
        initContentViewLayout()
    }
    
    func initScrollView() {
        self.view.addSubview(scrollView)
        self.scrollView.backgroundColor = UIColor.whiteColor()
        self.scrollView.scrollEnabled = true
        self.scrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
    func initTitleViewLayout() {
        self.scrollView.addSubview(titleView)
        self.scrollView.addSubview(tagNamesView)
        
        self.tagNamesView.textAlignment = .Center
        self.tagNamesView.font = UIFont.systemFontOfSize(14.0)
        
        self.titleView.frame.origin = CGPointMake(20.0, 50.0)
        self.titleView.font = UIFont.systemFontOfSize(17.0, weight: 3.0)
        self.titleView.textAlignment = .Center
        self.titleView.lineBreakMode = .ByWordWrapping
        self.titleView.numberOfLines = 0
    }
    
    func initContentViewLayout() {
        self.scrollView.addSubview(contentView)
        self.contentView.backgroundColor = UIColor.clearColor()
        self.contentView.delegate = self
        self.contentView.userInteractionEnabled = false
        self.contentView.scrollView.scrollEnabled = false
    }
    
    
    func showStudy(study: JSON) {
        self.showTagNames(study["area"].stringValue, category: study["category"].stringValue)
        self.showTitle(study["title"].stringValue)
        self.showContent(study["content"].stringValue)
    }
    
    func showTagNames(area: String, category: String) {
        let areaName = TagsManager.sharedInstance.nameOf(area)
        let categoryName = TagsManager.sharedInstance.nameOf(category)
        let tagNamesAttributedText = NSMutableAttributedString(string: "\(areaName) / \(categoryName)")
        tagNamesAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor(hex: "#f48210"), range: NSMakeRange(0, count(areaName)))
        tagNamesAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor(hex: "#a0a0a0"), range: NSMakeRange(count(areaName) + 3, count(categoryName)))
        self.tagNamesView.attributedText = tagNamesAttributedText
        self.tagNamesView.frame = CGRectMake(20.0, 20.0, self.view.frame.width - 40.0, 15.0)
        self.tagNamesView.sizeToFit()
        self.tagNamesView.frame.size.width = self.view.frame.width - 40.0
    }
    
    func showTitle(title: String) {
        self.titleView.text = title
        self.titleView.frame = CGRectMake(
            20.0,
            self.tagNamesView.frame.origin.y + self.tagNamesView.frame.height + 10.0,
            self.view.frame.width - 40.0,
            0.0
        )
        self.titleView.sizeToFit()
        self.titleView.frame.size.width = self.view.frame.width - 40.0
    }
    
    func showContent(contentHTML: String) {
        self.contentView.frame.size = CGSizeMake(self.view.frame.width, 1)
        self.contentView.frame.origin = CGPointMake(0, self.titleView.frame.origin.y + self.titleView.frame.size.height + 40.0)
        self.contentView.loadHTMLString(contentHTML, baseURL: nil)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        var fittingSize = webView.sizeThatFits(CGSizeZero)
        webView.frame.size = fittingSize
        self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, webView.frame.height + webView.frame.origin.y)
    }
}