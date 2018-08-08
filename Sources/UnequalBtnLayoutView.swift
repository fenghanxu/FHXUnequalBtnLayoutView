//
//  UnequalBtnLayoutView.swift
//  sharesChonse
//
//  Created by 冯汉栩 on 2018/6/20.
//  Copyright © 2018年 fenghanxuCompany. All rights reserved.
//

import UIKit
import FHXColorAndFont

public class UnequalBtnLayoutView: UIView {

  public var list = [String]()
  
  //创建一个属性拥有了collectionView需要用到的信息
  public var collection = CollectionData(){
    didSet{
      if collection.columnsCount != oldValue.columnsCount {
        viewHeight = collection.cellHeight * CGFloat(collection.columnsCount)
      }
    }
  }
  
  //cell的信息
  public var cellMessage = CellMessage()
  //整个控件的高度
  public var viewHeight:CGFloat = 0
  
  //创建一个collectionView用到的数组信息
  public struct CollectionData {
   public var cellSizes = [CGSize]()//每个cell的宽高(高度其实就是下面的40)
   public var height: CGFloat = 0.0//collection的高度(collectionView的高度有可能会大于view的高度，这是可以上下滑动)(创建不用设置)
   public var width: CGFloat = 0//collection的宽度(没什么用，一般都是整个view的宽度)
   public var cellHeight: CGFloat = 0//cell的高度(创建是设置)
   public var columnsCount = Int.max//限制的行数(创建是设置)
  }
  
  //cell信息
  public struct CellMessage {
   public var cellBackgroundColor:UIColor = Color.white//cell的背景颜色
   public var controlBorderWidth:CGFloat = 1//控件边框高度
   public var controlBorderColor:CGColor = Color.theme.cgColor//边框颜色
   public var controlCornerRadius:CGFloat = 4//圆角半径
   public var controlUIFont:UIFont = Font.font14//文字大小
   public var controlWordsColor:UIColor = Color.theme//文字颜色
   public var controlBackgroundColor:UIColor = Color.white//控件背景颜色
  }
  
  public let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    buildUI()
    
  }
  
  override public func layoutSubviews() {
    if list.value(at: 0) ?? String() != String() {
      dealCollectionViews()
      collectionView.snp.updateConstraints({ (make) in
        make.height.equalTo(collection.height)
      })
      collectionView.delegate = self
      collectionView.dataSource = self
      collectionView.reloadData()
    }
  }
  
  fileprivate func buildUI() {
    backgroundColor = Color.white
    addSubview(collectionView)
    buildSubView()
    buildLayout()
  }
  
  fileprivate func buildSubView() {
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = Color.white
    collectionView.register(SubClassCell.self, forCellWithReuseIdentifier: "kSubClassCell")
  }
  
  fileprivate func buildLayout(){
    collectionView.snp.makeConstraints { (make) in
      make.top.left.right.equalToSuperview()
      make.height.equalTo(1)
    }
  }

}

//------------------------
extension UnequalBtnLayoutView {
  
  fileprivate func dealCollectionViews() {
    /// 全部元素宽度
    var widths = [CGFloat]()
    /// 每行每个元素宽度
    var rows = [(items:[CGFloat],spec: CGFloat)]()
    /// 最后使用的元素宽度
    var newWidths = [CGFloat]()
    
    do {
      for item in 0..<list.count {
        let subclass = list[item]
        
        let width = subclass.bounds(font: Font.font14,
                                    size: CGSize(width: CGFloat(MAXFLOAT),
                                                 height: collection.cellHeight)).size.width + 10
        
        /// 近似值处理
        var value: CGFloat = width.floor
        if value < 35 { value = 35 }
        if let num = value.int.string.characters.last?.int {
          switch num {
          case 0...2:
            value = (value / 10).floor * 10
          case 3...6:
            value = (value / 10).floor * 10 + 5
          case 7...9:
            value = (value / 10).floor * 10 + 10
          default: break
          }
        }
        widths.append(value)
      }
    }
    
    do{
      /// 缓存变量: 临时存储每行元素
      var row: (items:[CGFloat],spec: CGFloat) = ([],0)
      for item in widths {
        row.items.append(item)
        let specWidth = row.items.reduce(0, { (item1, item2) -> CGFloat in
          return item1 + item2
        })
        let spec = ((bounds.size.width - specWidth) / row.items.count.cgFloat).floor
        if spec <= 0 {
          row.items.removeLast()
          rows.append(row)
          row = ([],0)
          row.items.append(item)
        }else{
          row.spec = spec
        }
      }
      rows.append(row)
    }
    
    /// 处理最后一行文本与单行文本
    do{
      let last = rows.last
      rows = rows.map({ (item) -> (items:[CGFloat],spec: CGFloat) in
        if item.items.count == 1 {
          return ([bounds.size.width],0)
        }
        return (item.items,item.spec)
      })
      if var last = last {
        rows.removeLast()
        if last.items.count == 1 {
          let spec = bounds.size.width - (last.items.first ?? 0)
          if spec > 10 { last.spec = 10 }
        }
        rows.append(last)
      }
    }
    
    /// 最后的数据拼接
    do{
      for row in rows {
        row.items.forEach({ (width) in
          newWidths.append(width + row.spec)
        })
      }
    }
    
    let rowCount = rows.count
    //如果算出CollectionView的行数大于某个值，就限制某个行数，否则在行数范围内，就显示当前行数
    collection.height = (rowCount > collection.columnsCount ? collection.columnsCount: rowCount).cgFloat * collection.cellHeight
    //把算出来的宽度通过遍历一个一个添加到cell数组中
    collection.cellSizes = newWidths.map({ (itemWidth) -> CGSize in
      CGSize(width: itemWidth, height: collection.cellHeight)
    })
    
  }
  
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UnequalBtnLayoutView: UICollectionViewDelegateFlowLayout {
  
  public func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collection.cellSizes[indexPath.item]
  }
  
  public func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  public func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
}

extension UnequalBtnLayoutView: UICollectionViewDelegate,UICollectionViewDataSource{
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return list.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kSubClassCell", for: indexPath) as! SubClassCell
    cell.cellMessage = cellMessage
    cell.name = list[indexPath.item]
    return cell
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        print("\(historiesArr[indexPath.item])")
    
  }
  
}

