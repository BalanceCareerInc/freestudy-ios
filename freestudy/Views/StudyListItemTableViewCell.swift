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
    lazy var cardView = UIButton()
    lazy var studyTitle = UILabel()
    lazy var writtenAt = UILabel()

    let cardPadding = CGFloat(16)

    // MARK: Initialization

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initLayout()
    }

    func initLayout() {
        contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight

        backgroundColor = UIColor(hex: "#efefef")
        contentView.addSubview(cardView)
        cardView.backgroundColor = UIColor.whiteColor()
        cardView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).insets(UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8))
        }
        cardView.layer.cornerRadius = 1
        cardView.setBackgroundImage(UIImage.imageWithColor(UIColor.whiteColor()), forState: UIControlState.Normal)
        cardView.setBackgroundImage(UIImage.imageWithColor(UIColor(hex: "#f5f5f5")), forState: UIControlState.Highlighted)

        cardView.addSubview(areaTag)
        areaTag.frame.origin.x = cardPadding
        areaTag.frame.origin.y = cardPadding
        areaTag.textColor = UIColor.myOrangeColor()
        areaTag.font = areaTag.font.fontWithSize(14)

        cardView.addSubview(categoryTag)
        categoryTag.frame.origin.y = cardPadding
        categoryTag.font = categoryTag.font.fontWithSize(14)
        categoryTag.textColor = UIColor.a0a0a0()

        cardView.addSubview(studyTitle)
        studyTitle.numberOfLines = 0
        studyTitle.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(categoryTag.snp_bottom).offset(10)
            make.left.equalTo(cardView).offset(cardPadding)
            make.right.equalTo(cardView).offset(cardPadding * (-1))
        }
        studyTitle.font = studyTitle.font.fontWithSize(16)

        cardView.addSubview(writtenAt)
        writtenAt.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(studyTitle.snp_bottom).offset(10)
            make.left.equalTo(cardView).offset(cardPadding)
            make.bottom.equalTo(cardView).offset(cardPadding * (-1))
        }
        writtenAt.font = writtenAt.font.fontWithSize(12)
        writtenAt.textColor = UIColor.a0a0a0()
    }

    func bindStudy(study: JSON) {
        studyTitle.setHtml(study["title"].stringValue)
        studyTitle.font = UIFont.systemFontOfSize(16.0)
        cardView.tag = study["id"].intValue
        studyTitle.text = study["title"].stringValue
        
        let category = study["category"].stringValue
        let tagsManager = TagsManager.sharedInstance
        if(tagsManager.isSubSubTag(category)) {
            categoryTag.text = tagsManager.nameOf(tagsManager.parentOf(category)!)
        }
        else {
            categoryTag.text = tagsManager.nameOf(category)
        }
        areaTag.text = tagsManager.nameOf(study["area"].stringValue)
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
