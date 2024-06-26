//
//  BookmarkViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 2/2/24.
//

import UIKit
import CoreData

final class BookmarkViewController: UIViewController, UICollectionViewDelegate, UIImageDownloadable {
    let apiProvider: APIProvider = APIProvider()
    
    var bookmarks: [DetailElement] = PhotoService.shared.fetchData()
    {
        didSet {
            setSnapshot()
        }
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, DetailElement>?
    var delegate: BookmarkDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        bookmarks = PhotoService.shared.fetchData()
        registerCollectionView()
        configureCollectionViewUI()
        setDataSource()
        setSnapshot()
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bookmarks = PhotoService.shared.fetchData()
    }
    
    //컬렉션뷰 위치 오토 레이아웃
    private func configureCollectionViewUI() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 8)
        ])
    }
    
    //컬렉션뷰 등록
    private func registerCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
        
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        collectionView.delegate = self
    }
    
    //컬렉션뷰 레이아웃 등록
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            return self?.createBookmarkSection()
        })
    }
    
    //레이아웃에 넣을 섹션 등록
    private func createBookmarkSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(130), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: -5, trailing: 5)
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    //디퍼블 데이터 소스 세팅
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, DetailElement>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PhotoCell.id,
                    for: indexPath) as? PhotoCell else {
                    return UICollectionViewCell()
                }
                var image: UIImage?
                guard let url = URL(string: itemIdentifier.urls) else {
                    return cell
                }
                Task {
                    do {
                        image = try await self.downloadImage(url: url)
                    } catch {
                        image = UIImage(named: "noImage")
                    }
                    cell.configureImage(title: itemIdentifier.title, image: image)
                }
                
                return cell
        })
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<HeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
            supplementaryView, elementKind, indexPath in
            supplementaryView.configureLabel(text: "북마크")
        }
        
        dataSource?.supplementaryViewProvider = { (view, kind, index) in
            self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
    
    //스냅샷 세팅
    private func setSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DetailElement>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(bookmarks, toSection: 0)
        
        dataSource?.apply(snapshot)
    }
    
    //cell 클릭시 디테일뷰로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = bookmarks[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell
        guard let image = cell?.imageView.image else {
            return
        }
        let detailViewController: DetailViewController
       
        detailViewController = DetailViewController(item: item, image: image)
        detailViewController.delegate = self
        detailViewController.modalPresentationStyle = .overFullScreen
        self.present(detailViewController, animated: true)
    }
}

extension BookmarkViewController: DetailDelegate {
    func updateSnapshot() {
        bookmarks = PhotoService.shared.fetchData()
        delegate?.updateConfiguration()
    }
}
