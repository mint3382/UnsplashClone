//
//  RandomPhotoViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/29/24.
//

import UIKit

class RandomPhotoViewController: UIViewController {
    private var photos: Photo?
    private var photoItems: [PhotoElement] = []
    {
        didSet {
            setSnapShot()
        }
    }
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var dataSource: UICollectionViewDiffableDataSource<Int, PhotoElement>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        loadPhotos()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        configureCollectionViewUI()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RandomPhotoCell.self, forCellWithReuseIdentifier: RandomPhotoCell.id)
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        setDataSource()
        setSnapShot()
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, PhotoElement>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RandomPhotoCell.id, for: indexPath) as? RandomPhotoCell else {
                return UICollectionViewCell()
            }
            cell.configureImage(url: self.photoItems[indexPath.item].urls.regular)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.2
            cell.layer.shadowRadius = 5
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            return cell
        })
    }
    
    private func setSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, PhotoElement>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(photoItems, toSection: 0)
        
        dataSource?.apply(snapshot)
    }
    
    private func configureCollectionViewUI() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 8)
        ])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {

        return UICollectionViewCompositionalLayout (sectionProvider: {[weak self] sectionIndex, _ in
            
            return self?.createRandomPhotoSection()
        })
    }
    
    private func createRandomPhotoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.9))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: -5, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
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
                    photoItems.append(photoElement)
                }
            } catch {
                //TODO: 실패 알럿
                print(error.localizedDescription)
            }
        }
    }
}
