//
//  RecentImageViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/29/24.
//

import UIKit
import CoreData

final class MainViewController: UIViewController, UICollectionViewDelegate, UIImageDownloadable {
    let apiProvider: APIProvider = APIProvider()
    private var photoItems: [PhotoElement] = [] {
        didSet {
            collectionView.setCollectionViewLayout(PinterestFlowLayout(), animated: true)
            setSnapShot()
        }
    }

    private var constraints: [NSLayoutConstraint] = []
    private var bookmarkController: BookmarkViewController?
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, PhotoElement>?
    private let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        loadPhotos()
        configureCollectionView()
        updateBookMarkViewController()
        configureCollectionViewUI()
        setDataSource()
        setSnapShot()
        initRefresh()
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
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
//    데이터소스 세팅
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, PhotoElement>(collectionView: collectionView, cellProvider: { [self] collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id, for: indexPath) as? PhotoCell else {
                return UICollectionViewCell()
            }
            var image: UIImage?
            Task {
                do {
                    image = try await downloadImage(url: itemIdentifier.urls.small)
                } catch {
                    image = UIImage(named: "noImage")
                }
                cell.configureImage(title: itemIdentifier.title, image: image)
            }
            
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
        guard let url = endPoint.url else {
            //TODO: 실패 알럿
            return
        }
        
        Task {
            do {
                let photo = try await apiProvider.fetchDecodedData(type: Photo.self, from: url)
                photoItems = photo
            } catch {
                //TODO: 실패 알럿
                print(error.localizedDescription)
            }
        }
    }
}

extension MainViewController: BookmarkDelegate {
    func updateConfiguration() {
        bookmarkController?.bookmarks = PhotoService.shared.fetchData()
        
        view.removeConstraints(constraints)
        updateBookMarkViewController()
        configureCollectionViewUI()
    }
}

extension MainViewController {
    func initRefresh() {
        refresh.addTarget(self, action: #selector(refreshCollectionView(refresh:)), for: .valueChanged)
        refresh.backgroundColor = UIColor.red
        refresh.attributedTitle = NSAttributedString(string: "Loading...")
        self.collectionView.refreshControl = refresh
    }
    
    @objc func refreshCollectionView(refresh: UIRefreshControl) {
        loadPhotos()
        refresh.endRefreshing()
    }
}
