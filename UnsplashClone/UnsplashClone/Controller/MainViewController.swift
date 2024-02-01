//
//  ViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/29/24.
//

import UIKit

class MainViewController: UIViewController {
    private var photos: Photo?
    var photoItems: [Item] = [] {
        didSet {
            setSnapShot()
        }
    }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        view.backgroundColor = .systemBackground
        collectionView.delegate = self
        loadPhotos()
        configureCollectionView()
    }
}

extension MainViewController: UICollectionViewDelegate {
    func configureCollectionView() {
        configureCollectionViewUI()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
        collectionView.register(BookmarkCell.self, forCellWithReuseIdentifier: BookmarkCell.id)
        setDataSource()
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
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
        
        dataSource?.apply(snapshot)
    }
    
    func configureCollectionViewUI() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 8)
        ])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30
        let conf = UICollectionLayoutWaterfallConfiguration { indexPath in
            let item = self.photoItems[indexPath.item]
//            let size: CGSize
            switch item {
            case .bookmark(let photo):
                return photo.size
            case .recentImage(let photo):
                return photo.size
            }
            
//            return CGSize(width: 0, height: 0)
        }
        
        let layout = UICollectionViewCompositionalLayout.waterfall(configuration: conf)
        
        return layout
        
//        return UICollectionViewCompositionalLayout (sectionProvider: {[weak self] sectionIndex,a  in
//            
//            return self?.createPhotoSection()
//        },configuration: config)
    }
    
    private func createPhotoSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let itemSize2 = NSCollectionLayoutSize(widthDimension: .absolute(170), heightDimension: .absolute(200))
        let item2 = NSCollectionLayoutItem(layoutSize: itemSize2)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute((view.frame.width - 8) / 2), heightDimension: .estimated(300))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item2])
        group.interItemSpacing = .fixed(8)
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
//        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: -5, trailing: 10)
        
        return section
    }
    
    private func createBookmarkSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(view.frame.width / 2 - 8), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .continuous
        
        return section
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
//        detailViewController.modalPresentationStyle = .fullScreen
        self.present(detailViewController, animated: true)
//        self.navigationController?.pushViewController(detailViewController, animated: true)
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
                photo.forEach { photoElement in
                    photoItems.append(Item.recentImage(photoElement))
                }
                
                //TODO: fetch해서 얻은 photos 넘겨주기
            } catch {
                //TODO: 실패 알럿
                print(error.localizedDescription)
            }
        }
    }
}


class LayoutItemProvider {
    private var columnHeights: [CGFloat]
    private let columnCount: CGFloat
    private let itemSizeProvider: UICollectionViewWaterfallLayoutItemSizeProvider
//    private let itemSizeProvider: CGSize
    private let spacing: CGFloat
    private let contentSize: CGSize
    
    init(
//        configuration: CGSize
        configuration: UICollectionLayoutWaterfallConfiguration,
        environment: NSCollectionLayoutEnvironment
    ) {
        self.columnHeights = [CGFloat](repeating: 0, count: configuration.columnCount)
        self.columnCount = CGFloat(configuration.columnCount)
        self.itemSizeProvider = configuration.itemSizeProvider
        self.spacing = configuration.spacing
        self.contentSize = environment.container.effectiveContentSize
    }
    
    func item(for indexPath: IndexPath) -> NSCollectionLayoutGroupCustomItem {
        let frame = frame(for: indexPath)
        columnHeights[columnIndex()] = frame.maxY + spacing
        return NSCollectionLayoutGroupCustomItem(frame: frame)
    }
    
    private func frame(for indexPath: IndexPath) -> CGRect {
        let size = itemSize(for: indexPath)
        let origin = itemOrigin(width: size.width)
        return CGRect(origin: origin, size: size)
    }
    
    private func itemOrigin(width: CGFloat) -> CGPoint {
        let y = columnHeights[columnIndex()].rounded()
        let x = (width + spacing) * CGFloat(columnIndex())
        return CGPoint(x: x, y: y)
    }
    
    private func itemSize(for indexPath: IndexPath) -> CGSize {
        let width = itemWidth()
//        let width = CGFloat(300)
        let height = itemHeight(for: indexPath, itemWidth: width)
//        let height = CGFloat(Int.random(in: 150...400))
        return CGSize(width: width, height: height)
    }
    
    private func itemWidth() -> CGFloat {
        let spacing = (columnCount - 1) * spacing
//        return (contentSize.width - spacing) / columnCount
        return (390 - spacing) / columnCount
    }
    
    private func itemHeight(for indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        let itemSize = itemSizeProvider(indexPath)
        let aspectRatio = itemSize.height / itemSize.width
        let itemHeight = itemWidth * aspectRatio
        return itemHeight.rounded()
    }
    
    private func columnIndex() -> Int {
        columnHeights
            .enumerated()
            .min(by: { $0.element < $1.element })?
            .offset ?? 0
    }
}

struct UICollectionLayoutWaterfallConfiguration {
    var columnCount: Int
    var spacing: CGFloat
    var contentInsetsReference: UIContentInsetsReference
//    var itemSizeProvider: CGSize
    var itemSizeProvider: UICollectionViewWaterfallLayoutItemSizeProvider
    
    init(
        columnCount: Int = 2,
        spacing: CGFloat = 8,
        contentInsetsReference: UIContentInsetsReference = .automatic,
//        itemSizeProvider: CGSize
        itemSizeProvider: @escaping UICollectionViewWaterfallLayoutItemSizeProvider
    ) {
        self.columnCount = columnCount
        self.spacing = spacing
        self.contentInsetsReference = contentInsetsReference
        self.itemSizeProvider = itemSizeProvider
    }
}

extension UICollectionViewCompositionalLayout {
    
    static func waterfall(
        columnCount: Int = 2,
        spacing: CGFloat = 8,
        contentInsetsReference: UIContentInsetsReference = .automatic,
//        itemSizeProvider: CGSize
        itemSizeProvider: @escaping UICollectionViewWaterfallLayoutItemSizeProvider
    ) -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionLayoutWaterfallConfiguration(
            columnCount: columnCount,
            spacing: spacing,
            contentInsetsReference: contentInsetsReference,
            itemSizeProvider: itemSizeProvider
        )
        return waterfall(configuration: configuration)
    }
    
    static func waterfall(configuration: UICollectionLayoutWaterfallConfiguration) -> UICollectionViewCompositionalLayout {
        
        var numberOfItems: (Int) -> Int = { _ in 0 }
        
        let layout = UICollectionViewCompositionalLayout { section, environment in
            
            let groupLayoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(environment.container.effectiveContentSize.height)
//                heightDimension: .absolute(CGFloat(Int.random(in: 170...300)))
            )
            
            let group = NSCollectionLayoutGroup.custom(layoutSize: groupLayoutSize) { environment in
                let itemProvider = LayoutItemProvider(configuration: configuration, environment: environment)
                var items = [NSCollectionLayoutGroupCustomItem]()
                for i in 0..<numberOfItems(section) {
                    let indexPath = IndexPath(item: i, section: section)
                    let item = itemProvider.item(for: indexPath)
                    items.append(item)
                }
                return items
            }
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsetsReference = configuration.contentInsetsReference
            return section
        }
        
        numberOfItems = { [weak layout] in
            layout?.collectionView?.numberOfItems(inSection: $0) ?? 0
        }
        
        return layout
    }
}

typealias UICollectionViewWaterfallLayoutItemSizeProvider = (IndexPath) -> CGSize
