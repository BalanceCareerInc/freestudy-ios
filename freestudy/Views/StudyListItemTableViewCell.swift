//
//  StudyListItemTableViewCell.swift
//  freestudy
//
//  Created by 최보철 on 2015. 9. 2..
//  Copyright (c) 2015년 studysearch. All rights reserved.
//

import SwiftyJSON
import SnapKit

class StudyListItemTableViewCell: UITableViewCell {

    // MARK: Properties
    lazy var tagWrap = UIView()
    lazy var areaTag = UILabel()
    lazy var categoryTag = UILabel()
    lazy var cardView = UIView()
    lazy var studyTitle = UILabel()
    lazy var writtenAt = UILabel()

    let cardPadding = CGFloat(7)

    // MARK: Initialization

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initLayout()
    }

    func initLayout() {
        contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight

        backgroundColor = UIColor.grayColor()
        contentView.addSubview(cardView)
        cardView.backgroundColor = UIColor.whiteColor()
        cardView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).insets(UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 14))
        }
        cardView.layer.cornerRadius = 1
        cardView.layer.masksToBounds = false
        cardView.layer.shadowOffset = CGSizeMake(0, 0.5)
        cardView.layer.shadowRadius = 1
        cardView.layer.shadowOpacity = 0.2

        cardView.addSubview(areaTag)
        areaTag.frame.origin.x = cardPadding
        areaTag.frame.origin.y = cardPadding
        areaTag.textColor = UIColor.myOrangeColor()

        cardView.addSubview(categoryTag)
        categoryTag.frame.origin.y = cardPadding

        cardView.addSubview(studyTitle)
        studyTitle.numberOfLines = 0
        studyTitle.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(categoryTag.snp_bottom).offset(7)
            make.left.equalTo(cardView).offset(cardPadding)
            make.right.equalTo(cardView).offset(cardPadding * (-1))
        }

        cardView.addSubview(writtenAt)
        writtenAt.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(studyTitle.snp_bottom).offset(3)
            make.left.equalTo(cardView).offset(cardPadding)
            make.bottom.equalTo(cardView).offset(cardPadding * (-1))
        }
    }

    func bindStudy(study: JSON) {
        studyTitle.text = study["title"].stringValue
        categoryTag.text = TagsManager.sharedInstance.displayNames[study["category"].stringValue]
        areaTag.text = TagsManager.sharedInstance.displayNames[study["area"].stringValue]
        writtenAt.text = study["write_time"].stringValue

        areaTag.sizeToFit()
        categoryTag.sizeToFit()

        let categoryStart = areaTag.frame.width == 0 ? cardPadding : areaTag.frame.origin.x + areaTag.frame.width + 3
        categoryTag.frame.origin.x = categoryStart
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
