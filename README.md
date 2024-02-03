# 🎞️ Unsplash Clone

> 프로젝트 기간: 24.01.29 ~ 24.02.04

## 📖 목차
1. [🍀 소개](#소개)
2. [💻 실행 화면](#실행-화면)
3. [🧨 트러블 슈팅](#트러블-슈팅)
4. [📚 참고 링크](#참고-링크)
5. [👥 회고](#회고)

</br>

<a id="소개"></a>

## 🍀 소개
감각적인 이미지를 랜덤하게 받아 보고, 원하는 것을 북마크에 저장할 수 있다. 
</br>
소장하고 싶은 이미지는 다운로드가 가능! 나만의 스타일을 찾아 저장해보는 건 어떠신지?


</br>

<a id="실행-화면"></a>

## 💻 실행 화면

| 북마크가 있는 메인 화면 | 북마크가 없는 메인 화면 |
|:--------:|:--------:|
|<img src="https://velog.velcdn.com/images/mintsong/post/a8d55537-08c4-4bfc-bff0-2f311faf9837/image.png"  alt="diary_scroll" width="300">|<img src= "https://velog.velcdn.com/images/mintsong/post/146cd3b7-4ed4-4a61-ab42-d71f2b918e15/image.png" alt="diary_detail" width="300">|

| 최신 이미지 셀 클릭시 디테일 뷰 | 북마크 셀 클릭시 디테일 뷰 |
|:--------:|:--------:|
|<img src="https://velog.velcdn.com/images/mintsong/post/6df79dd2-f683-4da1-9f98-516ad389ee12/image.gif" alt="diary_delete" width="300">|<img src="https://velog.velcdn.com/images/mintsong/post/ce6f5067-f377-41bb-9485-c89f75ee8026/image.gif" alt="diary_share" width="300">|

| 북마크 없을 때 북마크 추가 | 북마크 있을 때 북마크 추가 |
|:--------:|:--------:|
|<img src="https://velog.velcdn.com/images/mintsong/post/8fed744e-15d5-4139-99f3-24958e27e9b8/image.gif" alt="diary_delete" width="300">|<img src= "https://velog.velcdn.com/images/mintsong/post/377c8b07-b2b7-4daa-b85d-bee056bf80ed/image.gif" alt="diary_share" width="300">|

| 북마크 있을 때 북마크 제거 | 북마크 전체 제거 |
|:--------:|:--------:|
|<img src="https://velog.velcdn.com/images/mintsong/post/8feee263-24a0-4bfe-b6f8-3cce2b9b166f/image.gif" alt="diary_delete" width="300">|<img src= "https://velog.velcdn.com/images/mintsong/post/3ded2768-c029-4ac0-98f3-419302d247c6/image.gif" alt="diary_share" width="300">|

| 랜덤 포토 다음 사진 전환 버튼 | 랜덤 포토 이전 사진 전환 버튼 |
|:--------:|:--------:|
|<img src="https://velog.velcdn.com/images/mintsong/post/cbf43817-6ff1-4055-8adf-9aaf7bcbafcd/image.gif" alt="diary_delete" width="300">|<img src="https://velog.velcdn.com/images/mintsong/post/bd22a3ff-9cff-4225-8e73-b1e7fa494b99/image.gif" alt="diary_share" width="300">|

| 랜덤 포토 디테일 버튼 | 디테일 뷰의 다운로드 버튼 |
|:--------:|:--------:|
|<img src="https://velog.velcdn.com/images/mintsong/post/d303223a-6775-4c91-b49f-17fe5f846008/image.gif" alt="diary_delete" width="300">|<img src= "https://velog.velcdn.com/images/mintsong/post/d00d148e-26ca-4099-b81f-efc8efd3c6a5/image.gif" alt="diary_share" width="300">|

| 랜덤 포토 디테일 버튼으로 북마크 추가 | 랜덤 포토 디테일 버튼으로 북마크 제거 |
|:--------:|:--------:|
|<img src="https://velog.velcdn.com/images/mintsong/post/a9c7e78b-c223-4975-9d7a-7475c9895f8b/image.gif" alt="diary_delete" width="300">|<img src= "https://velog.velcdn.com/images/mintsong/post/5d161c86-37fc-4616-9e05-c046851daa5e/image.gif" alt="diary_share" width="300">|

| 디테일 뷰 넓이가 긴 사진 | 디테일 뷰 높이가 긴 사진 |
|:--------:|:--------:|
|<img src= "https://velog.velcdn.com/images/mintsong/post/c70b5f39-9016-4127-bacb-c6516bc1a507/image.png" alt="diary_keyboard" width="300">|<img src= "https://velog.velcdn.com/images/mintsong/post/aa15c209-11e7-43cb-9901-1a68f6e42670/image.png" alt="diary_push_add_diary_view" width="300">|

| 앱 종료 후 다시 시작해도 코어데이터에 남아있는 북마크 |
|:--------:|
|<img src= "https://velog.velcdn.com/images/mintsong/post/73a00b91-af7e-4484-9816-e86c7986dda4/image.gif" alt="diary_keyboard" width="300">|

</br>

<a id="트러블-슈팅"></a>

## 🧨 트러블 슈팅
###### 핵심 트러블 슈팅위주로 작성하였습니다.
1️⃣ **Custom Pinterest Layout With FlowLayout** <br>
-
🔒 **문제점** <br>
처음에는 Compositional layout으로 pinterest view를 구현하고 싶었다. 북마크 섹션과 최신 이미지 섹션을 유동적으로 구현하기 위해서는 Compositional의 섹션 차이를 두는 것이 좋을 것 같았다. 그러나 하나의 아이템 사이즈로 모든 그룹 내의 아이템들의 위치를 잡는 바람에, 결국 구현에 성공할 수 없었다. 


🔑 **해결방법** <br>
때문에 하는 수 없이 다른 방법을 생각해 보아야 했다. 가장 고민해 본 것은 FlowLayout과 Compositional layout의 특징이었다. flow는 말 그대로 흐르듯이 cell의 순서가 정해진다. 또한 각 cell의 아이템 사이즈들을 다르게 줄 수 있다고 공식 문서에 명시되어 있다.
>Cells can be the same sizes or different sizes.

때문에 flowLayout을 선택하였는데 각각의 사이즈를 다르게 주는 것 뿐만이 아니라 간격이 일정하기 위해서는 좌표들을 계산해 주어야 했다. 때문에 결국 custom class layout을 만들어서 해결하였다. (계산과 관련한 것은 [다른 라이브러리들](https://github.com/ecerney/CollectionViewWaterfallLayout)을 참고하였다.)

```swift
final class PinterestFlowLayout: UICollectionViewFlowLayout {
    private var numberOfColumns = 2
    private var cellPadding: CGFloat = 4
    
    private var headerCache = [UICollectionViewLayoutAttributes]()
    private var cache = [UICollectionViewLayoutAttributes]()
    private var sectionItemAttributes = [[UICollectionViewLayoutAttributes]]()
    private var allItemAttributes = [UICollectionViewLayoutAttributes]()
    
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
        guard let collectionView else {
            return
        }
        
        var top: CGFloat = 0
        
        let headerHeight: CGFloat = 50
        let headerInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        
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
}
```

<br>


2️⃣ **Custom FlowLayout Header 추가** <br>
-
🔒 **문제점** <br>
커스텀 레이아웃을 사용했더니 헤더를 추가하는 것에 있어서 어려움이 있었다. 헤더를 추가하고, headerReferenceSize를 레이아웃에 등록하면, 보여주는 것은 dataSource의 영역이라고 생각했다. 
- 컬렉션뷰를 등록할 때 헤더도 등록해주고,
```swift
collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
```
- dataSource를 세팅할 때도, supplementaryViewProvider를 통해 등록해주었다. 
```swift
dataSource?.supplementaryViewProvider = { view, kind, indexPath in
	guard let header = view.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as? HeaderView else {
		return .init()
    }
    header.configureLabel(text: "최신 이미지")
    return header
}
```
- 또한 레이아웃을 넣어주는 부분에서 headerReferenceSize를 추가해주었다.
```swift
let layout = PinterestFlowLayout()
layout.headerReferenceSize = .init(width: 300, height: 100)
layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
layout.minimumInteritemSpacing = 10
        
collectionView.setCollectionViewLayout(layout, animated: true)
```
그런데 header가 뜨지 않았다. 고민하다가 `UICollectionViewLayoutAttributes`에 `init(forSupplementaryViewOfKind:with:)`이라는 initializer가 존재하는 것을 알게되었다. 

🔑 **해결방법** <br>
custom layout을 구현하여 사용하고 있기에, header가 등록되도 이에 따른 layout attributes 객체가 존재하지 않아 위치를 잡지 못하고 보이지 않는 것이었다. 때문에 이를 사용하여 header의 layout attributes를 저장하고 반환하여 사용할 수 있게 변경하였다. 

```swift
 var top: CGFloat = 0
        
 let headerHeight: CGFloat = 50
 let headerInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        
top += headerInset.top
        
let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: NSIndexPath(item: 0, section: 0) as IndexPath)
attributes.frame = CGRect(x: headerInset.left, y: top, width: collectionView.frame.size.width - (headerInset.left + headerInset.right), height: CGFloat(headerHeight))
        
headerCache.append(attributes)
allItemAttributes.append(attributes)
        
top = attributes.frame.maxY + headerInset.bottom
```

<br>

3️⃣ **PhotoService Singleton으로 구현** <br>
-
🔒 **문제점** <br>
Coredata와 관련한 로직을 어떻게 처리할지 고민하였다. 3개의 뷰컨에서 CoreData를 사용해야 했는데 각각의 뷰컨에서 매번 관련 로직을 구현하는 것이나, container를 선언하여 지니고 있는 것이 불필요하게 느껴졌다. 

🔑 **해결방법** <br>
싱글톤 패턴을 사용하여 해결하였다. 이는 안티 패턴으로도 불릴 만큼 주의해야하는 패턴이지만, 다수의 뷰컨에서 하나의 container를 필요로 한다는 점, 코어데이터 container의 특성 및 이 앱의 특성 상 1개 이상의 container가 필요치 않다는 점등으로 인해 이를 통해 구현하였다.

<br>

4️⃣ **유동적으로 나타나고 사라지는 BookmarkView와 BookmarkCell** <br>
-
🔒 **문제점** <br>
bookmark와 관련해서는 고려해야할 사항들이 많았다. modal로 띄운 detailViewController에서 북마크 버튼을 누르면 BookmarkViewController에서 해당 디테일 뷰의 모델을 추가하거나, 삭제하여 collectionView에서 cell이 나타나거나, 사라지거나하는 변화가 있어야 했다. 또한 BookmarkViewController의 그러한 모델의 변화에 따라 모델이 하나도 없으면 MainViewController에서 BookmarkViewController를 내려야 했고, 없다가 생기면 추가해야 했다. 단순히 viewWillAppear만 사용했을 때에는, modal present를 사용하였기에 변하지 않았다. 


🔑 **해결방법** <br>
Detail Delegate, Bookmark Delegate를 사용하여 해결하였다. DetailViewController에서 버튼이 눌리면, 해당 delegate를 채택하고 있는 BookmarkViewController에서 데이터를 추가하거나, 삭제한다. 이때 BookmarkViewController는 Bookmark Delegate를 통해 Bookmark Delegate를 채택하고 있는 MainViewController에 UI의 변화를 요청한다.

```swift
protocol DetailDelegate {
    func updateSnapshot()
}

//DetailViewController
@objc private func tappedBookmarkButton() {
	if element.likedByUser == false {
		bookmarkButton.layer.opacity = 0.7
        element.likedByUser = true
        PhotoService.shared.saveData(element)
    } else {
        bookmarkButton.layer.opacity = 0.1
        element.likedByUser = false
        PhotoService.shared.deleteData(element)
    }
    delegate?.updateSnapshot()
}

//BookmarkViewController
extension BookmarkViewController: DetailDelegate {
    func updateSnapshot() {
        bookmarks = PhotoService.shared.fetchData()
        delegate?.updateConfiguration()
    }
}

```

```swift
protocol BookmarkProtocol {
    func updateConfiguration()
}

//BookmarkViewController
extension BookmarkViewController: DetailDelegate {
    func updateSnapshot() {
        bookmarks = PhotoService.shared.fetchData()
        delegate?.updateConfiguration()
    }
}

//MainViewController
extension MainViewController: BookmarkProtocol {
    func updateConfiguration() {
        bookmarkController?.bookmarks = PhotoService.shared.fetchData()
        
        view.removeConstraints(constraints)
        updateBookMarkViewController()
        configureCollectionViewUI()
    }
}
```


<br>

<a id="참고-링크"></a>

## 📚 참고 링크
- [🍎Apple Docs: UICollectionViewLayoutAttributes](https://developer.apple.com/documentation/uikit/uicollectionviewlayoutattributes)
- [🍎Apple Docs: init(forSupplementaryViewOfKind:with:)](https://developer.apple.com/documentation/uikit/uicollectionviewlayoutattributes/1617801-init)
- [🍎Apple Docs: UICollectionViewFlowLayout](https://developer.apple.com/documentation/uikit/uicollectionviewflowlayout)
- [🍎Apple Docs: UICollectionViewCompositionalLayout](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout)
- [🍎Apple Docs: UICollectionViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource)


</br>

<a id="회고"></a>

## 👥 회고

### 😈MINT
길다고 생각했던 일주일은 몹시나 짧았다. 처음 사용해보는 collectionView, flowLayout, compositionalLayout, DiffableDataSource등에 치여 구조적인 고민과 깔끔한 코드, 로직을 생각할 시간이 부족했다. 불필요한 부분들, 중복적인 요소들을 배제하고 싶었지만 그러한 점까지 함께 가져가기에는 여전히 스스로가 많이 노력해야 한다고 느꼈다.

최우선으로 했던 것은 구현이었다. 사용자가 느끼기에, 동작하지 않는 부분이 없도록 하는 것이 목표였고, 그 외에 제스쳐 등은 뒤로 미뤘다. 그러나 pinterest에 시간을 많이 빼앗겨 무한 스크롤을 구현하지 못한 점이 쓰리다. 이래저래 아쉬운 것들이 많고 욕심이 나는 과제였지만, 붙잡고 있음에 행복했던 시간이었다. 다만 다음에 이러한 과제를 받는다면, 처음에 가볍게라도 구조를 정리해놓고 스텝을 나누는 것이 더 효율적일 것 같다. 

[Github Profile](https://github.com/mint3382)
[Trouble_Shooting Log](https://mintraum.tistory.com/)

</br>
