//
//  NewMallViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 22.02.23.
//

import UIKit
import MapKit
import SafariServices

class NewMallViewController: UIViewController {

    var heightCnstrCollectionView: NSLayoutConstraint!
    var testProperty:Int!
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let mapView: CustomMapView = {
       let map = CustomMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.layer.cornerRadius = 10
        return map
    }()
    
    let mapTapGestureRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        return tapRecognizer
    }()
    
 
    let floorPlan: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 15)
        container.foregroundColor = UIColor.white
        
        configuration.attributedTitle = AttributedString("Flor plan", attributes: container)
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .black.withAlphaComponent(0.9)

        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        
        grayButton.addTarget(self, action: #selector(floorPlanButtonPressed(_:)), for: .touchUpInside)
        
        return grayButton
    }()
    
    let websiteMall: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 15)
        container.foregroundColor = UIColor.white
        
        configuration.attributedTitle = AttributedString("Website mall", attributes: container)
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .black.withAlphaComponent(0.9)

        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        
        grayButton.addTarget(self, action: #selector(websiteMallButtonPressed(_:)), for: .touchUpInside)
        
        return grayButton
    }()
    
    let titleButtonsStack: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mall navigator"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let titleMapView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location mall"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let stackViewForButton: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5
        return stack
    }()
    
//    private var section: [MallSection]!
    private var collectionViewLayout:UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SectionHVC, ItemCell>!
    weak var delegate: PagingSectionDelegate?
    var refPath: String = ""
    var floorPlanMall: String = ""
    var webSite: String = ""
    var brandsMall: [PreviewCategory] = []
    var arrayPin:[PlacesTest] = []
    var currentPin:[PlacesTest] = []
    
    var section: [SectionHVC] = [] {
        didSet {
//            setupCollectionView()
//            addButtonsForStackViewButton()
//            
//            setupSubviews()
//            setupConstraints()
//            createDataSource()
//            collectionViewLayout.delegate = self
            
            reloadData()
        }
    }
    let managerFB = FBManager.shared
    private var isMapSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managerFB.getMallModel(refPath: refPath) { mallModel in
            
                self.configureViews(mallModel: mallModel)
        }
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupCollectionView()
        addButtonsForStackViewButton()

        setupSubviews()
        setupConstraints()
        createDataSource()
        collectionViewLayout.delegate = self
        
        currentPin = arrayPin.filter({$0.title == refPath})
        mapView.arrayPin = currentPin
        mapView.delegateMap = self
        mapTapGestureRecognizer.addTarget(self, action: #selector(didTapRecognizer(_:)))
        mapView.addGestureRecognizer(mapTapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Int(collectionViewLayout.collectionViewLayout.collectionViewContentSize.height) == 0 {
            heightCnstrCollectionView.constant = collectionViewLayout.frame.height
        } else {
            heightCnstrCollectionView.constant = collectionViewLayout.collectionViewLayout.collectionViewContentSize.height
        }
    }
    
    // kjk
    @objc func didTapRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        
        var countFalse = 0
        
        for annotation in mapView.annotations {
            
            if let annotationView = mapView.view(for: annotation), let annotationMarker = annotationView as? MKMarkerAnnotationView {
                
                let point = gestureRecognizer.location(in: mapView)
                let convertPoint = mapView.convert(point, to: annotationMarker)
                if annotationMarker.point(inside: convertPoint, with: nil) {
                } else {
                    countFalse+=1
                }
            }
        }
        if countFalse == mapView.annotations.count, isMapSelected == false {
            print("Переходим на VC")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let fullScreenMap = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            fullScreenMap.arrayPin = currentPin
            self.navigationController?.pushViewController(fullScreenMap, animated: true)
//            fullScreenMap.modalPresentationStyle = .fullScreen
//            present(fullScreenMap, animated: true, completion: nil)
        }
    }
    
    private func configureViews(mallModel:MallModel)  {
        
        var brandSection = SectionHVC(section: "Brands", items: [])
        brandsMall.forEach { (previewBrands) in
            if mallModel.brands.contains(previewBrands.brand ?? "") {
                let item = ItemCell(malls: nil, brands: previewBrands, popularProduct: nil, mallImage: nil)
                brandSection.items.append(item)
            }
        }
        
        var mallSection = SectionHVC(section: "Mall", items: [])
        mallModel.refImage.forEach { ref in
            let item = ItemCell(malls: nil, brands: nil, popularProduct: nil, mallImage: ref)
            mallSection.items.append(item)
        }
        
        self.title = mallModel.name

        if let plan = mallModel.floorPlan {
            floorPlanMall = plan
        } else {
            floorPlan.isHidden = true
        }

        if let web = mallModel.webSite {
            webSite = web
        } else {
            websiteMall.isHidden = true
        }
        
        if brandSection.items.count == mallModel.brands.count && mallSection.items.count == mallModel.refImage.count {
            section = [mallSection, brandSection]
            print("if brandSection.items.count == mallModel.brands.count && mallSection.items.count == mallModel.refImage.count")
        }
    }
    
    private func setupScrollView() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    private func setupSubviews() {
        containerView.addSubview(collectionViewLayout)
        containerView.addSubview(titleButtonsStack)
        containerView.addSubview(stackViewForButton)
        containerView.addSubview(titleMapView)
        containerView.addSubview(mapView)
    }
    
    private func setupConstraints() {
        collectionViewLayout.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        collectionViewLayout.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        collectionViewLayout.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        collectionViewLayout.bottomAnchor.constraint(equalTo: titleButtonsStack.topAnchor, constant: -20).isActive = true
        titleButtonsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        titleButtonsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        titleButtonsStack.bottomAnchor.constraint(equalTo: stackViewForButton.topAnchor, constant: -20).isActive = true
        stackViewForButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        stackViewForButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        stackViewForButton.bottomAnchor.constraint(equalTo: titleMapView.topAnchor, constant: -20).isActive = true
        titleMapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        titleMapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        titleMapView.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -20).isActive = true
        mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 1).isActive = true
        mapView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
    }
    
    private func setupCollectionView() {
        collectionViewLayout = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionViewLayout.translatesAutoresizingMaskIntoConstraints = false
        collectionViewLayout.backgroundColor = .clear
        collectionViewLayout.register(MallCell.self, forCellWithReuseIdentifier: MallCell.reuseID)
        collectionViewLayout.register(BrandCellMallVC.self, forCellWithReuseIdentifier: BrandCellMallVC.reuseID)
        collectionViewLayout.register(PagingSectionFooterView.self, forSupplementaryViewOfKind: "FooterMall", withReuseIdentifier: PagingSectionFooterView.footerIdentifier)
        collectionViewLayout.register(HeaderBrandsMallView.self, forSupplementaryViewOfKind: "HeaderBrands", withReuseIdentifier: HeaderBrandsMallView.headerIdentifier)
        heightCnstrCollectionView = collectionViewLayout.heightAnchor.constraint(equalToConstant: 300)
        heightCnstrCollectionView.isActive = true
    }
    
    
    
    private func addButtonsForStackViewButton() {
        
        let arrayButton = [floorPlan, websiteMall]
        arrayButton.forEach { view in
            stackViewForButton.addArrangedSubview(view)
        }
    }
    
    @objc func floorPlanButtonPressed(_ sender: UIButton) {
        self.showWebView(floorPlanMall)
    }
    
    @objc func websiteMallButtonPressed(_ sender: UIButton) {
//        let productVC = NewProductViewController()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let productVC = storyboard.instantiateViewController(withIdentifier: "NewProductViewController") as! NewProductViewController
//        productVC.modalPresentationStyle = .fullScreen
//        present(productVC, animated: true, completion: nil)
        self.showWebView(webSite)
    }
    
    private func createDataSource() {

        dataSource = UICollectionViewDiffableDataSource<SectionHVC, ItemCell>(collectionView: collectionViewLayout, cellProvider: { collectionView, indexPath, cellData in
            switch self.section[indexPath.section].section {
            case "Mall":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MallCell.reuseID, for: indexPath) as? MallCell
                cell?.configureCell(model: cellData, currentFrame: cell?.frame.size ?? CGSize())
                return cell
            case "Brands":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCellMallVC.reuseID, for: indexPath) as? BrandCellMallVC
                cell?.configureCell(model: cellData)
                return cell
            default:
                print("default createDataSource")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCellMallVC.reuseID, for: indexPath) as? BrandCellMallVC
                cell?.configureCell(model: cellData)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, IndexPath in
            
            if kind == "FooterMall" {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: PagingSectionFooterView.footerIdentifier, withReuseIdentifier: PagingSectionFooterView.footerIdentifier, for: IndexPath) as? PagingSectionFooterView
                let itemCount = self.dataSource.snapshot().numberOfItems(inSection: self.section[IndexPath.section])
                footerView?.configure(with: itemCount)
                self.delegate = footerView
                return footerView
            } else if kind == "HeaderBrands" {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderBrandsMallView.headerIdentifier, withReuseIdentifier: HeaderBrandsMallView.headerIdentifier, for: IndexPath) as? HeaderBrandsMallView
                headerView?.configureCell(title: "Brands for mall")
                return headerView
            } else {
                return nil
            }
        }
    }
    
    private func reloadData() {

        var snapshot = NSDiffableDataSourceSnapshot<SectionHVC, ItemCell>()
        snapshot.appendSections(section)

        for item in section {
            snapshot.appendItems(item.items, toSection: item)
        }
        dataSource?.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self.section[sectionIndex]
            
            switch section.section {
            case "Mall":
                return self.mallBannerSections()
            case "Brands":
                return self.brandsSection()
            default:
                print("default createLayout")
                return self.mallBannerSections()
            }
        }
//        layout.register(BackgroundViewCollectionReusableView.self, forDecorationViewOfKind: "background")
    return layout
    }
    
    private func mallBannerSections() -> NSCollectionLayoutSection {
//        .fractionalHeight(0.25)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
//        absolute(225)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
//        groupPagingCentered
//        section.orthogonalScrollingBehavior = .paging
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let sizeFooter = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeFooter, elementKind: "FooterMall", alignment: .bottom)
        section.boundarySupplementaryItems = [footer]
        
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) -> Void in
            guard let self = self else {return}
            let currentPage = visibleItems.last?.indexPath.row ?? 0
            print("currentPage - \(currentPage)")
            self.delegate?.currentPage(index: currentPage)
        }
        
        return section
    }
    
    private func brandsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20) )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(10), trailing: nil, bottom: nil)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
//        let background = NSCollectionLayoutDecorationItem.background(elementKind: "background")
//        background.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
//        section.decorationItems = [background]
        
        let sizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeHeader, elementKind: "HeaderBrands", alignment: .top)
        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]
        return section
    }
}


// MARK: - UICollectionViewDelegate -

extension NewMallViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            print("DidTap Mall Section")
        case 1:
            let brandVC = UIStoryboard.vcById("BrandsViewController") as! BrandsViewController
            let refPath = section[indexPath.section].items[indexPath.row].brands?.brand
            brandVC.pathRefBrandVC = refPath
            brandVC.arrayPin = arrayPin
            self.navigationController?.pushViewController(brandVC, animated: true)
            print("DidTap Brand Section")
        default:
            print("DidTap Default Section")
        }
    }
}

// MARK: - SafariViewController -
extension UIViewController {
    func showWebView(_ urlString: String) {
       
        guard let url = URL(string: urlString) else { return }
        
        let vc = SFSafariViewController(url: url)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}


// MARK: - MapViewManagerDelegate -

extension NewMallViewController: MapViewManagerDelegate {
    
    func selectAnnotationView(isSelect: Bool) {
        isMapSelected = isSelect
    }
}


    
