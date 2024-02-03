//
//  PinterestFlowLayout.swift
//  UnsplashClone
//
//  Created by minsong kim on 2/3/24.
//

import UIKit

class PinterestFlowLayout: UICollectionViewFlowLayout {
    weak var delegate: (PinterestFlowLayoutDelegate)?
    var numberOfColumns = 2
    var cellPadding: CGFloat = 4
    
    var headerCache = [UICollectionViewLayoutAttributes]()
    //계산한 속성들을 캐시. 매 시간 다시 연산하는 것이 아닌, 캐시에 요청하는 방식으로 사용.
    private var cache = [UICollectionViewLayoutAttributes]()
    private var sectionItemAttributes = [[UICollectionViewLayoutAttributes]]()
    private var allItemAttributes = [UICollectionViewLayoutAttributes]()
    private var unionRects = [CGRect]()
    
    //content Size를 저장하기 위한 속성들.
    //contentHeight: 사진이 추가되면 증가
    //contentWidth: collectionView의 넓이와 자체 contentInset 기반으로 계산
    var contentHeight: CGFloat = 0
    var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    //collectionView의 contentSize를 반환하는 메서드 재정의
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let numberOfSections = collectionView?.numberOfSections,
              let collectionView else {
            return
        }
        
        var top: CGFloat = 0
        
//        for section in 0..<numberOfSections {
        if numberOfSections == 1 {
            let headerHeight: CGFloat = 50
            let headerInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
            
            top += headerInset.top
            
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: NSIndexPath(item: 0, section: 0) as IndexPath)
            attributes.frame = CGRect(x: headerInset.left, y: top, width: collectionView.frame.size.width - (headerInset.left + headerInset.right), height: CGFloat(headerHeight))
            
            headerCache.append(attributes)
            allItemAttributes.append(attributes)
            
            top = attributes.frame.maxY + headerInset.bottom

            //열 넓이 기반 모든 column에 대해 x좌표와 함께 xOffset 배열 채움.
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]() //cell의 x 위치를 나타내는 배열
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth)
            }
            
            //yOffset 배열은 모든 열에 대한 y위치 추적
            //각 열의 첫번째 항목의 offset이기 때문에 배열 값들을 0으로 초기화
            var column = 0 //현재 행의 위치
            var yOffset = [CGFloat](repeating: top, count: numberOfColumns) //cell의 y위치를 나타내는 배열
            //단 하나의 섹션만 있는 레이아웃
            //첫 번째 섹션의 모든 아이템 반복
            for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                
                //프레임 계산
                let photoHeight = CGFloat.random(in: 100...300)
                let height = cellPadding * 2 + (photoHeight)
                
                let frame = CGRect(x: xOffset[column],
                                   y: yOffset[column],
                                   width: columnWidth,
                                   height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                //인스턴스 생성, frame 사용하여 자체 프레임 설정, 캐시에 추가
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                allItemAttributes.append(attributes)
                
                //새로 계산된 항목의 프레임을 확장
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                //다음 항목이 다음 열에 배치되도록
                column = yOffset[0] > yOffset[1] ? 1 : 0
            }
            
            sectionItemAttributes.append(cache)
        }
        
        var idx = 0
        let itemCounts = allItemAttributes.count
        
        while idx < itemCounts {
            let rect1 = allItemAttributes[idx].frame
            idx = min(idx + 20, itemCounts) - 1
            let rect2 = allItemAttributes[idx].frame
            unionRects.append(rect1.union(rect2))
            idx += 1
        }
    }
    
//    모든 셀과 보충 뷰의 레이아웃 정보 리턴
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      
      var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
      
      for attributes in allItemAttributes {
        if attributes.frame.intersects(rect) {
          visibleLayoutAttributes.append(attributes)
        }
      }
      return visibleLayoutAttributes
    }
    
    //모든 셀의 레이아웃 정보 리턴
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return sectionItemAttributes[indexPath.section][indexPath.item]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return headerCache[indexPath.section]
    }
    
    private func invalidateIfNotEqual<T: Equatable>(_ oldValue: T, newValue: T) {
        if oldValue != newValue {
            invalidateLayout()
        }
    }
}
