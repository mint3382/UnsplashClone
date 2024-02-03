//
//  RecentImageViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/29/24.
//

import UIKit
import CoreData

final class MainViewController: UIViewController, UICollectionViewDelegate {
    private var photos: Photo?
    private var photoItems: [PhotoElement] = []
    {
        didSet {
            setSnapShot()
        }
    }

    var constraints: [NSLayoutConstraint] = []
    private var bookmarkController: BookmarkViewController?
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, PhotoElement>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        view.backgroundColor = .systemBackground
        
        loadPhotos()
        configureCollectionView()
        updateBookMarkViewController()
        configureCollectionViewUI()
        collectionView.reloadData()
        setDataSource()
        setSnapShot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.removeConstraints(constraints)
        updateBookMarkViewController()
        configureCollectionViewUI()
    }
    
    private func updateBookMarkViewController() {
        bookmarkController = BookmarkViewController()
        bookmarkController?.delegate = self
        
        guard PhotoService.shared.isBookmarkExist(),
                let bookmarkController else {
            return
        }
        
        addChild(bookmarkController)
        view.addSubview(bookmarkController.view)
        bookmarkController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookmarkController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bookmarkController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bookmarkController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bookmarkController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.22)
        ])
             
        bookmarkController.didMove(toParent: self)
    }
}

extension MainViewController {
    //컬렉션뷰 위치 잡기
    private func configureCollectionViewUI() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        if PhotoService.shared.isBookmarkExist(),
           let bookmarkController {
            constraints = [
                collectionView.topAnchor.constraint(equalTo: bookmarkController.view.bottomAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
                collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
            ]
        } else {
            constraints = [
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
                collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
            ]
        }
        
        view.addConstraints(constraints)
        view.updateConstraints()
        
    }
    
    //컬렉션뷰 등록하기
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.delegate = self
        
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
    private func setDataSource() {
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
       
        let detailItem = DetailElement(
            id: item.id,
            title: item.title,
            width: item.width,
            height: item.height,
            descriptions: item.description,
            altDescription: item.altDescription,
            urls: item.urls.regular.absoluteString,
            likedByUser: PhotoService.shared.isBookmarkedData(item),
            user: item.user)
        detailViewController = DetailViewController(item: detailItem, image: image)
        detailViewController.delegate = bookmarkController
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
                photoItems = photo
            } catch {
                //TODO: 실패 알럿
                print(error.localizedDescription)
            }
        }
    }
}

extension MainViewController: BookmarkProtocol {
    func updateConfiguration() {
        bookmarkController?.bookmarks = PhotoService.shared.fetchData()
        
        view.removeConstraints(constraints)
        updateBookMarkViewController()
        configureCollectionViewUI()
    }
}
