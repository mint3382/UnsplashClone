//
//  RandomPhotoViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/29/24.
//

import UIKit

class RandomPhotoViewController: UIViewController {
    private var photos: Photo?
    var photoItems: [PhotoElement] = []
    {
        didSet {
            setSnapShot()
        }
    }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var dataSource: UICollectionViewDiffableDataSource<Section, PhotoElement>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        loadPhotos()
        configureCollectionView()
    }
    
    func configureCollectionView() {
        configureCollectionViewUI()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RandomPhotoCell.self, forCellWithReuseIdentifier: RandomPhotoCell.id)
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        setDataSource()
        setSnapShot()
    }
    
    func setDataSource() {
        //cellProvider에서 collectionView는 현재 우리가 사용하고 있는 collectionView, indexPath는 section과 item들의 index들, itemIdentifier는 우리가 정의한 item의 타입.
        dataSource = UICollectionViewDiffableDataSource<Section, PhotoElement>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoElement>()
        
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

        return UICollectionViewCompositionalLayout (sectionProvider: {[weak self] sectionIndex, _ in
            
            return self?.createRandomPhotoSection()
        })
    }
    
    private func createRandomPhotoSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.9))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        //section
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
                
                //TODO: fetch해서 얻은 photos 넘겨주기
            } catch {
                //TODO: 실패 알럿
                print(error.localizedDescription)
            }
        }
    }
}
