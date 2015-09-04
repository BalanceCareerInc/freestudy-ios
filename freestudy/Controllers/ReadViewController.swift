import SnapKit
import Alamofire
import SwiftyJSON

import MessageUI

class ReadViewController : UIViewController, UIWebViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    var study: JSON?
    lazy var scrollView = UIScrollView()
    
    lazy var tagNamesView = UILabel()
    lazy var titleView = UILabel()
    lazy var contentView = UIWebView()
    lazy var writtenTimeView = UILabel()
    lazy var showContactsButton = UIButton()
    
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
    
    private func initScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = UIColor.whiteColor()
        self.scrollView.scrollEnabled = true
        self.scrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
    private func initContactButtonLayout() {
        self.view.addSubview(self.showContactsButton)
        self.showContactsButton.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(48)
            make.bottom.equalTo(self.view.snp_bottom).offset(-8)
            
            make.width.equalTo(self.view.snp_width).offset(-16)
            make.left.equalTo(self.view.snp_left).offset(8)
        }
        self.showContactsButton.backgroundColor = UIColor(hex: "#ef6c00", alpha: 85)
        self.showContactsButton.setBackgroundImage(UIImage.imageWithColor(UIColor(hex: "#de6400")), forState: .Highlighted)
        self.showContactsButton.setTitle("연락처 보기", forState: .Normal)
        self.showContactsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.showContactsButton.addTarget(self, action: "showContactsActionSheet:", forControlEvents: .TouchUpInside)
    }
    
    private func initTagNamesViewLayout() {
        self.scrollView.addSubview(self.tagNamesView)
        self.tagNamesView.textAlignment = .Center
        self.tagNamesView.font = UIFont.systemFontOfSize(14.0)
    }
    
    private func initTitleViewLayout() {
        self.scrollView.addSubview(self.titleView)
        
        self.titleView.frame.origin = CGPointMake(20.0, 50.0)
        self.titleView.font = UIFont.systemFontOfSize(17.0, weight: 3.0)
        self.titleView.textAlignment = .Center
        self.titleView.lineBreakMode = .ByWordWrapping
        self.titleView.numberOfLines = 0
    }
    
    private func initWrittenTimeViewLayout() {
        self.scrollView.addSubview(self.writtenTimeView)
        self.writtenTimeView.frame.size = CGSizeMake(self.view.frame.width - 40.0, 10.0)
        self.writtenTimeView.font = UIFont.systemFontOfSize(13.0)
        self.writtenTimeView.textColor = UIColor(hex: "#a0a0a0")
        self.writtenTimeView.textAlignment = .Center
    }
    
    private func initContentViewLayout() {
        self.scrollView.addSubview(self.contentView)
        self.contentView.backgroundColor = UIColor.clearColor()
        self.contentView.delegate = self
        self.contentView.userInteractionEnabled = false
        self.contentView.scrollView.scrollEnabled = false
    }
    
    
    
    private func showStudy(study: JSON) {
        self.showTagNames(study["area"].stringValue, category: study["category"].stringValue)
        self.showTitle(study["title"].stringValue)
        self.showWrittenTime(study["write_time"].stringValue)
        self.showContent(study["content"].stringValue)
    }
    
    private func showTagNames(area: String, category: String) {
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
    
    private func showTitle(title: String) {
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
    
    private func showWrittenTime(writtenTime: String) {
        self.writtenTimeView.text = writtenTime
        self.writtenTimeView.frame.origin = CGPointMake(20.0, self.titleView.frame.origin.y + self.titleView.frame.height + 15.0)
    }
    
    private func showContent(contentHTML: String) {
        self.contentView.frame.size = CGSizeMake(self.view.frame.width, 1)
        self.contentView.frame.origin = CGPointMake(0, self.writtenTimeView.frame.origin.y + self.writtenTimeView.frame.size.height + 40.0)
        self.contentView.loadHTMLString(contentHTML, baseURL: nil)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        var fittingSize = webView.sizeThatFits(CGSizeZero)
        webView.frame.size = fittingSize
        self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, webView.frame.height + webView.frame.origin.y + 50.0)
    }
    
    
    
    func showContactsActionSheet(sender: UIButton!) {
        var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "취소", destructiveButtonTitle: nil, otherButtonTitles: "이메일", "카카오톡", "문자")
        actionSheet.showInView(self.view)
        
        for (i, contactType) in enumerate(["email", "kakao", "phone"]) {
            if self.study!["contacts"][contactType] == nil {
                actionSheet.setButton(i + 1, enabled: false)
            }
        }
    }
    
    func willPresentActionSheet(actionSheet: UIActionSheet) {
        showContactsButton.hidden = true
    }
    
    func actionSheet(actionSheet: UIActionSheet, willDismissWithButtonIndex buttonIndex: Int) {
        showContactsButton.hidden = false
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch(buttonIndex) {
            case 0:
                break;
            case 1:
                let email = self.study!["contacts"]["email"].stringValue
                UIApplication.sharedApplication().openURL(NSURL(string: "mailto:\(email)")!)
                break;
            case 2:
                let kakao = self.study!["contacts"]["kakao"].stringValue
                UIPasteboard.generalPasteboard().string = kakao
                let alertView = UIAlertView(title: nil, message: "\(kakao)\n카카오톡 아이디가 복사되었습니다!", delegate: nil, cancelButtonTitle: "확인")
                alertView.show()
                break;
            case 3:
                let phone = self.study!["contacts"]["phone"].stringValue
                let title = self.study!["title"]
                var messageController = MFMessageComposeViewController()
                messageController.body = "\"\(title)\" 스터디에 신청합니다!"
                messageController.recipients = [phone]
                messageController.messageComposeDelegate = self
                presentViewController(messageController, animated: true, completion: nil)
                break;
            default:
                break;
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}