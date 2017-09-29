//
//  IBCardLayout.swift
//  CCardTest
//
//  Created by Luofei on 2017/9/26.
//  Copyright © 2017年 FreeMud. All rights reserved.
//

import UIKit

let centerScale:CGFloat = 0.05;

class IBCardLayout: UICollectionViewFlowLayout {
    
    var cycleIndex:Int!
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let items = makeLayoutAttributeItems()
        var absOffset:CGFloat!
        var scale:CGFloat!
        
        for attributes in items {
            //获取每个item距离可见区域左侧边框距离
            let leftMargin = attributes.center.x - (self.collectionView?.contentOffset.x)!
            //2. 获取边框距离屏幕中心的距离（固定的）
            let halfCenterX = (self.collectionView?.frame.size.width)!/2
            //3. 获取距离中心的的偏移量，需要绝对值
            absOffset = fabs(halfCenterX - leftMargin)
            //4. 获取的实际的缩放比例 距离中心越多，这个值就越小，也就是item的scale越小 中心是方法最大的
            scale = 1 - absOffset/halfCenterX
            
            scale = sin(scale)
            
            attributes.transform = CGAffineTransform(scaleX: 1+scale*centerScale, y: 1+scale*centerScale);
        }
        
        return items

    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        super.shouldInvalidateLayout(forBoundsChange: newBounds)
        return true
    }

    // 获取可见区域
    private func makeLayoutAttributeItems() -> [UICollectionViewLayoutAttributes] {
        //确定加载item的区域
        let x =  collectionView!.contentOffset.x
        let w = collectionView!.frame.size.width
        let h = collectionView!.frame.size.height
        let myrect = CGRect(x: x, y: 0, width: w, height: h)
        guard let arr = super.layoutAttributesForElements(in: myrect) else {
            fatalError()
        }
        let hehe = arr.map{$0.copy() as! UICollectionViewLayoutAttributes}
        //获得这个区域的item
        return hehe
    }
    
    //让cell停在中间位置
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var contentOffset = proposedContentOffset
        
        let items = makeLayoutAttributeItems()
        if items.count > 0 {
            var mindelta = CGFloat.greatestFiniteMagnitude
            for item in items {
                //获得item距离左边的边框的距离
                let leftdelta = item.center.x - contentOffset.x
                //获得屏幕的中心点
                let centerX = collectionView!.frame.size.width * 0.5
                //获得距离中心的距离
                let dela = fabs(centerX - leftdelta)
                //获得最小的距离
                if (dela <= mindelta){
                    mindelta = centerX - leftdelta
                }
            }
            contentOffset.x -= mindelta
            
            //防止在第一个和最后一个 滑到中间时 卡住
            if (contentOffset.x < 0) {
                contentOffset.x = 0
            }
            
            if (contentOffset.x > (collectionView!.contentSize.width-sectionInset.left-sectionInset.right-itemSize.width*1.5)) {
                contentOffset.x = floor(contentOffset.x);
            }
            
        }
        return contentOffset
    }
}
