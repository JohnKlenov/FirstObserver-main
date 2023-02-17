//
//  NewHomeViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 4.02.23.
//

import UIKit
import Firebase
import MapKit

// не реализовано: func startPresentation(Start Onboarding) - PageViewController + topView(если Onboarding не был показан мы добавляем черное view во viewWillAppear что бы сделать переход между lounchScreenStoryboard и Onboarding)

class NewHomeViewController: UIViewController {

//    private var section: [MSectionImage]!
    // MARK: FB property
    let managerFB = FBManager.shared
    private var currentUser: User?
    
    private var segmentedControl: UISegmentedControl = {
        let item = ["Woman","Man"]
        let segmentControl = UISegmentedControl(items: item)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(didTapSegmentedControl(_:)), for: .valueChanged)
        return segmentControl
    }()
    
    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.color = .black
        loader.isHidden = true
        loader.hidesWhenStopped = true
        loader.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return loader
    }()
    
    private var activityContainerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        view.layer.cornerRadius = 8
        return view
    }()
    
    var modelHomeViewController = [SectionHVC]() {
        didSet {
            if modelHomeViewController.count == 3 {
                reloadData()
                loader.stopAnimating()
                activityContainerView.removeFromSuperview()
                tabBarController?.view.isUserInteractionEnabled = true
            }
        }
    }
    var placesMap:[PlacesTest] = []
    var placesFB:[PlacesFB] = [] {
        didSet {
            getPlacesMap()
        }
    }
    var cardProducts:[PopularProduct] = []
    private var collectionViewLayout:UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SectionHVC, ItemCell>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        managerFB.userListener { currentUser in
            self.currentUser = currentUser
            if currentUser == nil {
                self.cardProducts = []
                self.managerFB.signInAnonymously()
            }
            self.managerFB.getCardProduct { cardProduct in
                self.cardProducts = cardProduct
            }
        }
        
        title = "HomeVC"
        view.backgroundColor = .white
        tabBarController?.view.isUserInteractionEnabled = false
        configureActivityIndicatorView()
        view.addSubview(segmentedControl)
        setupCollectionView()
        setupConstraints()
        createDataSource()
        collectionViewLayout.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        managerFB.getPreviewMallsNew { malls in
            let section = SectionHVC(section: "Malls", items: malls)
            self.modelHomeViewController.append(section)
        }
        
        managerFB.getPreviewBrandsNew { brands in
            let section = SectionHVC(section: "Brands", items: brands)
            self.modelHomeViewController.append(section)
        }
        
        managerFB.getPopularProductNew { products in
            let section = SectionHVC(section: "PopularProducts", items: products)
            self.modelHomeViewController.append(section)
        }
        
        managerFB.getPlaces { modelPlaces in
            self.placesFB = modelPlaces
        }
        
    }
    
    @objc func didTapSegmentedControl(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("Tap segment Woman")
        case 1:
            print("Tap segment Man")
        default:
            print("break")
            break
        }
    }
    
    private func configureActivityIndicatorView() {
        activityContainerView.addSubview(loader)
        loader.center = activityContainerView.center
        view.addSubview(activityContainerView)
        loader.isHidden = false
        activityContainerView.center = view.center
        loader.startAnimating()
    }
    
    func getPlacesMap() {

        let tcNew = placesFB.map { $0.name }
        let tcOld = placesMap.map { $0.title ?? " " }
        let oldPins = Set(tcOld)
        let newPins = Set(tcNew)
    
        if oldPins != newPins {
            
            placesFB.forEach { place in
                managerFB.getImagefromStorage(refImage: place.refImage) { image in
                    let pin = PlacesTest(title: place.name, locationName: place.address, discipline: "Торговый центр", coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude), image: image)
                    self.placesMap.append(pin)
                }

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
        NSLayoutConstraint.activate([segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor), segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor), collectionViewLayout.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor), collectionViewLayout.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), collectionViewLayout.trailingAnchor.constraint(equalTo: view.trailingAnchor), collectionViewLayout.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
    }
    
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
                cell?.configureCell(title: "Products")
                return cell
            } else if kind == "HeaderCategory" {
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderCategoryView.headerIdentifier, withReuseIdentifier: HeaderCategoryView.headerIdentifier, for: IndexPath) as? HeaderCategoryView
                cell?.configureCell(title: "Brands")
                return cell
            } else if kind == "HeaderMalls" {
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderMallsView.headerIdentifier, withReuseIdentifier: HeaderMallsView.headerIdentifier, for: IndexPath) as? HeaderMallsView
                cell?.configureCell(title: "Malls")
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(1/2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
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
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
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
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            let mallVC = UIStoryboard.vcById("MallViewController") as! MallViewController
            let mallSection = modelHomeViewController.filter({$0.section == "Malls"})
            let brandsSection = modelHomeViewController.filter({$0.section == "Brands"})
            mallVC.arrayPin = placesMap
            mallVC.refPath = mallSection.first?.items[indexPath.row].malls?.brand ?? ""
            if let arrayBrands = brandsSection.first?.items.map({$0.brands!}) {
                mallVC.brandsMall = arrayBrands
            }
//                        }
            self.navigationController?.pushViewController(mallVC, animated: true)
//            present(mallVC, animated: true, completion: nil)
            print("Malls section")
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let brandVC = storyboard.instantiateViewController(withIdentifier: "BrandsViewController") as! BrandsViewController
            let brandsSection = modelHomeViewController.filter({$0.section == "Brands"})
            let refBrand = brandsSection.first?.items[indexPath.row].brands?.brand ?? ""
//            let ref = Database.database().reference(withPath: "brands/\(refBrand)")
//            brandVC.incomingRef = ref
            brandVC.pathRefBrandVC = refBrand
            brandVC.arrayPin = placesMap
            self.navigationController?.pushViewController(brandVC, animated: true)
//            present(brandVC, animated: true, completion: nil)
            print("Brands section")
        case 2:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let productVC = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            let productSection = modelHomeViewController.filter({$0.section == "PopularProducts"})
            let malls = productSection.first?.items[indexPath.row].popularProduct?.malls ?? [""]
            var placesArray:[PlacesTest] = []
            placesMap.forEach { (places) in
                if malls.contains(places.title ?? "") {
                    placesArray.append(places)
                }
            }
            cardProducts.forEach { (addedProduct) in
                if addedProduct.model == productSection.first?.items[indexPath.row].popularProduct?.model {
                    productVC.isAddedToCard = true
                }
            }
            productVC.fireBaseModel = productSection.first?.items[indexPath.row].popularProduct
            productVC.arrayPin = placesArray
            self.navigationController?.pushViewController(productVC, animated: true)
//            present(productVC, animated: true, completion: nil)
            print("Products section")
        default:
            print("default \(indexPath.section)")
        }
    }
}
