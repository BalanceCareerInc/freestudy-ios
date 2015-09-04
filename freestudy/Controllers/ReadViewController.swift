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
                
                let areaName = TagsManager.sharedInstance.nameOf(self.study!["area"].stringValue)
                let categoryName = TagsManager.sharedInstance.nameOf(self.study!["category"].stringValue)
                let tagNamesAttributedText = NSMutableAttributedString(string: "\(areaName) / \(categoryName)")
                tagNamesAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor(hex: "#f48210"), range: NSMakeRange(0, count(areaName)))
                tagNamesAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor(hex: "#a0a0a0"), range: NSMakeRange(count(areaName) + 3, count(categoryName)))
                self.tagNamesView.attributedText = tagNamesAttributedText
                
                self.titleView.text = self.study!["title"].stringValue
                self.titleView.frame.size.width = self.scrollView.frame.width - 40.0
                self.titleView.sizeToFit()
                self.titleView.frame.size.width = self.scrollView.frame.width - 40.0
                
                self.contentView.loadHTMLString(self.study!["content"].stringValue, baseURL: nil)
                self.contentView.frame.origin = CGPointMake(0, self.titleView.frame.origin.y + self.titleView.frame.size.height + 40.0)
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
        
        self.tagNamesView.frame = CGRectMake(20.0, 20.0, self.view.frame.width - 40.0, 20.0)
        self.tagNamesView.textAlignment = .Center
        
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
    
    func webViewDidFinishLoad(webView: UIWebView) {
        var height = CGFloat(webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight;")!.toInt()!)
        let newSize = CGSizeMake(scrollView.frame.size.width, height)
        webView.frame.size = newSize
        
        var contentSize = webView.frame.size
        contentSize.height += webView.frame.origin.y
        self.scrollView.contentSize = contentSize
    }
}