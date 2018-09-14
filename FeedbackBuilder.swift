//
//  Feedback.swift
//  autobrain
//
//  Created by Kyle Smith on 8/28/18.
//  Copyright © 2018 SWJG-Ventures, LLC. All rights reserved.
//

import StoreKit

class FeedbackBuilder: NSObject {
    public enum ReviewRequestStatus: Int {
        case neither = 0
        case negative = 1
        case appStore = 2
        case amazon = 3
        case walmart = 4
    }
    
    enum ButtonTypes {
        case deny
        case accept
    }
    
    var parentView: MainView?
    var feedbackObject: [String: Any]?
    var reviewType: String?
    let api = APIClient.sharedInstance
    
    init(parentView: MainView, reviewType: String) {
        super.init()
        self.parentView = parentView
        self.reviewType = reviewType
        handleSetup(reviewType)
        startFeedback()
    }
    
    private func handleSetup(_ feedbackType: String) {
        do {
            if let file = Bundle.main.url(forResource: "feedback", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    feedbackObject = object[feedbackType] as? [String: Any]
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func startFeedback() {
        handleViewTransition(view: nil, nextView: recursivelyBuildViews(nil, feedbackObject)!)
    }
    
    private func recursivelyBuildViews(_ parent: AppFeedbackView?, _ object: [String: Any]?) -> AppFeedbackView? {
        guard let object = object else {
            return nil
        }
        
        if let _ = object["result"] {
            return nil
        }
        
        let fv = AppFeedbackView()
        fv.parent = parent
        fv.questionLabel.text = object["question"] as? String
        fv.layer.cornerRadius = 3
        fv.layer.shadowColor = UIColor.black.cgColor
        fv.layer.shadowOpacity = 0.6
        fv.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        fv.layer.shadowRadius = 3
        fv.layer.masksToBounds = false
        if let denyObject = object["deny"] as? [String: Any] {
            fv.denyButton.text = denyObject["text"] as? String
            fv.denyButton.nextNode = recursivelyBuildViews(fv, denyObject["next"] as? [String: Any])
            
            fv.denyPressed = { _ in
                self.answerSelected(view: fv, selected: .deny)
                if let result = (denyObject["next"] as! [String: Any])["result"] {
                    self.finishReview(result as! Int)
                }
            }
        }
        
        if let acceptObject = object["accept"] as? [String: Any] {
            fv.acceptButton.text = acceptObject["text"] as? String
            fv.acceptButton.nextNode = recursivelyBuildViews(fv, acceptObject["next"] as? [String: Any])
            
            fv.acceptPressed = { _ in
                self.answerSelected(view: fv, selected: .accept)
                if let result = (acceptObject["next"] as! [String: Any])["result"]{
                    self.finishReview(result as! Int)
                }
            }
        }
        
        return fv
    }
    
    private func handleViewTransition(view: AppFeedbackView?, nextView: AppFeedbackView? = nil) {
        guard let parentView = parentView else { return }
        guard let nextView = nextView else { return }
        
        parentView.addSubview(nextView)
        
        _ = nextView.anchor(nil, left: parentView.leftAnchor, bottom: nil, right: parentView.rightAnchor, topConstant: 0, leftConstant: 6, bottomConstant: 0, rightConstant: 6, widthConstant: 0, heightConstant: 104)
        
        let nextViewBottomAnchor = nextView.bottomAnchor.constraint(equalTo: parentView.webView.bottomAnchor, constant: 148)
        nextViewBottomAnchor.isActive = true
        parentView.layoutIfNeeded()
        
        guard let view = view else { // handle first view
            UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseIn, animations: {
                nextViewBottomAnchor.constant = -8
                parentView.layoutIfNeeded()
            }, completion: nil)
            return
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 104)
            parentView.layoutIfNeeded()
        }, completion: { _ in
            view.removeFromSuperview()
            UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseIn, animations: {
                nextViewBottomAnchor.constant = -8
                parentView.layoutIfNeeded()
            }, completion: nil)
        })
    }
    
    private func animateOffBottom(_ view: AppFeedbackView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 104)
            self.parentView?.layoutIfNeeded()
        }, completion: { _ in
            view.removeFromSuperview()
        })
    }
    
    private func answerSelected(view: AppFeedbackView, selected: ButtonTypes) {
        guard let nextView = selected == .accept ? view.acceptButton.nextNode : view.denyButton.nextNode else { //this is the last item in the review
            animateOffBottom(view)
            return
        }
        
        handleViewTransition(view: view, nextView: nextView)
    }
    
    private func finishReview(_ result: Int) {
        switch result {
        case 1:
            // show email feedback view
            Session.current().viewController?.navigationController?.pushViewController(ComposeEmailController(reviewType: reviewType!), animated: true)
            return
        case 2:
            // show app store review
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                openUrl(urlString: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=950321581&pageNumber=0&sortOrdering=2&type=Purple+Software&action=write-review&mt=8")
            }
        case 3:
            openUrl(urlString: "https://www.amazon.com/review/create-review/ref=cm_cr_dp_d_wr_but_top?ie=UTF8&channel=glance-detail&asin=B01FHCQIU6")
            break
        case 4:
            openUrl(urlString: "https://www.walmart.com/reviews/write-review?productId=165380538")
            break
        default:
            break
        }
        
        api.updateFeedbackStatus(reviewRequestStatus: ReviewRequestStatus(rawValue: result)!, reviewType: reviewType!)
    }
}
