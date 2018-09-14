//
//  AppFeedbackView.swift
//  Autobrain
//
//  Created by Kyle Smith on 9/11/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation
import UIKit

class AppFeedbackView: UIView {
    
    var denyPressed: (() -> ())?
    var acceptPressed: (() -> ())?
    
    var parent: AppFeedbackView?
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Are you enjoying Autobrain?"
        return label
    }()
    
    let denyButton: UILabelWithNode = {
        let label = UILabelWithNode()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "NOT REALLY"
        return label
    }()
    
    let acceptButton: UILabelWithNode = {
        let label = UILabelWithNode()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "ABSOLUTELY!"
        return label
    }()
    
    let horizontalSeparator: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.65)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let verticalSeparator: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.65)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = PRIMARY_COLOR_PURPLE
        
        addFeedbackView()
    }
    
    func addFeedbackView() {
        addSubview(questionLabel)
        addSubview(denyButton)
        addSubview(acceptButton)
        addSubview(horizontalSeparator)
        addSubview(verticalSeparator)
        
        _ = anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = questionLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 42)
        
        _ = horizontalSeparator.anchor(questionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 1)
        _ = verticalSeparator.anchor(horizontalSeparator.bottomAnchor, left: nil, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 1, heightConstant: 0)
        verticalSeparator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = denyButton.anchor(horizontalSeparator.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: verticalSeparator.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = acceptButton.anchor(horizontalSeparator.bottomAnchor, left: verticalSeparator.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //WKWebView was causing issues with the button. Implementing another method of finding if a user clicks.
        //check if the user clicked inside of the UILabels frame
        if let touch = touches.first {
            let position = touch.location(in: self)
            
            //check deny button
            if denyButton.frame.contains(position) {
                denyPressed?()
            }
            
            //check accept button
            if acceptButton.frame.contains(position) {
                acceptPressed?()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
