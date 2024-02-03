//
//  PinterestFlowLayoutDelegate.swift
//  UnsplashClone
//
//  Created by minsong kim on 2/3/24.
//

import UIKit

//동적인 높이가 필요할 때 정보를 제공하는 delegate
protocol PinterestFlowLayoutDelegate: AnyObject {
    //사진의 높이를 요청하는 메서드
    func collectionView(_ collectionView: UICollectionView, heightIndexPath indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView) -> CGFloat
}
