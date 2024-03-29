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
        let imageView = UIImageView(image: UIImage(named: getLaunchImageFileName()!))
        view.addSubview(imageView)
        imageView.snp_makeConstraints{ (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }

    func getLaunchImageFileName() -> String? {
        var allPngImages = NSBundle.mainBundle().pathsForResourcesOfType("png", inDirectory: nil)

        for imageName in allPngImages {
            if imageName.containsString("LaunchImage") {
                let image = UIImage(named: imageName as! String)
                if (image!.scale == UIScreen.mainScreen().scale && CGSizeEqualToSize(image!.size, UIScreen.mainScreen().bounds.size)) {
                    return imageName as? String
                }
            }
        }
        return nil
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
                TagsManager.sharedInstance.putTags(json["tags"])
                self.startMainController()
        }
    }

    // MARK: Transition

    func startMainController() {
        let mainController = UINavigationController(rootViewController: ListViewController())
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