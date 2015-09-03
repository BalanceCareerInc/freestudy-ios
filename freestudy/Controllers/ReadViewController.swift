import SnapKit

class ReadViewController : UIViewController {
    
    lazy var titleView = UILabel()
    lazy var contentView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.titleView)
        
        titleView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(70)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(20)
            make.width.equalTo(self.view.frame.width - 40)
        }
        titleView.text = "[강남] 2015년 상반기 취업 스터디 - 실전면접, 자소서 피드백 교환, 기업 분석, 시사 상식, 인적성"
        titleView.lineBreakMode = .ByWordWrapping
        titleView.numberOfLines = 0
    }
    
}