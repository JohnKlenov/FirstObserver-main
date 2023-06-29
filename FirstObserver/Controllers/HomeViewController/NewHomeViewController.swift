//
//  NewHomeViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 4.02.23.
//

import UIKit
import Firebase
import MapKit
import SwiftUI

class NewHomeViewController: ParentNetworkViewController {

    private let managerFB = FBManager.shared
    let defaults = UserDefaults.standard
    
//    private var isNotVisableViewController = false
    private var isFirstStart = true
    private var currentGender = ""
    private var isConnectedFB:Bool = false
    
    var modelHomeViewController = [SectionHVC]() {
        didSet {
            if modelHomeViewController.count == 3 {
                activityView.stopAnimating()
                activityView.removeFromSuperview()
                tabBarController?.view.isUserInteractionEnabled = true
                reloadData()
            }
        }
    }
    
    var modelHomeViewControllerDict = [String:SectionHVC]() {
        didSet {
            if modelHomeViewControllerDict.count == 3 {
                let sorted = modelHomeViewControllerDict.sorted { $0.key < $1.key }
                let valuesArraySorted = Array(sorted.map({ $0.value }))
                modelHomeViewController = valuesArraySorted
            }
        }
    }
   

    var placesMap:[Places] = []
    private var placesFB:[PlacesFB] = [] {
        didSet {
            getPlacesMap()
        }
    }
    private(set) var cartProducts:[PopularProduct] = []
    private var collectionViewLayout:UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SectionHVC, ItemCell>?

    
    // MARK: - lifeCycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Observer"
        navigationController?.navigationBar.prefersLargeTitles = true
       
        
        managerFB.isNetworkConnectivity { isConnect in
            isConnect ? print("FB Connected") : print("FB Not connected")
        }

        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        // refactor getCartObservser
        //        managerFB.userListener { currentUser in
        //            if currentUser == nil {
        //                self.cartProducts = []
        //                self.managerFB.signInAnonymously()
        //            }
        //
        //            if self.isFirstStart {
        //                self.isFirstStart = false
        //                // альтернатива getCartProduct во всех классах
        //                // у нас только сдесь getCartProduct и мы от сюда гет дата
        //                // managerFB.removeObserverForCartProductsUser()
        //                self.managerFB.getCartProduct { cartProducts in
        //                    self.cartProducts = cartProducts
        //                }
        //            }
        //        }
        
        managerFB.userListener { currentUser in
            print("NewHomeViewController  managerFB.userListener")
            if currentUser == nil {
                print("NewHomeViewController  if currentUser == nil {")
                self.cartProducts = []
                self.managerFB.signInAnonymously()
            }
            self.managerFB.removeObserverForCartProductsUser()
            self.managerFB.getCartProduct { cartProducts in
                print("NewHomeViewController  getCartProduct")
                self.cartProducts = cartProducts
            }
        }
        
        // релоад дата после получения modelPlaces
        managerFB.getPlaces { modelPlaces in
            self.placesFB = modelPlaces
        }
        
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        currentGender = gender
        getDataFB(path: gender)
        
//        self.setLeftAlignedNavigationItemTitle(text: "Observer", color: R.Colors.label, margin: 20)
        view.backgroundColor = R.Colors.systemBackground
        tabBarController?.view.isUserInteractionEnabled = false
        configureActivityView()
        setupCollectionView()
        setupConstraints()
        createDataSource()
        collectionViewLayout.delegate = self
    }

    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // refactor getCartObservser
        //        managerFB.removeObserverForCartProductsUser()
        //        if !isFirstStart {
        //            managerFB.getCartProduct { cartProducts in
        //                self.cartProducts = cartProducts
        //            }
        //        }
        switchGender()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        startOnbordingPresentation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    

    
    // MARK: - another methods
    
    private func getDataFB(path: String) {
        
        managerFB.getPreviewMallsGenderHVC(path: path) { malls in
            let section = SectionHVC(section: "Malls", items: malls)
            self.modelHomeViewControllerDict["A"] = section
        }
        
        managerFB.getPreviewBrandsGenderHVC(path: path) { brands in
            let section = SectionHVC(section: "Brands", items: brands)
            self.modelHomeViewControllerDict["B"] = section
        }
        
        managerFB.getPopularProductGender(path: path) { products in
            let section = SectionHVC(section: "PopularProducts", items: products)
            self.modelHomeViewControllerDict["C"] = section
        }
    }
    
    func switchGender() {
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        if currentGender != gender {
            configureActivityView()
            managerFB.removeObserverPreviewMallsGenderHVC(path: currentGender)
            managerFB.removeObserverPopularProductGender(path: currentGender)
            managerFB.removeObserverPreviewBrandsGenderHVC(path: currentGender)
            modelHomeViewControllerDict = [:]
            currentGender = gender
            getDataFB(path: currentGender)
        }
    }
    
    func getPlacesMap() {

        let tcNew = placesFB.map { $0.name }
        let tcOld = placesMap.map { $0.title ?? " " }
        let oldPins = Set(tcOld)
        let newPins = Set(tcNew)
    
        if oldPins != newPins {
            
            placesFB.forEach { place in
                let pin = Places(title: place.name, locationName: place.address, discipline:"Торговый центр", coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude), imageName: place.refImage)
                    self.placesMap.append(pin)
            }
        }
    }
    
    private func setupCollectionView() {
        
        collectionViewLayout = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionViewLayout.translatesAutoresizingMaskIntoConstraints = false
        collectionViewLayout.backgroundColor = .clear
//        collectionViewLayout.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionViewLayout)
        collectionViewLayout.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
        collectionViewLayout.register(ProductCellNew.self, forCellWithReuseIdentifier: ProductCellNew.reuseID)
        collectionViewLayout.register(MallsViewCell.self, forCellWithReuseIdentifier: MallsViewCell.reuseID)
        collectionViewLayout.register(HeaderProductView.self, forSupplementaryViewOfKind: "HeaderProduct", withReuseIdentifier: HeaderProductView.headerIdentifier)
        collectionViewLayout.register(HeaderCategoryView.self, forSupplementaryViewOfKind: "HeaderCategory", withReuseIdentifier: HeaderCategoryView.headerIdentifier)
        collectionViewLayout.register(HeaderMallsView.self, forSupplementaryViewOfKind: "HeaderMalls", withReuseIdentifier: HeaderMallsView.headerIdentifier)
        
        
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([collectionViewLayout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0), collectionViewLayout.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), collectionViewLayout.trailingAnchor.constraint(equalTo: view.trailingAnchor), collectionViewLayout.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
    }
//    collectionViewLayout.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor)
    
    private func createDataSource() {

        dataSource = UICollectionViewDiffableDataSource<SectionHVC, ItemCell>(collectionView: collectionViewLayout, cellProvider: { collectionView, indexPath, cellData in
            switch self.modelHomeViewController[indexPath.section].section {
            case "Malls":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MallsViewCell.reuseID, for: indexPath) as? MallsViewCell
                
                cell?.configureCell(model: cellData, currentFrame: cell?.frame.size ?? CGSize())
                
                return cell
            case "Brands":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as? ImageCell
                cell?.configureCell(model: cellData)
                return cell
            case "PopularProducts":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCellNew.reuseID, for: indexPath) as? ProductCellNew
                cell?.configureCell(model: cellData)
//                cell?.setNeedsLayout()
                return cell
            default:
                print("default createDataSource")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as? ImageCell
                cell?.configureCell(model: cellData)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, IndexPath in
            
            if kind == "HeaderProduct" {
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderProductView.headerIdentifier, withReuseIdentifier: HeaderProductView.headerIdentifier, for: IndexPath) as? HeaderProductView
                cell?.configureCell(title: R.Strings.TabBarController.Home.ViewsHome.headerProductView)
                return cell
            } else if kind == "HeaderCategory" {
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderCategoryView.headerIdentifier, withReuseIdentifier: HeaderCategoryView.headerIdentifier, for: IndexPath) as? HeaderCategoryView
                cell?.configureCell(title: R.Strings.TabBarController.Home.ViewsHome.headerCategoryView)
                return cell
            } else if kind == "HeaderMalls" {
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderMallsView.headerIdentifier, withReuseIdentifier: HeaderMallsView.headerIdentifier, for: IndexPath) as? HeaderMallsView
                cell?.delegate = self
                cell?.configureCell(title: R.Strings.TabBarController.Home.ViewsHome.headerMallsView)
                return cell
            } else {
                return nil
            }
        }
    }
    
    private func reloadData() {

        var snapshot = NSDiffableDataSourceSnapshot<SectionHVC, ItemCell>()
        snapshot.appendSections(modelHomeViewController)

        for section in modelHomeViewController {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource?.apply(snapshot)
       
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self.modelHomeViewController[sectionIndex]
            
            switch section.section {
            case "Malls":
                return self.mallsBannerSections()
            case "Brands":
                return self.categorySections()
            case "PopularProducts":
                return self.productSection()
            default:
                print("default createLayout")
                return self.mallsBannerSections()
            }
        }
        layout.register(BackgroundViewCollectionReusableView.self, forDecorationViewOfKind: "background")
    return layout
    }
    
    private func mallsBannerSections() -> NSCollectionLayoutSection {
//        .fractionalHeight(0.25)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        absolute(225)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(0.55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
//        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.orthogonalScrollingBehavior = .continuous
//        section.visibleItemsInvalidationHandler = { (items, offset, env) -> Void in
////            self.pageControl.currentPage = items.last?.indexPath.row ?? 0
//            let page = round(offset.x / self.view.bounds.width)
////            print("visibleItemsInvalidationHandler - \(items.last?.indexPath.row ?? 0)")
//            print("visibleItemsInvalidationHandler - \(page)")
//        }
        
        let sizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeHeader, elementKind: "HeaderMalls", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func categorySections() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/5), heightDimension: .fractionalWidth(1/5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 10)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        
        
        let sizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeHeader, elementKind: "HeaderCategory", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }

    private func productSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(10), trailing: nil, bottom: nil)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
//        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: NSCollectionLayoutSpacing.fixed(10))
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15)
        
        let background = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        background.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        section.decorationItems = [background]
        
        let sizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeHeader, elementKind: "HeaderProduct", alignment: .top)
        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]
        return section
    }
}

extension NewHomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if  indexPath.section == 0 {
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            let mallVC = UIStoryboard.vcById("NewMallViewController") as! NewMallViewController
            let mallSection = modelHomeViewController.filter({$0.section == "Malls"})
            let brandsSection = modelHomeViewController.filter({$0.section == "Brands"})
            let refPath = mallSection.first?.items[indexPath.row].malls?.brand ?? ""
            mallVC.refPath = refPath
            mallVC.title = refPath
            mallVC.arrayPin = placesMap
            if let arrayBrands = brandsSection.first?.items.map({$0.brands!}) {
                mallVC.brandsMall = arrayBrands
            }
            self.navigationController?.pushViewController(mallVC, animated: true)
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let brandVC = storyboard.instantiateViewController(withIdentifier: "BrandsViewController") as! BrandsViewController
            let brandsSection = modelHomeViewController.filter({$0.section == "Brands"})
            let refBrand = brandsSection.first?.items[indexPath.row].brands?.brand ?? ""
//            let fullPath = "Brands" + currentGender + "/" + refBrand
            brandVC.pathRefBrandVC = refBrand
            brandVC.title = refBrand
            brandVC.arrayPin = placesMap
            self.navigationController?.pushViewController(brandVC, animated: true)
        case 2:
            let productVC = NewProductViewController()
            let productSection = modelHomeViewController.filter({$0.section == "PopularProducts"})
            let malls = productSection.first?.items[indexPath.row].popularProduct?.malls ?? [""]
            var placesArray:[Places] = []
            placesMap.forEach { (places) in
                if malls.contains(places.title ?? "") {
                    placesArray.append(places)
                }
            }
            cartProducts.forEach { (addedProduct) in
                if addedProduct.model == productSection.first?.items[indexPath.row].popularProduct?.model {
                    productVC.isAddedToCard = true
                }
            }
//            productVC.fireBaseModel = productSection.first?.items[indexPath.row].popularProduct
            productVC.arrayPin = placesArray
            productVC.productModel = productSection.first?.items[indexPath.row].popularProduct
            self.navigationController?.pushViewController(productVC, animated: true)
//            present(productVC, animated: true, completion: nil)
            print("Products section")
        default:
            print("default \(indexPath.section)")
        }
    }
}

extension NewHomeViewController: HeaderMallsViewDelegate {
    func didSelectSegmentControl() {
        switchGender()
    }
    
    
}





//    var placesMap:[PlacesTest] = []

// нужно создать метод который будет сробатывать при каж
//    func getPlacesMapTest() {
//
//        let tcNew = placesFB.map { $0.name }
//        let tcOld = placesMap.map { $0.title ?? " " }
//        let oldPins = Set(tcOld)
//        let newPins = Set(tcNew)
//
//        if oldPins != newPins {
////            var unprocessedPlaces = [PlacesFB]()
//            for place in placesFB {
//                if NetworkMonitor.shared.isConnected {
//                    managerFB.getImagefromStorage(refImage: place.refImage) { image in
//                        let pin = PlacesTest(title: place.name, locationName: place.address, discipline: "Торговый центр", coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude), image: image)
//                        self.placesMap.append(pin)
//                    }
//                } else {
//                    unprocessedPlaces.append(place)
//                }
//            }
//        }
//    }

//    func getPlacesMap() {
//
//        let tcNew = placesFB.map { $0.name }
//        let tcOld = placesMap.map { $0.title ?? " " }
//        let oldPins = Set(tcOld)
//        let newPins = Set(tcNew)
//
//        if oldPins != newPins {
//
//            placesFB.forEach { place in
//                managerFB.getImagefromStorage(refImage: place.refImage) { image in
//                    let pin = PlacesTest(title: place.name, locationName: place.address, discipline: "Торговый центр", coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude), image: image)
//                    self.placesMap.append(pin)
//                }
//
//            }
//        }
//    }

//    private var activityView: ActivityContainerView = {
//        let view = ActivityContainerView()
//        view.layer.cornerRadius = 8
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
//        networkConnected()

//    @objc func showOfflineDeviceUI(notification: Notification) {
//        print("@objc func showOfflineDeviceUI(notification: Notification HomeVC")
//         networkConnected()
//     }
    
//    private func networkConnected() {
//        if NetworkMonitor.shared.isConnected {
//            print("NetworkManager Connected")
//        } else {
//            DispatchQueue.main.async {
//                self.activityView.isAnimating { [weak self] isAnimatig in
//                    if isAnimatig {
//                        self?.activityView.stopAnimating()
//                        self?.activityView.removeFromSuperview()                }
//                }
//                self.setupAlertNotConnected()
//                print("NetworkManager Not connected")
//            }
//        }
//    }

//    private func configureActivityView() {
//        view.addSubview(activityView)
//        activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        activityView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4).isActive = true
//        activityView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4).isActive = true
//        activityView.startAnimating()
//    }


//    private func setupAlertNotConnected() {
//
//        let alert = UIAlertController(title: "You're offline!", message: "No internet connection", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Try again", style: .default) { action in
//            // проверить умирает ли кложур при нажатии на трай(создадим объект с деинитом в кложуре)
//            self.networkConnected()
//
//        }
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }

//        let path = defaults.string(forKey: "gender") ?? "Woman"
//        getDataFB(path: path)
//        let path = defaults.string(forKey: "gender") ?? "Woman"
//        managerFB.removeObserverPreviewMallsGender(path: path)
//        managerFB.removeObserverPopularProductGender(path: path)
//        managerFB.removeObserverPreviewBrandsGender(path: path)
//        modelHomeViewControllerDict = [:]
//        print("modelHomeViewControllerDict - \(modelHomeViewControllerDict)")
//        showNavigationBar()
//        managerFB.removeObserverForCartProductsUser()

//        if isNotVisableViewController {
//            let sorted = modelHomeViewControllerDict.sorted { $0.key < $1.key }
//            let valuesArraySorted = Array(sorted.map({ $0.value }))
//            modelHomeViewController = valuesArraySorted
//            isNotVisableViewController = false
//        }

//    var modelHomeViewController = [SectionHVC]() {
//        didSet {
//            if modelHomeViewController.count == 3 {
////                reloadData()
//                loader.stopAnimating()
//                activityContainerView?.removeFromSuperview()
//                tabBarController?.view.isUserInteractionEnabled = true
////                segmentedControl.isHidden = false
//                reloadData()
//            }
//        }
//    }
    
//     var modelHomeViewControllerDict = [String:SectionHVC]() {
//        didSet {
//            if self.isOnScreen {
//                if modelHomeViewControllerDict.count == 3 {
//                    let sorted = modelHomeViewControllerDict.sorted { $0.key < $1.key }
//                    let valuesArraySorted = Array(sorted.map({ $0.value }))
//                    modelHomeViewController = valuesArraySorted
//                }
//            } else {
//                isNotVisableViewController = true
//            }
//        }
//    }

//    @objc func didTapSegmentedControl(_ segmentedControl: UISegmentedControl) {
//        switch segmentedControl.selectedSegmentIndex {
//        case 0:
//            print("Tap segment Woman")
//        case 1:
//            print("Tap segment Man")
//        default:
//            print("break")
//            break
//        }
//    }



//        managerFB.getPreviewMallsNew { malls in
//            let section = SectionHVC(section: "Malls", items: malls)
//            self.modelHomeViewControllerDict["A"] = section
//        }
//
//        managerFB.getPreviewBrandsNew { brands in
//            let section = SectionHVC(section: "Brands", items: brands)
//            self.modelHomeViewControllerDict["B"] = section
//        }
//
//        managerFB.getPopularProductNew { products in
//            let section = SectionHVC(section: "PopularProducts", items: products)
//            self.modelHomeViewControllerDict["C"] = section
//        }
        

    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        print("scroll Content : \(scrollView.contentOffset.y)")
//
//        if scrollView.contentOffset.y >= 100
//        {
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
////                self.navigationController?.setNavigationBarHidden(true, animated: true)
//                //                        self.navigationController?.setToolbarHidden(true, animated: true)
//            }, completion: nil)
//        }
//        else
//        {
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
////                self.navigationController?.setNavigationBarHidden(false, animated: true)
//            }, completion: nil)
//        }
//    }


// MARK: - onboardin pesentation methods

//    func startOnbordingPresentation() {
////        NewHomeViewController.userDefaults.set(false, forKey: "isFinishPresentation")
//        let appAlreadeSeen = NewHomeViewController.userDefaults.bool(forKey: "isFinishPresentation")
//        if appAlreadeSeen == false {
//            let pageViewController = PresentViewController()
//                pageViewController.modalPresentationStyle = .fullScreen
//                self.present(pageViewController, animated: true, completion: nil)
//        }
//    }
//
//    private func addTopView() {
//        let appAlreadeSeen = HomeViewController.userDefaults.bool(forKey: "isFinishPresentation")
//        if appAlreadeSeen == false {
//            configureView()
//        }
//    }
//
//    private func configureView() {
//        let fullScreenFrame = UIScreen.main.bounds
//        overlayView.frame = fullScreenFrame
//        view.addSubview(overlayView)
//    }
//
//    private func removeTopView() {
//        let appAlreadeSeen = HomeViewController.userDefaults.bool(forKey: "isFinishPresentation")
//        if appAlreadeSeen == true {
//            self.deleteView()
//        }
//    }
//
//    private func deleteView() {
//        overlayView.removeFromSuperview()
//    }
