//
//  ListViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 6.10.23.
//

//import Foundation
//import UIKit
//
//enum AlertActions:String {
//    case Recommendation
//    case PriceDown
//    case PriceUp
//    case Alphabetically
//}
//
//protocol CustomRangeViewDelegate: AnyObject {
//    func didChangedFilterProducts(filterProducts:[Product], isActiveScreenFilter:Bool?, isFixedPriceProducts:Bool?, minimumValue: Double?, maximumValue: Double?, lowerValue: Double?, upperValue: Double?, countFilterProduct:Int?, selectedItem: [IndexPath:String]?)
//}
//
//class ListViewController: UIViewController {
//    
//    var alert:UIAlertController?
//    var changedAlertAction:AlertActions = .Recommendation
//    
//    var reserverDataSource: [Product] = []
//    var dataSourceTableView: [Product] = [] {
//        willSet {
//   
//        }
//        didSet {
//            tableView.reloadData()
//        }
//    }
//    
//    var dataSourceCollectionView: [String] = []
//    
//    var dataManager = FactoryProducts.shared
//    
//    // MARK: property for fixed filter screen -
//    
//    var isActiveScreenFilter:Bool = false
//    
//    var minimumValue: Double?
//    var maximumValue: Double?
//    var lowerValue: Double?
//    var upperValue: Double?
//    
//    var countFilterProduct:Int?
//    var isFixedPriceProducts:Bool?
//    
//    var selectedItem: [IndexPath:String]?
//    
//    var heightCnstrCollectionView: NSLayoutConstraint!
//    
//    // MARK: -
//    
//    private let collectionView: UICollectionView = {
//        
//        let layout = UserProfileTagsFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//    
//    let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.backgroundColor = .clear
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        return tableView
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "List"
//        view.backgroundColor = UIColor.systemBackground
//        view.tintColor = .systemCyan
//        
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: "filterCell")
//        heightCnstrCollectionView = collectionView.heightAnchor.constraint(equalToConstant: 0)
//        heightCnstrCollectionView.isActive = true
//        collectionView.backgroundColor = .clear
//        view.addSubview(collectionView)
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        view.addSubview(tableView)
//        
//        setupConstraints()
//        configureNavigationItem()
//        dataSourceTableView = dataManager.createRandomProduct()
//        
//        sortRecommendation()
//        reserverDataSource = dataSourceTableView
//        setupAlertSorted()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        if Int(collectionView.collectionViewLayout.collectionViewContentSize.height) == 0 {
//            heightCnstrCollectionView.constant = collectionView.frame.height
//        } else {
//            heightCnstrCollectionView.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setupCollectionView()
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
//            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
//            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
//            collectionView.bottomAnchor.constraint(equalTo: tableView.topAnchor)
//        ])
//
//        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0), tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0), tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0), tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)])
//    }
//    
//    private func configureNavigationItem() {
//        
//        // Создание кнопок
//        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease"), style: .plain, target: self, action: #selector(filterButtonTapped))
//        filterButton.tintColor = UIColor.systemCyan
//        let sortedButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortedButtonTapped))
//        sortedButton.tintColor = UIColor.systemCyan
//        navigationItem.rightBarButtonItems = [sortedButton, filterButton]
//    }
//    
//    private func setupCollectionView() {
//        
//        if  let isFixedPriceProducts = isFixedPriceProducts, let lowerValue = lowerValue, let upperValue = upperValue, isFixedPriceProducts {
//            let rangePriceString = "from " + "\(Int(lowerValue))" + " to " + "\(Int(upperValue))"
//            let indexPath = IndexPath(item: 333, section: 333)
//            selectedItem?[indexPath] = rangePriceString
//        }
//        
//        if let selectedItem = selectedItem {
//            
//            let cell = selectedItem.map{$0.value}
//            print("cell - \(cell)")
//            dataSourceCollectionView = cell
//            collectionView.reloadData()
//            let layout = collectionView.collectionViewLayout as? UserProfileTagsFlowLayout
//            layout?.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
////            view.setNeedsLayout()
////            view.layoutIfNeeded()
//            heightCnstrCollectionView.constant = 1
//        } else {
//            dataSourceCollectionView = []
//            collectionView.reloadData()
//            let layout = collectionView.collectionViewLayout as? UserProfileTagsFlowLayout
//            layout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            heightCnstrCollectionView.constant = 0
//        }
//    }
//    
//    @objc func filterButtonTapped() {
//        
//        let indexPath = IndexPath(item: 333, section: 333)
//        selectedItem?[indexPath] = nil
//        
//        let customVC = CustomRangeViewController()
//        customVC.allProducts = reserverDataSource
//        customVC.delegate = self
//        if isActiveScreenFilter {
//            customVC.selectedItem = selectedItem ?? [:]
//            customVC.minimumValue = minimumValue
//            customVC.maximumValue = maximumValue
//            customVC.lowerValue = lowerValue
//            customVC.upperValue = upperValue
//            customVC.countFilterProduct = countFilterProduct
//            customVC.isActiveScreenFilter = isActiveScreenFilter
//            customVC.isFixedPriceProducts = isFixedPriceProducts ?? false
//        }
//        let navigationVC = CustomNavigationController(rootViewController: customVC)
//        navigationVC.navigationBar.backgroundColor = UIColor.secondarySystemBackground
//        navigationVC.modalPresentationStyle = .fullScreen
//        present(navigationVC, animated: true, completion: nil)
//    }
//
//    @objc func sortedButtonTapped() {
//        
//        if let alert = alert {
//            alert.actions.forEach { action in
//                if action.title == changedAlertAction.rawValue {
//                    action.setValue(UIColor.systemGray3, forKey: "titleTextColor")
//                    action.isEnabled = false
//                } else {
//                    action.isEnabled = true
//                    action.setValue(UIColor.systemCyan, forKey: "titleTextColor")
//                }
//                
//            }
//            present(alert, animated: true, completion: nil)
//        }
//    }
//}
//
//extension ListViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        dataSourceTableView.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
//        let separator = " "
//        let combinedStringWithSeparator = [String("\(dataSourceTableView[indexPath.row].price!)"), dataSourceTableView[indexPath.row].material ?? "", dataSourceTableView[indexPath.row].season ?? "", dataSourceTableView[indexPath.row].color ?? "", String("\(dataSourceTableView[indexPath.row].sortIndex ?? 0)") ].joined(separator: separator)
//
//        var contentCell = cell.defaultContentConfiguration()
//        
//        contentCell.text = dataSourceTableView[indexPath.row].brand
//        contentCell.secondaryText = combinedStringWithSeparator
//        contentCell.image = UIImage(systemName: "swift")
//        contentCell.textProperties.font = UIFont.systemFont(ofSize: 17, weight: .regular)
//        contentCell.imageProperties.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .callout)
//        contentCell.imageToTextPadding = 8
//        cell.contentConfiguration = contentCell
//        return cell
//    }
//}
//
//extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        dataSourceCollectionView.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//       
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as? FilterCell else {
//            return UICollectionViewCell()
//        }
//        cell.delegate = self
//        cell.label.text = dataSourceCollectionView[indexPath.row]
//        return cell
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var labelSize = CGSize()
//        var label :UILabel? = UILabel()
//        label?.font = UIFont.systemFont(ofSize: 17)
//        label?.textAlignment = .center
//        label?.textColor = UIColor.label
//        label?.text = dataSourceCollectionView[indexPath.item]
//        
//        labelSize = label?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
//        labelSize = CGSize(width: labelSize.width + labelSize.height + 20, height: labelSize.height + 10)
//        label = nil
//        return labelSize
//    }
//}
//
//extension ListViewController:CustomRangeViewDelegate {
//    func didChangedFilterProducts(filterProducts: [Product], isActiveScreenFilter: Bool?, isFixedPriceProducts: Bool?, minimumValue: Double?, maximumValue: Double?, lowerValue: Double?, upperValue: Double?, countFilterProduct: Int?, selectedItem: [IndexPath:String]?) {
//        
//        dataSourceTableView = filterProducts
//       
//        applyCurrentSorting()
//        
//        if reserverDataSource.count == filterProducts.count {
//            navigationItem.rightBarButtonItems?[1].tintColor = UIColor.systemCyan
//        } else {
//            navigationItem.rightBarButtonItems?[1].tintColor = UIColor.systemPink
//        }
//        
//        
//        // MARK: set property for filter or reset filter -
//        
//        self.isActiveScreenFilter = isActiveScreenFilter ?? false
//        self.minimumValue = minimumValue
//        self.maximumValue = maximumValue
//        self.lowerValue = lowerValue
//        self.upperValue = upperValue
//        self.countFilterProduct = countFilterProduct
//        self.selectedItem = selectedItem
//        self.isFixedPriceProducts = isFixedPriceProducts
//        
//       
//    }
//}
//
//extension ListViewController {
//    
//    
//    func setupAlertSorted() {
//
//        alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
//        alert?.overrideUserInterfaceStyle = .dark
//        
//        
//        let recommendation = UIAlertAction(title: "Recommendation", style: .default) { action in
//            self.navigationItem.rightBarButtonItems?[0].tintColor = action.isEnabled ? UIColor.systemCyan : UIColor.systemPink
//            self.changedAlertAction = .Recommendation
//            self.sortRecommendation()
//        }
//        
//        let priceDown = UIAlertAction(title: "PriceDown", style: .default) { action in
//            self.navigationItem.rightBarButtonItems?[0].tintColor = action.isEnabled ? UIColor.systemPink : UIColor.systemCyan
//            self.changedAlertAction = .PriceDown
//            self.sortPriceDown()
//        }
//
//        let priceUp = UIAlertAction(title: "PriceUp", style: .default) { action in
//            self.navigationItem.rightBarButtonItems?[0].tintColor = action.isEnabled ? UIColor.systemPink : UIColor.systemCyan
//            self.changedAlertAction = .PriceUp
//            self.sortPriceUp()
//        }
//        
//        let alphabetically = UIAlertAction(title: "Alphabetically", style: .default) { action in
//            self.navigationItem.rightBarButtonItems?[0].tintColor = action.isEnabled ? UIColor.systemPink : UIColor.systemCyan
//            self.changedAlertAction = .Alphabetically
//            self.sortAlphabetically()
//        }
//        
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
//            
//        }
//
//        let titleAlertController = NSAttributedString(string: "Sort by", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
//        alert?.setValue(titleAlertController, forKey: "attributedTitle")
//
//        
//        alert?.addAction(recommendation)
//        alert?.addAction(priceDown)
//        alert?.addAction(priceUp)
//        alert?.addAction(alphabetically)
//        alert?.addAction(cancel)
//    }
//    
//    
//    func sortAlphabetically() {
//        dataSourceTableView.sort { (product1, product2) -> Bool in
//            guard let brand1 = product1.brand, let brand2 = product2.brand else {
//                return false // Обработайте случаи, когда brand равно nil, если это необходимо
//            }
//            return brand1.localizedCaseInsensitiveCompare(brand2) == .orderedAscending
//        }
//    }
//
//    func sortPriceDown() {
//        dataSourceTableView.sort { (product1, product2) -> Bool in
//            guard let price1 = product1.price, let price2 = product2.price else {
//                return false // Обработайте случаи, когда price равно nil, если это необходимо
//            }
//            return price1 > price2
//        }
//    }
//
//    func sortPriceUp() {
//        dataSourceTableView.sort { (product1, product2) -> Bool in
//            guard let price1 = product1.price, let price2 = product2.price else {
//                return false // Обработайте случаи, когда price равно nil, если это необходимо
//            }
//            return price1 < price2
//        }
//    }
//
//    func sortRecommendation() {
//        dataSourceTableView.sort { (product1, product2) -> Bool in
//            guard let price1 = product1.sortIndex, let price2 = product2.sortIndex else {
//                return false // Обработайте случаи, когда price равно nil, если это необходимо
//            }
//            return price1 > price2
//        }
//    }
//    
//    func applyCurrentSorting() {
//        switch changedAlertAction {
//        case .Recommendation:
//            sortRecommendation()
//        case .PriceDown:
//            sortPriceDown()
//        case .PriceUp:
//            sortPriceUp()
//        case .Alphabetically:
//            sortAlphabetically()
//        }
//    }
//    
//    func filterProductsUniversal(products: [Product], color: [String]? = nil, brand: [String]? = nil, material: [String]? = nil, season: [String]? = nil, minPrice: Int? = nil, maxPrice: Int? = nil) -> [Product] {
//        let filteredProducts = products.filter { product in
//            var isMatched = true
//
//            if let color = color {
//                isMatched = isMatched && color.contains(product.color ?? "")
//            }
//
//            if let brand = brand {
//                isMatched = isMatched && brand.contains(product.brand ?? "")
//            }
//
//            if let material = material {
//                isMatched = isMatched && material.contains(product.material ?? "")
//            }
//
//            if let season = season {
//                isMatched = isMatched && season.contains(product.season ?? "")
//            }
//
//            if let minPrice = minPrice {
//                isMatched = isMatched && (product.price ?? -1 >= minPrice)
//            }
//
//            if let maxPrice = maxPrice {
//                isMatched = isMatched && (product.price ?? 1000 <= maxPrice)
//            }
//
//            return isMatched
//        }
//
//        return filteredProducts
//    }
//    
//    private func calculateRangePrice(products: [Product]) {
//        
//        var minPrice = Int.max
//        var maxPrice = Int.min
//        
//        var counter = 0
//        for product in products {
//            counter+=1
//
//            if let price = product.price {
//
//                if price < minPrice {
//                    minPrice = price
//                }
//                if price > maxPrice {
//                    maxPrice = price
//                }
//            }
//        }
//        
//        if counter == products.count {
//            lowerValue = Double(minPrice)
//            upperValue = Double(maxPrice)
//        }
//    }
//}
//
//extension ListViewController: FilterCellDelegate {
//    func didDeleteCellFilter(_ filterCell: FilterCell) {
//        
//        if let indexPath = collectionView.indexPath(for: filterCell) {
//            
//            dataSourceCollectionView.remove(at: indexPath.item)
//            collectionView.deleteItems(at: [indexPath])
//            
//            view.setNeedsLayout()
//            view.layoutIfNeeded()
//            
//            if let index = selectedItem?.firstIndex(where: { $0.value == filterCell.label.text}) {
//                if let key = selectedItem?.first(where: { $0.value == filterCell.label.text })?.key {
//                    if key == IndexPath(item: 333, section: 333) {
//                        isFixedPriceProducts = false
//                    }
//                } else {
//                    print("Returne message for analitic FB Crashlystics")
//                }
//                
//                selectedItem?.remove(at: index)
//            }
//            
//            if let selectedItem = selectedItem, selectedItem.isEmpty {
//                self.selectedItem = nil
//                self.isActiveScreenFilter = false
//                // на всяк про всяк очистим проперти
//                isFixedPriceProducts = nil
//                minimumValue = nil
//                maximumValue = nil
//                lowerValue = nil
//                upperValue = nil
//                countFilterProduct = nil
//                
//                let layout = collectionView.collectionViewLayout as? UserProfileTagsFlowLayout
//                layout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//                heightCnstrCollectionView.constant = 0
//                dataSourceTableView = reserverDataSource
//                applyCurrentSorting()
//                navigationItem.rightBarButtonItems?[1].tintColor = UIColor.systemCyan
//                
//            } else if let selectedItem = selectedItem {
//                
//                let filteredColor = Array((selectedItem.filter { $0.key.section == 0 }).values)
//                let color = filteredColor.isEmpty ? nil : filteredColor
//                
//                let filteredBrand = Array((selectedItem.filter { $0.key.section == 1 }).values)
//                let brand = filteredBrand.isEmpty ? nil : filteredBrand
//                
//                let filteredMaterial = Array((selectedItem.filter { $0.key.section == 2 }).values)
//                let material = filteredMaterial.isEmpty ? nil : filteredMaterial
//                
//                let filteredSeason = Array((selectedItem.filter { $0.key.section == 3 }).values)
//                let season = filteredSeason.isEmpty ? nil : filteredSeason
//                
//                if let isFixedPriceProducts = isFixedPriceProducts, let lowerValue = lowerValue, let upperValue = upperValue, isFixedPriceProducts {
//                    dataSourceTableView = filterProductsUniversal(products: reserverDataSource, color: color, brand: brand, material: material, season: season, minPrice: Int(lowerValue), maxPrice: Int(upperValue))
//                    countFilterProduct = dataSourceTableView.count
//                    applyCurrentSorting()
//                } else {
//                    dataSourceTableView = filterProductsUniversal(products: reserverDataSource, color: color, brand: brand, material: material, season: season)
//                    countFilterProduct = dataSourceTableView.count
//                    applyCurrentSorting()
//                    if countFilterProduct == 0 {
//                        lowerValue = 0
//                        upperValue = 0
//                    } else {
//                        calculateRangePrice(products: dataSourceTableView)
//                    }
//                }
//            }
//        } else {
//            print("Returne message for analitic FB Crashlystics")
//        }
//    }
//}
//
//
//protocol FilterCellDelegate: AnyObject {
//    func didDeleteCellFilter(_ filterCell: FilterCell)
//}
//class FilterCell: UICollectionViewCell {
//
//    let label: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 15)
//        label.textAlignment = .center
//        label.backgroundColor = .clear
//        label.textColor = UIColor.label
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    let deleteButton: UIButton = {
//        var configuration = UIButton.Configuration.gray()
//        configuration.buttonSize = .large
//        configuration.baseBackgroundColor = .clear
//        configuration.image = UIImage(systemName: "xmark")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
//        var grayButton = UIButton(configuration: configuration)
//        grayButton.translatesAutoresizingMaskIntoConstraints = false
//        grayButton.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
//        
//        return grayButton
//    }()
//    
//    weak var delegate: FilterCellDelegate?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        // Добавление метки на ячейку и установка ограничений для ее размера
//        contentView.backgroundColor = UIColor.secondarySystemBackground
//        contentView.addSubview(label)
//        contentView.addSubview(deleteButton)
//        
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
//            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 0),
//            label.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: 0),
//            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
//        ])
//        
//        NSLayoutConstraint.activate([
//            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
//            deleteButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
//            deleteButton.heightAnchor.constraint(equalTo: label.heightAnchor),
//            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor)
//        ])
////        contentView.layer.borderWidth = 1
////        contentView.layer.borderColor = UIColor.label.cgColor
//        contentView.layer.cornerRadius = 5
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    @objc func didTapDeleteButton(_ sender: UIButton) {
//        delegate?.didDeleteCellFilter(self)
//    }
//}
//
//
//class Product {
//    var color: String?
//    var brand: String?
//    var material: String?
//    var season: String?
//    var price: Int?
//    var sortIndex:Int?
//
//    init(color: String?, brand: String?, material: String?, season: String?, price: Int?, sortIndex:Int?) {
//        self.color = color
//        self.brand = brand
//        self.material = material
//        self.season = season
//        self.price = price
//        self.sortIndex = sortIndex
//    }
//}
//
//class FactoryProducts {
//    
//    static let shared = FactoryProducts()
//    let color = ["Dark", "Bright"]
//    let brand = ["Nike", "Adidas", "Puma", "Reebok", "QuikSilver", "Boss", "LCWKK", "Marko", "Copertiller"]
//    let material = ["Leather", "Artificial Material"]
//    let season = ["Summer", "Winter", "Demi-Season"]
//    
//
//    var products = [Product]()
//
//    func createRandomProduct() -> [Product] {
//        products = []
//        for _ in 1...20 {
//            let randomBrandIndex = Int.random(in: 0..<brand.count)
//            let randomColorIndex = Int.random(in: 0..<color.count)
//            let randomMaterialIndex = Int.random(in: 0..<material.count)
//            let randomSeasonIndex = Int.random(in: 0..<season.count)
//            let randomPrice = Int.random(in: 0...999)
//            let sortIndex = Int.random(in: 0...5)
//
//            let product = Product(color: color[randomColorIndex],
//                                  brand: brand[randomBrandIndex],
//                                  material: material[randomMaterialIndex],
//                                  season: season[randomSeasonIndex],
//                                  price: randomPrice, sortIndex: sortIndex)
//
//            products.append(product)
//        }
//        print("createRandomProduct products.count - \(products.count)")
//        return products
//    }
//
//}
