//
//  RecentImageViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/29/24.
//

import UIKit

class RecentImageViewController: UIViewController, UICollectionViewDelegate {
    private var photos: Photo?
    private var photoItems: [PhotoElement] = []
    {
        didSet {
            setSnapShot()
        }
    }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, PhotoElement>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
        
        loadPhotos()
        configureCollectionView()
        configureCollectionViewUI()
        collectionView.reloadData()
        setDataSource()
        setSnapShot()
    }
}

extension RecentImageViewController {
    //컬렉션뷰 위치 잡기
    func configureCollectionViewUI() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
    
    //컬렉션뷰 등록하기
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.delegate = self
//        collectionView.dataSource = self
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
        //헤더뷰 등록
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        
        //레이아웃 설정하기
        let layout = PinterestFlowLayout()
        layout.headerReferenceSize = .init(width: 300, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
//    데이터소스 세팅
    func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, PhotoElement>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id, for: indexPath) as? PhotoCell else {
                return UICollectionViewCell()
            }
            cell.configureImage(title: itemIdentifier.title, url: itemIdentifier.urls.small)
            return cell
        })
        dataSource?.supplementaryViewProvider = { view, kind, indexPath in
            guard let header = view.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as? HeaderView else {
                return .init()
            }
            header.configureLabel(text: "최신 이미지")
            return header
        }
    }
    
//    스냅샷 세팅
    private func setSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, PhotoElement>()
        snapshot.appendSections([0])
        snapshot.appendItems(photoItems, toSection: 0)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
   
    //cell 클릭시 디테일뷰로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = photoItems[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell
        guard let image = cell?.imageView.image else {
            return
        }
        let detailViewController: DetailViewController
       
        detailViewController = DetailViewController(item: item, image: image)
        self.present(detailViewController, animated: true)
    }
}
    
extension RecentImageViewController {
    private func loadPhotos() {
        let endPoint = EndPoint(queries: nil)
        let apiProvider = APIProvider()
        guard let request = endPoint.configureRequest() else {
            //TODO: 실패 알럿
            return
        }
        
        Task {
            do {
                let photo = try await apiProvider.fetchData(decodingType: Photo.self, request: request)
                photoItems = photo
                //TODO: fetch해서 얻은 photos 넘겨주기
            } catch {
                //TODO: 실패 알럿
                print(error.localizedDescription)
            }
        }
    }
}

extension RecentImageViewController: PinterestFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat.random(in: 100...300)
    }
}

//동적인 높이가 필요할 때 정보를 제공하는 delegate
protocol PinterestFlowLayoutDelegate: AnyObject {
    //사진의 높이를 요청하는 메서드
    func collectionView(_ collectionView: UICollectionView, heightIndexPath indexPath: IndexPath) -> CGFloat
    
}

class PinterestFlowLayout: UICollectionViewFlowLayout {
    weak var delegate: (PinterestFlowLayoutDelegate)?
    var numberOfColumns = 2
    var cellPadding: CGFloat = 4
    
    var headerCache = [UICollectionViewLayoutAttributes]()
    //계산한 속성들을 캐시. 매 시간 다시 연산하는 것이 아닌, 캐시에 요청하는 방식으로 사용.
    var cache = [UICollectionViewLayoutAttributes]()
    
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
            let headerInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            
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
