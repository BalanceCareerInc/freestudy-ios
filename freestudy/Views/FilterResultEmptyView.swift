//
//  FilterResultEmptyView.swift
//  freestudy
//
//  Created by 최보철 on 2015. 9. 5..
//  Copyright (c) 2015년 studysearch. All rights reserved.
//

import SnapKit

class FilterResultEmptyView: UIView {

    let container = UIView()
    let title = UILabel()
    let subtitle = UILabel()
    let filterButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(container)
        container.addSubview(title)
        container.addSubview(subtitle)
        container.addSubview(filterButton)

        container.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(160)
        }

        title.text = "검색 결과가 없습니다."
        title.snp_makeConstraints { (make) -> Void in
            make.top.centerX.equalTo(container)
        }
        title.textColor = UIColor(hex: "#505050")
        title.font = title.font.fontWithSize(18)

        subtitle.text = "필터를 조금 더 넓은 범위로 설정해보세요"
        subtitle.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(title.snp_bottom).offset(12)
            make.centerX.equalTo(container)
        }
        subtitle.textColor = UIColor(hex: "#787878")
        subtitle.font = subtitle.font.fontWithSize(14)

        filterButton.frame.size.height = 100
        filterButton.setTitle("필터 재설정하기", forState: .Normal)
        filterButton.titleLabel?.font = filterButton.titleLabel?.font.fontWithSize(15)
        filterButton.backgroundColor = UIColor.myOrangeColor()
        filterButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(subtitle.snp_bottom).offset(32)
            make.left.equalTo(container).offset(32)
            make.right.equalTo(container).offset(-32)
            make.bottom.equalTo(container)
        }


    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
