//
//  ViewController.swift
//  FHXUnequalBtnLayoutView
//
//  Created by fenghanxu on 08/08/2018.
//  Copyright (c) 2018 fenghanxu. All rights reserved.
//

import UIKit
import Then
import FHXUnequalBtnLayoutView
import FHXColorAndFont

class ViewController: UIViewController {
  
  fileprivate let currentView = UnequalBtnLayoutView().then { (item) in
    item.collection.cellHeight = 25//cell的高度
    item.collection.columnsCount = 4//cell的行数
    item.collectionView.backgroundColor = Color.white//CollectionView的背景颜色(不用设置)
    item.cellMessage.cellBackgroundColor = Color.white//cell的背景颜色
    item.cellMessage.controlBackgroundColor = Color.white//控件背景颜色(不用设置)
    item.cellMessage.controlWordsColor = Color.theme//文字颜色
    item.cellMessage.controlUIFont = Font.font14//文字大小
    item.cellMessage.controlBorderColor = Color.theme.cgColor//边框颜色
    item.cellMessage.controlCornerRadius = 4//圆弧半径
    item.cellMessage.controlBorderWidth = 1//边框宽度
  }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
 
      view.addSubview(currentView)
      
      currentView.list = ["cell的高度","cell的行数","Collection","View","的背景颜色","不用设置","cell","背景颜色","控件背景颜色","文字颜色","文字颜色","文字大小","边框颜色","圆弧半径","边框宽度"]
      
      currentView.snp.makeConstraints { (make) in
        make.top.equalToSuperview().offset(200)
        make.width.equalToSuperview()
        make.height.equalTo(currentView.viewHeight)
        make.centerX.equalToSuperview()
      }
      
    }



}

