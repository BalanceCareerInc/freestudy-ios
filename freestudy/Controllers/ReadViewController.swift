import SnapKit
import Alamofire
import SwiftyJSON

class ReadViewController : UIViewController, UIWebViewDelegate, UIScrollViewDelegate {
    
    var study: JSON?
    lazy var scrollView = UIScrollView()
    lazy var titleView = UILabel()
    lazy var contentView = UIWebView()
    lazy var button = UIButton()
    
    init(studyId: Int) {
        super.init(nibName: nil, bundle: nil)
        Alamofire
            .request(
                .GET,
                "http://free.studysearch.co.kr/study/\(studyId)/", headers: ["Accept": "application/json"]
            )
            .responseJSON { _, _, data, _ in
                self.study = JSON(data!)["study"]
                let titleString = self.study!["title"].stringValue
                self.titleView.text = titleString
                self.titleView.frame = CGRectMake(20, 20, self.view.frame.width - 40, CGFloat.max)
                self.titleView.sizeToFit()
                
                self.contentView.loadHTMLString(self.study!["content"].stringValue, baseURL: nil)
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
        scrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
    func initTitleViewLayout() {
        self.scrollView.addSubview(titleView)
        titleView.lineBreakMode = .ByWordWrapping
        titleView.numberOfLines = 0
    }
    
    func initContentViewLayout() {
        self.scrollView.addSubview(contentView)
        self.contentView.backgroundColor = UIColor.yellowColor()
        self.contentView.delegate = self
        self.contentView.userInteractionEnabled = false
        self.contentView.scrollView.scrollEnabled = false
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        var height = CGFloat(webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight;")!.toInt()!)
        let newSize = CGSizeMake(scrollView.frame.size.width, height)
        webView.frame.origin = CGPointMake(0, titleView.frame.size.height + 20.0)
        webView.frame.size = newSize
        self.scrollView.contentSize = newSize
    }
}