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
            make.centerY.equalTo(self)
        }

        title.text = "검색 결과가 없습니다."
        title.snp_makeConstraints { (make) -> Void in
            make.top.centerX.equalTo(container)
        }

        subtitle.text = "필터를 조금 더 넓은 범위로 설정해보세요"
        subtitle.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(title.snp_bottom)
            make.centerX.equalTo(container)
        }

        filterButton.setTitle("필터 재설정하기", forState: .Normal)
        filterButton.backgroundColor = UIColor.myOrangeColor()
        filterButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(subtitle.snp_bottom).offset(7)
            make.left.equalTo(subtitle)
            make.right.equalTo(subtitle)
            make.bottom.equalTo(container)
        }


    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
