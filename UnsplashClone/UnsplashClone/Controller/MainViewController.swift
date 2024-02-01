//
//  ViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/29/24.
//

import UIKit

class MainViewController: UIViewController {
    private var photos: Photo?
    var photoItems: [Item] = [] 
    {
        didSet {
            setSnapShot()
        }
    }
    var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    let pinterestLayout = PinterestFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        view.backgroundColor = .systemBackground
        let layout = PinterestFlowLayout()
        layout.delegate = self
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        loadPhotos()
        setDataSource()
        configureCollectionView()
    }
}

extension MainViewController: UICollectionViewDelegate {
    func configureCollectionView() {

        configureCollectionViewUI()
        
        collectionView.delegate = self
//        collectionView.dataSource = dataSource
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
        collectionView.register(BookmarkCell.self, forCellWithReuseIdentifier: BookmarkCell.id)
        setSnapShot()
    }
    
    func setDataSource() {
        //cellProvider에서 collectionView는 현재 우리가 사용하고 있는 collectionView, indexPath는 section과 item들의 index들, itemIdentifier는 우리가 정의한 item의 타입.
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .bookmark(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCell.id, for: indexPath) as? BookmarkCell else {
                    return UICollectionViewCell()
                }
                cell.configureImage(url: item.urls.regular)
                return cell
            case .recentImage(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id, for: indexPath) as? PhotoCell else {
                    return UICollectionViewCell()
                }
                cell.configureImage(title: item.title, url: item.urls.regular)
                return cell
            }
        })
    }
    
    private func setSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    
        snapshot.appendSections([Section.main])
        snapshot.appendItems(photoItems, toSection: Section.main)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
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
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click")
        print(photoItems[indexPath.item])
        let item = photoItems[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell
        guard let image = cell?.imageView.image else {
            return
        }
        let detailViewController: DetailViewController
        
        switch item {
        case .bookmark(let photo):
            detailViewController = DetailViewController(item: photo, image: image)
        case .recentImage(let photo):
            detailViewController = DetailViewController(item: photo, image: image)
        }
        
        self.present(detailViewController, animated: true)
    }
}
    
extension MainViewController {
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
                photoItems = photo.map { photoElement in
                    Item.recentImage(photoElement)
                }
                //TODO: fetch해서 얻은 photos 넘겨주기
            } catch {
                //TODO: 실패 알럿
                print(error.localizedDescription)
            }
        }
    }
}

extension MainViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightIndexPath indexPath: IndexPath) -> CGFloat {
        
//        return CGFloat(imageRatio) * cellWidth
        return CGFloat.random(in: 100...300)
    }
}

//동적인 높이가 필요할 때 정보를 제공하는 delegate
protocol PinterestLayoutDelegate: AnyObject {
    //사진의 높이를 요청하는 메소드
    func collectionView(_ collectionView: UICollectionView, heightIndexPath indexPath: IndexPath) -> CGFloat
    
}

class PinterestFlowLayout: UICollectionViewFlowLayout {
    weak var delegate: (PinterestLayoutDelegate)?
    var numberOfColumns = 2
    var cellPadding: CGFloat = 4
    
    //계산한 속성들을 캐시. 매 시간 다시 연산하는 것이 아닌, 캐시에 요청하는 방식으로 사용.
    var cache = [UICollectionViewLayoutAttributes]()
    
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
        //cache가 비어있고 collectionView가 존재할때만 연산
        guard cache.isEmpty,
              let collectionView else {
            return
        }
        
        //열 넓이 기반 모든 column에 대해 x좌표와 함께 xOffset 배열 채움.
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]() //cell의 x 위치를 나타내는 배열
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        //yOffset 배열은 모든 열에 대한 y위치 추적
        //각 열의 첫번째 항목의 offset이기 때문에 배열 값들을 0으로 초기화
        var column = 0 //현재 행의 위치
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns) //cell의 y위치를 나타내는 배열
        //단 하나의 섹션만 있는 레이아웃
        //첫 번째 섹션의 모든 아이템 반복
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            //프레임 계산
            let photoHeight = delegate?.collectionView(collectionView, heightIndexPath: indexPath) ?? 180
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
            
            //새로 계산된 항목의 프레임을 확장
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            //다음 항목이 다음 열에 배치되도록
            column = yOffset[0] > yOffset[1] ? 1 : 0
        }
    }
    
    //모든 셀과 보충 뷰의 레이아웃 정보 리턴
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      
      var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
      
      for attributes in cache {
        if attributes.frame.intersects(rect) {
          visibleLayoutAttributes.append(attributes)
        }
      }
      return visibleLayoutAttributes
    }
    
    //모든 셀의 레이아웃 정보 리턴
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      return cache[indexPath.item]
    }
}
