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
        loadPhotos()
        configureCollectionView()
    }
}

extension MainViewController {
    func configureCollectionView() {
        configureCollectionViewUI()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
        collectionView.register(BookmarkCell.self, forCellWithReuseIdentifier: BookmarkCell.id)
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        setDataSource()
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
                cell.configureImage(title: item.id, url: item.urls.regular)
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
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ in
            
            return self?.createPhotoSection()
        }
    }
    
    private func createPhotoSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
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
