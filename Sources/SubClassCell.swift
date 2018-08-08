//
//  SubClassCell.swift
//  B7iOSBuy
//
//  Created by 膳品科技 on 2016/11/8.
//  Copyright © 2016年 www.spzjs.com. All rights reserved.
//

import UIKit
import FHXColorAndFont
import SnapKit

class SubClassCell: UICollectionViewCell {

 fileprivate let button = UIButton(type: .custom)

  override init(frame: CGRect) {
    super.init(frame: frame)
    buildUI()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
    var name: String = String(){
        didSet{
            button.setTitle(name, for: .normal)
        }
    }
  
    var cellMessage = UnequalBtnLayoutView.CellMessage(){
      didSet{
        if cellMessage.controlUIFont != oldValue.controlUIFont {
          backgroundColor = cellMessage.cellBackgroundColor
          button.layer.borderWidth = cellMessage.controlBorderWidth
          button.layer.borderColor = cellMessage.controlBorderColor
          button.layer.cornerRadius = cellMessage.controlCornerRadius
          button.setTitleColor(cellMessage.controlWordsColor, for: .normal)
          button.titleLabel?.font = cellMessage.controlUIFont
          button.backgroundColor = cellMessage.controlBackgroundColor
        }
      }
    }

}

extension SubClassCell {

  fileprivate func buildUI() {
    addSubview(button)
    buildLayout()
    buildSubView()
  }

  fileprivate func buildLayout() {
    button.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(2.5)
      make.bottom.equalToSuperview().offset(-2.5)
      make.left.equalToSuperview().offset(2.5)
      make.right.equalToSuperview().offset(-2.5)
    }
  }

  fileprivate func buildSubView() {
    button.isUserInteractionEnabled = false
    button.layer.borderWidth = 1
    button.layer.borderColor = Color.price.cgColor
    button.layer.cornerRadius = 4
    button.layer.masksToBounds = true
    button.setTitleColor(Color.price, for: .normal)
    button.titleLabel?.textAlignment = .center
    button.titleLabel?.font = Font.font12
  }

}
