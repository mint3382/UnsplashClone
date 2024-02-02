//
//  BookmarkViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 2/2/24.
//

import UIKit
import CoreData

class BookmarkViewController: UIViewController, UICollectionViewDelegate {
    var container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).container {
        didSet {
            fetchData()
        }
    }
    
    private var bookmarks: [DetailElement] = []
    {
        didSet {
            setSnapshot()
        }
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, DetailElement>?
    

    override func viewDidLoad() {
        super.viewDidLoad()

//        configureView()
        fetchData()
        registerCollectionView()
        configureCollectionVewUI()
        setDataSource()
        setSnapshot()
    }
    
//    func configureView() {
//        NSLayoutConstraint.activate([
//            view.widthAnchor.constraint(equalToConstant: view.frame.width),
//            view.heightAnchor.constraint(equalToConstant: 300)
//        ])
//    }
    
    //컬렉션뷰 위치 오토 레이아웃
    func configureCollectionVewUI() {
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
    func registerCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        collectionView.register(BookmarkCell.self, forCellWithReuseIdentifier: BookmarkCell.id)
        
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        collectionView.delegate = self
    }
    
    //컬렉션뷰 레이아웃 등록
    func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            return self?.createBookmarkSection()
        })
    }
    
    //레이아웃에 넣을 섹션 등록
    func createBookmarkSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
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
    func setDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Int, DetailElement>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BookmarkCell.id,
                for: indexPath) as? BookmarkCell else {
                return UICollectionViewCell()
            }
            cell.configureImage(url: URL(string: itemIdentifier.urls)!)
            
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
    func setSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DetailElement>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(bookmarks, toSection: 0)
        
        dataSource?.apply(snapshot)
    }
}

extension BookmarkViewController: CoreDataManageable {
    func fetchData() {
        do {
            var detailElementDatas = [DetailElement]()
            let photoData = try container.viewContext.fetch(BookmarkMO.fetchRequest())
            photoData.forEach { data in
                if let id = data.id,
                   let title = data.title,
                   let altDescriptions = data.altDescription,
                   let urls = data.urls,
                   let userData = data.user {
                    let user = User(id: userData.id!, username: userData.username!)
                    let photo = DetailElement(id: id, title: title, width: Int(data.width), height: Int(data.height), descriptions: data.descriptions, altDescription: altDescriptions, urls: urls, likedByUser: data.likedByUser, user: user)
                    detailElementDatas.append(photo)
                }
            }
            bookmarks = detailElementDatas
        } catch {
            print(error.localizedDescription)
        }
    }
}
