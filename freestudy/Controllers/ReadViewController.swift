import SnapKit
import Alamofire
import SwiftyJSON

class ReadViewController : UIViewController, UIWebViewDelegate, UIScrollViewDelegate {
    
    var study: JSON?
    lazy var scrollView = UIScrollView()
    
    lazy var tagNamesView = UILabel()
    lazy var titleView = UILabel()
    lazy var contentView = UIWebView()
    lazy var writtenTimeView = UILabel()
    lazy var showContactButton = UIButton()
    
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
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(
            UIOffsetMake(0, -60), forBarMetrics: .Default
        )
        initScrollView()
        initContactButtonLayout()
        
        initTagNamesViewLayout()
        initTitleViewLayout()
        initWrittenTimeViewLayout()
        initContentViewLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.alpha = 0.8
    }
    
    func initScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = UIColor.whiteColor()
        self.scrollView.scrollEnabled = true
        self.scrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
    func initContactButtonLayout() {
        self.view.addSubview(self.showContactButton)
        self.showContactButton.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.snp_bottom).offset(-10)
            
            make.width.equalTo(self.view.snp_width).offset(-16)
            make.left.equalTo(self.view.snp_left).offset(8)
        }
        self.showContactButton.backgroundColor = UIColor(hex: "#ef6c00", alpha: 85)
        self.showContactButton.setTitle("연락처 보기", forState: .Normal)
        self.showContactButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    func initTagNamesViewLayout() {
        self.scrollView.addSubview(self.tagNamesView)
        self.tagNamesView.textAlignment = .Center
        self.tagNamesView.font = UIFont.systemFontOfSize(14.0)
    }
    
    func initTitleViewLayout() {
        self.scrollView.addSubview(self.titleView)
        
        self.titleView.frame.origin = CGPointMake(20.0, 50.0)
        self.titleView.font = UIFont.systemFontOfSize(17.0, weight: 3.0)
        self.titleView.textAlignment = .Center
        self.titleView.lineBreakMode = .ByWordWrapping
        self.titleView.numberOfLines = 0
    }
    
    func initWrittenTimeViewLayout() {
        self.scrollView.addSubview(self.writtenTimeView)
        self.writtenTimeView.frame.size = CGSizeMake(self.view.frame.width - 40.0, 10.0)
        self.writtenTimeView.font = UIFont.systemFontOfSize(13.0)
        self.writtenTimeView.textColor = UIColor(hex: "#a0a0a0")
        self.writtenTimeView.textAlignment = .Center
    }
    
    func initContentViewLayout() {
        self.scrollView.addSubview(self.contentView)
        self.contentView.backgroundColor = UIColor.clearColor()
        self.contentView.delegate = self
        self.contentView.userInteractionEnabled = false
        self.contentView.scrollView.scrollEnabled = false
    }
    
    
    
    func showStudy(study: JSON) {
        self.showTagNames(study["area"].stringValue, category: study["category"].stringValue)
        self.showTitle(study["title"].stringValue)
        self.showWrittenTime(study["write_time"].stringValue)
        self.showContent(study["content"].stringValue)
    }
    
    func showTagNames(area: String, category: String) {
        let tagsManager = TagsManager.sharedInstance
        let areaName = tagsManager.nameOf(area)
        
        var categoryName: String
        if tagsManager.isSubSubTag(category) {
            let parentCategoryName = tagsManager.nameOf(tagsManager.parentOf(category)!)
            categoryName = "\(parentCategoryName) \(tagsManager.nameOf(category))"
        }
        else {
            categoryName = tagsManager.nameOf(category)
        }
        
        let tagNamesAttributedText = NSMutableAttributedString(string: "\(areaName) \(categoryName)")
        tagNamesAttributedText.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.myOrangeColor(),
            range: NSMakeRange(0, count(areaName))
        )
        tagNamesAttributedText.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor(hex: "#a0a0a0"),
            range: NSMakeRange(count(areaName) + 1, count(categoryName))
        )
        self.tagNamesView.attributedText = tagNamesAttributedText
        self.tagNamesView.frame = CGRectMake(20.0, 20.0, self.view.frame.width - 40.0, 15.0)
        self.tagNamesView.sizeToFit()
        self.tagNamesView.frame.size.width = self.view.frame.width - 40.0
    }
    
    func showTitle(title: String) {
        self.titleView.text = title
        self.titleView.frame = CGRectMake(
            20.0,
            self.tagNamesView.frame.origin.y + self.tagNamesView.frame.height + 5.0,
            self.view.frame.width - 40.0,
            0.0
        )
        self.titleView.sizeToFit()
        self.titleView.frame.size.width = self.view.frame.width - 40.0
    }
    
    func showWrittenTime(writtenTime: String) {
        self.writtenTimeView.text = writtenTime
        self.writtenTimeView.frame.origin = CGPointMake(20.0, self.titleView.frame.origin.y + self.titleView.frame.height + 15.0)
    }
    
    func showContent(contentHTML: String) {
        self.contentView.frame.size = CGSizeMake(self.view.frame.width, 1)
        self.contentView.frame.origin = CGPointMake(0, self.writtenTimeView.frame.origin.y + self.writtenTimeView.frame.size.height + 40.0)
        self.contentView.loadHTMLString(contentHTML, baseURL: nil)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        var fittingSize = webView.sizeThatFits(CGSizeZero)
        webView.frame.size = fittingSize
        self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, webView.frame.height + webView.frame.origin.y)
    }
}