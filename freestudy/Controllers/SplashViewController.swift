//
//  SplashViewController.swift
//  freestudy
//
//  Created by 최보철 on 2015. 9. 2..
//  Copyright (c) 2015년 studysearch. All rights reserved.
//
import Alamofire
import SwiftyJSON
import SnapKit

class SplashViewController: UIViewController {

    // MARK: Properties

    let animator = TransitionAnimator()

    // MARK: Initilization

    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()

        loadData()
    }

    func initLayout() {
        let imageView = UIImageView(image: UIImage(named: "LaunchImage.png"))
        view.addSubview(imageView)
        imageView.snp_makeConstraints{ (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }

    // MARK: Load Data

    func loadData() {
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

                self.startMainController()
        }
    }

    // MARK: Transition

    func startMainController() {
        let mainController = UINavigationController(rootViewController: StudyListTableController())
        mainController.transitioningDelegate = self
        self.presentViewController(mainController, animated: true, completion: nil)
    }

    // MARK: Animator

    class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

        let duration = 0.5

        func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
            return duration
        }

        func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
            var containerView = transitionContext.containerView()
            var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
            var toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            var fromView = (fromViewController?.view)!

            containerView.addSubview(toView)
            containerView.insertSubview(toView, belowSubview: fromView)

            UIView.animateWithDuration(
                duration, animations: {
                    fromViewController?.view.alpha = 0
                }, completion: {_ in
                    transitionContext.completeTransition(true)
            })
        }
    }
}

extension SplashViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}