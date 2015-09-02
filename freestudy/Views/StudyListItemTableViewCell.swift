//
//  StudyListItemTableViewCell.swift
//  freestudy
//
//  Created by 최보철 on 2015. 9. 2..
//  Copyright (c) 2015년 studysearch. All rights reserved.
//

import SnapKit

class StudyListItemTableViewCell: UITableViewCell {

    // MARK: Properties

    lazy var cardView = UIView()
    lazy var studyTitle = UILabel()

    // MARK: Initialization

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initLayout()
    }

    func initLayout() {
        backgroundColor = UIColor.grayColor()

        self.addSubview(cardView)
        cardView.backgroundColor = UIColor.whiteColor()
        cardView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self).insets(UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 14))
        }
        cardView.layer.cornerRadius = 1
        cardView.layer.masksToBounds = false
        cardView.layer.shadowOffset = CGSizeMake(0, 0.5)
        cardView.layer.shadowRadius = 1
        cardView.layer.shadowOpacity = 0.2

        cardView.addSubview(self.studyTitle)
        studyTitle.numberOfLines = 0

        studyTitle.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(cardView).insets(UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 14))
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
