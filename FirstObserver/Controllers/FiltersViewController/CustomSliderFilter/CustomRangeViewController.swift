////
////  CustomRangeViewController.swift
////  FirstObserver
////
////  Created by Evgenyi on 15.09.23.
////
//
//import Foundation
//import UIKit
//
//
//protocol CustomTabBarViewDelegate: AnyObject {
//    func customTabBarViewDidTapButton(_ tabBarView: CustomTabBarView)
//}
//
//
//class CustomRangeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    var dataSource = [String:[String]]() {
//        didSet {
//            collectionView.reloadData()
//        }
//    }
//    var allProducts:[Product] = []
//    var filterProducts:[Product] = [] {
//        didSet {
//            customTabBarView.setCounterButton(count: filterProducts.count)
//            if filterProducts.isEmpty {
//                print("filterProducts.isEmpty")
////                isTouchUpInside = false
//                isForcedPrice = true
//                rangeSlider.isEnabled = false
//                rangeView.updateLabels(lowerValue: 0, upperValue: 0)
//            } else {
//                    print("calculatePriceForFilterProducts did")
//                    calculatePriceForFilterProducts(products: filterProducts)
//            }
//        }
//    }
//
//    var fixedPriceFilterProducts:[Product] = [] {
//        didSet {
//            customTabBarView.setCounterButton(count: fixedPriceFilterProducts.count)
//        }
//    }
//
//    var selectedStates: [IndexPath: Bool] = [:]
//    var selectedCell: [Int: [String]] = [:]
//
//    var isForcedPrice: Bool = false
//    var isTouchUpInside:Bool = false
//    var isFixedProducts:Bool = false
//
////    var firstMinPrice :Int?
////    var firstMaxPrice :Int?
//
//    var dataManager = FactoryProducts.shared
//
//    private let collectionView: UICollectionView = {
//        let layout = UserProfileTagsFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//
//    let closeButton: UIButton = {
//        var configButton = UIButton.Configuration.plain()
//        configButton.title = "Close"
//        configButton.baseForegroundColor = UIColor.systemPurple
//        configButton.titleAlignment = .leading
//        configButton.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incomig in
//
//            var outgoing = incomig
//            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//            return outgoing
//        }
//        var button = UIButton(configuration: configButton)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    let resetButton: UIButton = {
//        var configButton = UIButton.Configuration.plain()
//        configButton.title = "Reset"
//        configButton.baseForegroundColor = UIColor.systemPurple
//        configButton.titleAlignment = .trailing
//        configButton.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incomig in
//
//            var outgoing = incomig
//            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//            return outgoing
//        }
//        var button = UIButton(configuration: configButton)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    let customTabBarView: CustomTabBarView = {
//        let view = CustomTabBarView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private let rangeView = RangeView()
//    let rangeSlider = RangeSlider(frame: .zero)
//
//    weak var delegate:CustomRangeViewDelegate?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.systemBackground
//
//        // Установка делегатов и источника данных UICollectionView
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        customTabBarView.delegate = self
//        collectionView.backgroundColor = .clear
//
//        // Регистрация класса ячейки UICollectionViewCell для использования в коллекции
//        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "cell")
//        collectionView.register(HeaderFilterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderFilterCollectionReusableView.headerIdentifier)
//
//        // Добавление UICollectionView на экран
//        view.addSubview(rangeView)
//        view.addSubview(rangeSlider)
//        view.addSubview(collectionView)
//        view.addSubview(customTabBarView)
//        configureNavigationBar(largeTitleColor: UIColor.label, backgoundColor: UIColor.secondarySystemBackground, tintColor: UIColor.label, title: "Filters", preferredLargeTitle: false)
//        configureNavigationItem()
////        configureRangeView(minimumValue: 135, maximumValue: 745)
//        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(rangeSlider:)), for: .valueChanged)
//        rangeSlider.addTarget(self, action: #selector(rangeSliderTouchUpInside(rangeSlider:)), for: .touchUpInside)
//
//        // Установка ограничений для UICollectionView чтобы его размер был равен размеру его ячеек
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: rangeSlider.bottomAnchor, constant: 10),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: customTabBarView.topAnchor)
//        ])
//
//        NSLayoutConstraint.activate([
//            customTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            customTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            // Прилипание к нижнему краю экрана
//            customTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//
//        calculateDataSource(products: allProducts)
//        customTabBarView.setCounterButton(count: allProducts.count)
////        fixedPriceFilterProducts = allProducts
////        calculatePriceRange(products: allProducts)
//    }
//
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
////        navigationController?.navigationBar.frame.maxY ??
////        rangeView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90)
//        rangeView.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 90)
//        rangeSlider.frame = CGRect(x: 10, y: rangeView.frame.maxY, width: UIScreen.main.bounds.width - 20, height: 30)
//
//    }
//
//    @objc func rangeSliderValueChanged(rangeSlider: RangeSlider) {
//        print("rangeSliderValueChanged")
////        print("rangeSlider.lowerValue - \(rangeSlider.lowerValue)")
////        print("rangeSlider.upperValue - \(rangeSlider.upperValue)")
//
//        if !isForcedPrice {
//            rangeView.updateLabels(lowerValue: rangeSlider.lowerValue, upperValue: rangeSlider.upperValue)
//        }
//    }
//
//    @objc func rangeSliderTouchUpInside(rangeSlider: RangeSlider) {
//        print("rangeSliderTouchUpInside")
//        //        print("rangeSliderTouchUpInside lowerValue - \(rangeSlider.lowerValue)")
//        //        print("rangeSliderTouchUpInside upperValue - \(rangeSlider.upperValue)")
//        isFixedProducts = true
//        fixedPriceFilterProducts = filterProductsUniversal(products: allProducts, color: selectedCell[0], brand: selectedCell[1], material: selectedCell[2], season: selectedCell[3], minPrice: Int(rangeSlider.lowerValue), maxPrice: Int(rangeSlider.upperValue))
////        if let firstMaxPrice = firstMaxPrice, let firstMinPrice = firstMinPrice, firstMinPrice == Int(rangeSlider.lowerValue) && firstMaxPrice == Int(rangeSlider.upperValue) {
////            isFixedProducts = false
////            filterProducts = filterProductsUniversal(products: allProducts, color: selectedCell[0], brand: selectedCell[1], material: selectedCell[2], season: selectedCell[3])
////        } else {
////            isFixedProducts = true
////            fixedPriceFilterProducts = filterProductsUniversal(products: allProducts, color: selectedCell[0], brand: selectedCell[1], material: selectedCell[2], season: selectedCell[3], minPrice: Int(rangeSlider.lowerValue), maxPrice: Int(rangeSlider.upperValue))
////        }
//    }
//
//
//    @objc func didTapCloseButton() {
//        self.dismiss(animated: true, completion: nil)
//        print("didTapCloseButton")
////        navigationController?.popViewController(animated: true)
////        rangeSlider.isEnabled = false
//    }
//
//    @objc func didTapResetButton() {
//        rangeSlider.isEnabled = true
//        isForcedPrice = false
//        isFixedProducts = false
//        selectedCell = [:]
//        selectedStates = [:]
//        customTabBarView.setCounterButton(count: allProducts.count)
//        calculatePriceForFilterProducts(products: allProducts)
//        collectionView.reloadData()
//        print("didTapResetButton")
//    }
//
//    private func configureNavigationItem() {
//
//        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
//        resetButton.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: resetButton)
//    }
//
//    private func configureRangeView(minimumValue:Double, maximumValue:Double) {
//        rangeSlider.minimumValue = minimumValue
//        rangeSlider.maximumValue = maximumValue
//        rangeSlider.lowerValue = minimumValue
//        rangeSlider.upperValue = maximumValue
//    }
//
//    private func calculateDataSource(products: [Product]) {
//
//        var minPrice = Int.max
//        var maxPrice = Int.min
//        var dataSource = [String: [String]]()
//        var counter = 0
//        for product in products {
//            counter+=1
//            if let color = product.color {
//                dataSource["color", default: []].append(color)
//            }
//            if let brand = product.brand {
//                dataSource["brand", default: []].append(brand)
//            }
//            if let material = product.material {
//                dataSource["material", default: []].append(material)
//            }
//            if let season = product.season {
//                dataSource["season", default: []].append(season)
//            }
//            if let price = product.price {
//
//                   if price < minPrice {
//                       minPrice = price
//                   }
//                   if price > maxPrice {
//                       maxPrice = price
//                   }
//               }
//        }
//        if counter == products.count {
//            for key in dataSource.keys {
//                let values = Set(dataSource[key]!)
//                dataSource[key] = Array(values)
//                let sortValue = dataSource[key]?.sorted()
//                dataSource[key] = sortValue
//            }
//            configureRangeView(minimumValue: Double(minPrice), maximumValue: Double(maxPrice))
////            rangeView.updateLabels(lowerValue: rangeSlider.lowerValue, upperValue: rangeSlider.upperValue)
//            self.dataSource = dataSource
//        }
//    }
//
////    private func calculatePriceRange(products: [Product]) {
////        var minPrice = Int.max
////        var maxPrice = Int.min
////
////        var counter = 0
////        for product in products {
////            counter+=1
////
////            if let price = product.price {
////
////                if price < minPrice {
////                    minPrice = price
////                }
////                if price > maxPrice {
////                    maxPrice = price
////                }
////            }
////        }
////
////        if counter == products.count {
////            print("minimumValue - \(minPrice)")
////            print("maximumValue - \(maxPrice)")
////            firstMinPrice = minPrice
////            firstMaxPrice = maxPrice
////        }
////    }
//
//    private func calculatePriceForFilterProducts(products: [Product]) {
//
//        print("calculatePriceForFilterProducts(product.count) - \(products.count)")
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
//            print("minimumValue - \(minPrice)")
//            print("maximumValue - \(maxPrice)")
//            if minPrice != maxPrice {
//                configureRangeView(minimumValue: Double(minPrice), maximumValue: Double(maxPrice))
//            } else {
//                print("minPrice == maxPrice")
//                isForcedPrice = true
//                rangeSlider.isEnabled = false
//                rangeView.updateLabels(lowerValue: Double(minPrice), upperValue: Double(maxPrice))
//            }
//
//        }
//    }
//
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
//    // MARK: - UICollectionViewDataSource
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return dataSource.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        switch section {
//        case 0:
//            return dataSource["color"]?.count ?? 0
////            return colors.count
//        case 1:
//            return dataSource["brand"]?.count ?? 0
////            return brands.count
//        case 2:
//            return dataSource["material"]?.count ?? 0
////            return material.count
//        case 3:
//            return dataSource["season"]?.count ?? 0
////            return season.count
//        default:
//            print("Returned message for analytic FB Crashlytics error")
//            return 0
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCell else {
//            return UICollectionViewCell()
//        }
//
//        if let isSelected = selectedStates[indexPath], isSelected {
//            cell.contentView.backgroundColor = UIColor.systemPurple
//               } else {
//                   cell.contentView.backgroundColor = UIColor.secondarySystemBackground
//               }
//
//
//        switch indexPath.section {
//        case 0:
//            let colors = dataSource["color"]
//            cell.label.text = colors?[indexPath.row]
////            cell.label.text = colors[indexPath.row]
//        case 1:
//            let brands = dataSource["brand"]
//            cell.label.text = brands?[indexPath.row]
////            cell.label.text = brands[indexPath.row]
//        case 2:
//            let material = dataSource["material"]
//            cell.label.text = material?[indexPath.row]
////            cell.label.text = material[indexPath.row]
//        case 3:
//            let season = dataSource["season"]
//            cell.label.text = season?[indexPath.row]
////            cell.label.text = season[indexPath.row]
//        default:
//            print("Returned message for analytic FB Crashlytics error")
//        }
//        return cell
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        isForcedPrice = false
////        isTouchUpInside = false
//
//        if selectedStates[indexPath] == true {
//                    selectedStates[indexPath] = false
//                } else {
//                    selectedStates[indexPath] = true
//                }
//
//        guard let cell = collectionView.cellForItem(at: indexPath) as? MyCell else {
//                return
//            }
//
//            let section = indexPath.section
//            let item = cell.label.text ?? ""
//
//            if var cellsInSection = selectedCell[section] {
//                if let indexToRemove = cellsInSection.firstIndex(of: item) {
//                    // Удаляем элемент из массива, если он уже был выбран
//                    cellsInSection.remove(at: indexToRemove)
//                } else {
//                    // Добавляем элемент в массив, если он еще не был выбран
//                    cellsInSection.append(item)
//                }
//                if cellsInSection.isEmpty {
//                    selectedCell[section] = nil
//                } else {
//                    selectedCell[section] = cellsInSection
//                }
//            } else {
//                // Если ключ секции отсутствует в словаре, создаем новый массив и добавляем элемент
//                selectedCell[section] = [item]
//            }
//
//        if !isFixedProducts {
//            rangeSlider.isEnabled = true
//            filterProducts = filterProductsUniversal(products: allProducts, color: selectedCell[0], brand: selectedCell[1], material: selectedCell[2], season: selectedCell[3])
//        } else {
//            fixedPriceFilterProducts = filterProductsUniversal(products: allProducts, color: selectedCell[0], brand: selectedCell[1], material: selectedCell[2], season: selectedCell[3], minPrice: Int(rangeSlider.lowerValue), maxPrice: Int(rangeSlider.upperValue))
//        }
//
//        // уходим от анимированного изменения цвета
//        UIView.performWithoutAnimation {
//               collectionView.reloadItems(at: [indexPath])
//           }
//
//        print("didSelectItemAt - \(selectedCell)")
//    }
//
//
//
//    // MARK: - UICollectionViewDelegateFlowLayout
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        var labelSize = CGSize()
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCell
//
//        switch indexPath.section {
//        case 0:
//            let colors = dataSource["color"]
//            cell?.label.text = colors?[indexPath.row]
////            cell?.label.text = colors[indexPath.row]
//            //             Определяем размеры метки с помощью метода sizeThatFits()
//            labelSize = cell?.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
//            labelSize = CGSize(width: labelSize.width + 20, height: labelSize.height + 20)
//        case 1:
//            let brands = dataSource["brand"]
//            cell?.label.text = brands?[indexPath.row]
////            cell?.label.text = brands[indexPath.row]
//            //             Определяем размеры метки с помощью метода sizeThatFits()
//            labelSize = cell?.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
//            labelSize = CGSize(width: labelSize.width + 20, height: labelSize.height + 20)
//        case 2:
//            let material = dataSource["material"]
//            cell?.label.text = material?[indexPath.row]
////            cell?.label.text = material[indexPath.row]
//            //             Определяем размеры метки с помощью метода sizeThatFits()
//            labelSize = cell?.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
//            labelSize = CGSize(width: labelSize.width + 20, height: labelSize.height + 20)
//        case 3:
//            let season = dataSource["season"]
//            cell?.label.text = season?[indexPath.row]
////            cell?.label.text = season[indexPath.row]
//            //             Определяем размеры метки с помощью метода sizeThatFits()
//            labelSize = cell?.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
//            labelSize = CGSize(width: labelSize.width + 20, height: labelSize.height + 20)
//        default:
//            print("Returned message for analytic FB Crashlytics error")
//            labelSize = .zero
//        }
//        return labelSize
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        if kind == UICollectionView.elementKindSectionHeader {
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderFilterCollectionReusableView.headerIdentifier, for: indexPath) as! HeaderFilterCollectionReusableView
//
//            // Customize your header view here based on the section index
//            switch indexPath.section {
//            case 0:
//                headerView.configureCell(title: "Color")
//            case 1:
//                headerView.configureCell(title: "Brand")
//            case 2:
//                headerView.configureCell(title: "Material")
//            case 3:
//                headerView.configureCell(title: "Season")
//            default:
//                break
//            }
//
//            return headerView
//        }
//        fatalError("Unexpected element kind")
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        let headerView = HeaderFilterCollectionReusableView()
//        headerView.configureCell(title: "Test")
//        let width = collectionView.bounds.width
//        let height = headerView.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)).height
//
//        return CGSize(width: width, height: height)
//    }
//}
//
//extension CustomRangeViewController: CustomTabBarViewDelegate {
//    func customTabBarViewDidTapButton(_ tabBarView: CustomTabBarView) {
//        // Ваш код обработки нажатия на кнопку
//        print("customTabBarViewDidTapButton")
//        // при первом старте если нажмем Done уйдет пустой массив в любом случае
//        if !isFixedProducts {
//            delegate?.didTapDone(filterProducts: filterProducts)
//        } else {
//            delegate?.didTapDone(filterProducts: fixedPriceFilterProducts)
//        }
//        self.dismiss(animated: true, completion: nil)
//    }
//}
//
//extension UIViewController {
//
//    /// configure navigationBar and combines status bar with navigationBar
//    func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
//    if #available(iOS 13.0, *) {
//        let navBarAppearance = UINavigationBarAppearance()
//        navBarAppearance.configureWithOpaqueBackground()
//        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
//        navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
//        navBarAppearance.backgroundColor = backgoundColor
//        navBarAppearance.shadowColor = .clear
//
//        navigationController?.navigationBar.standardAppearance = navBarAppearance
//        navigationController?.navigationBar.compactAppearance = navBarAppearance
//        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
//
//        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.tintColor = tintColor
//        navigationItem.title = title
//
//    } else {
//        // Fallback on earlier versions
//        navigationController?.navigationBar.barTintColor = backgoundColor
//        navigationController?.navigationBar.tintColor = tintColor
//        navigationController?.navigationBar.isTranslucent = false
////        navigationController?.navigationBar.layer.shadowColor = nil
//        navigationItem.title = title
//    }
//}}
//
//
//
//class MyCell: UICollectionViewCell {
//
//    let label: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 17)
//        label.textAlignment = .center
//        label.textColor = UIColor.label
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        // Добавление метки на ячейку и установка ограничений для ее размера
//        contentView.backgroundColor = UIColor.secondarySystemBackground
//        contentView.addSubview(label)
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
//            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 0),
//            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
//            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
//        ])
////        contentView.layer.borderWidth = 1
////        contentView.layer.borderColor = UIColor.label.cgColor
//        contentView.layer.cornerRadius = 5
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//
//class UserProfileTagsFlowLayout: UICollectionViewFlowLayout {
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        guard let attributesForElementsInRect = super.layoutAttributesForElements(in: rect) else { return nil }
//        guard var newAttributesForElementsInRect = NSArray(array: attributesForElementsInRect, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
//
//        var leftMargin: CGFloat = 0.0;
//
//        for attributes in attributesForElementsInRect {
//            if (attributes.frame.origin.x == self.sectionInset.left) {
//                leftMargin = self.sectionInset.left
//            }
//            else {
//                var newLeftAlignedFrame = attributes.frame
//                newLeftAlignedFrame.origin.x = leftMargin
//                attributes.frame = newLeftAlignedFrame
//            }
//            leftMargin += attributes.frame.size.width + 8 // Makes the space between cells
//            newAttributesForElementsInRect.append(attributes)
//        }
//
//        return newAttributesForElementsInRect
//    }
//}
//
//
//
//protocol HeaderFilterCollectionViewDelegate: AnyObject {
//    func didSelectSegmentControl()
//}
//
//class HeaderFilterCollectionReusableView: UICollectionReusableView {
//
//    static let headerIdentifier = "HeaderFilterVC"
//    weak var delegate: HeaderFilterCollectionViewDelegate?
////    private let separatorView: UIView = {
////        let view = UIView()
////        view.translatesAutoresizingMaskIntoConstraints = false
////        view.backgroundColor = UIColor.opaqueSeparator
////        return view
////    }()
//
//    let label:UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        label.backgroundColor = .clear
////        label.tintColor = .black
//        label.textColor = UIColor.label
//        label.numberOfLines = 0
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(label)
////        addSubview(separatorView)
//        setupConstraints()
//        backgroundColor = .clear
//    }
//
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: topAnchor, constant: 5), label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5), label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10), label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)])
//
//
////        NSLayoutConstraint.activate([
////            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
////            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
////            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
////            separatorView.heightAnchor.constraint(equalToConstant: 1.0) // Высота разделителя
////        ])
//
//    }
//
//    func configureCell(title: String) {
//        label.text = title
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        addSubview(label)
//        setupConstraints()
//        backgroundColor = .clear
////        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//class CustomTabBarView: UIView {
//
//    weak var delegate: CustomTabBarViewDelegate?
//
//    let button: UIButton = {
//        var configButton = UIButton.Configuration.gray()
//        configButton.title = "Show products"
//        configButton.baseForegroundColor = UIColor.label
//        configButton.buttonSize = .large
//        configButton.baseBackgroundColor = UIColor.systemPurple
//        configButton.titleAlignment = .leading
//        configButton.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incomig in
//
//            var outgoing = incomig
//            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//            return outgoing
//        }
//        var button = UIButton(configuration: configButton)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = UIColor.secondarySystemBackground
//        setupButton()
//        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        setupButton()
//    }
//
//    private func setupButton() {
//        addSubview(button)
//
//        button.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            button.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//            // Установим отступ до зоны жестов
//            button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
//        ])
//    }
//
//    func setCounterButton(count:Int) {
//        button.configuration?.title = "Show products(\(count))"
//    }
//
//    @objc func didTapDoneButton() {
//        delegate?.customTabBarViewDidTapButton(self)
////        print("didTapDoneButton")
//    }
//}
//
//
//class RangeView: UIView {
//
//    let fromLabel: UILabel = {
//        let view = UILabel()
//        view.textColor = UIColor.label
//        view.textAlignment = .center
//        return view
//    }()
//
//    let toLabel: UILabel = {
//        let view = UILabel()
//        view.textColor = UIColor.label
//        view.textAlignment = .center
//        return view
//    }()
//
//    let titleLabel: UILabel = {
//        let view = UILabel()
//        view.textColor = UIColor.label
////        view.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        view.textAlignment = .left
//        return view
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .clear
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setupUI()
//    }
//
//    private func setupUI() {
//
//        // UILabel сверху на всю ширину
//        titleLabel.frame = CGRect(x: 10, y: 0, width: frame.width - 20, height: 30)
//        titleLabel.text = "Price range"
//        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        addSubview(titleLabel)
//
//        // Левый UILabel в одном ряду со сверху лежащим UILabel
//        fromLabel.frame = CGRect(x: 10, y: titleLabel.frame.maxY + 10, width: 60, height: 30)
////        fromLabel.text = "238"
//        fromLabel.backgroundColor = UIColor.secondarySystemBackground
//        fromLabel.layer.cornerRadius = 5
//        fromLabel.clipsToBounds = true
//        addSubview(fromLabel)
//
//        // Правый UILabel в одном ряду со сверху лежащим UILabel и прижатый к правому краю
//        toLabel.frame = CGRect(x: frame.width - 70, y: titleLabel.frame.maxY + 10, width: 60, height: 30)
////        toLabel.text = "765"
//        toLabel.backgroundColor = UIColor.secondarySystemBackground
//        toLabel.layer.cornerRadius = 5
//        toLabel.clipsToBounds = true
//        addSubview(toLabel)
//    }
//
//
//    func updateLabels(lowerValue:Double, upperValue:Double) {
////        let formatter = NumberFormatter()
////        formatter.numberStyle = .currency
////
////      let minimumValueString = formatter.string(from: NSNumber(value: lowerValue))
////      let maximumValueString = formatter.string(from: NSNumber(value: upperValue))
//
////      fromLabel.text = "From \(minimumValueString ?? "")"
////      toLabel.text = "To \(maximumValueString ?? "")"
//        fromLabel.text = "\(Int(lowerValue))"
//        toLabel.text = "\(Int(upperValue))"
//    }
//
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupUI()
//    }
//}




//protocol CustomRangeViewDelegate: AnyObject {
//    func didTapDone(filterProducts:[Product])
//}
//class ListViewController: UIViewController {
//
//    var reserverDataSource: [Product] = []
//    var dataSource: [Product] = [] {
//        didSet {
//            tableView.reloadData()
//        }
//    }
//    var dataManager = FactoryProducts.shared
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
//        view.backgroundColor = .clear
//        tableView.delegate = self
//        tableView.dataSource = self
//        view.addSubview(tableView)
//        setupConstraints()
//        configureNavigationItem()
//        dataSource = dataManager.createRandomProduct()
//        reserverDataSource = dataSource
//    }
//
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0), tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0), tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0), tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)])
//    }
//
//    private func configureNavigationItem() {
//
//        // Создание кнопок
//        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease"), style: .plain, target: self, action: #selector(filterButtonTapped))
//        let sortedButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortedButtonTapped))
//        navigationItem.rightBarButtonItems = [sortedButton, filterButton]
//    }
//
//    @objc func filterButtonTapped() {
//        print("filterButtonTapped()")
//        let customVC = CustomRangeViewController()
//        customVC.allProducts = reserverDataSource
//        customVC.delegate = self
//        let navigationVC = CustomNavigationController(rootViewController: customVC)
//        navigationVC.navigationBar.backgroundColor = UIColor.secondarySystemBackground
//        navigationVC.modalPresentationStyle = .fullScreen
//        present(navigationVC, animated: true, completion: nil)
//    }
//
//    @objc func sortedButtonTapped() {
//        print("sortedButtonTapped()")
//        // Обработчик нажатия на кнопку "sorted"
//    }
//
//}
//
//extension ListViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        dataSource.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
//        let separator = " "
//        let combinedStringWithSeparator = [String("\(dataSource[indexPath.row].price!)"), dataSource[indexPath.row].material ?? "", dataSource[indexPath.row].season ?? "", dataSource[indexPath.row].color ?? ""].joined(separator: separator)
//
//        var contentCell = cell.defaultContentConfiguration()
//
//        contentCell.text = dataSource[indexPath.row].brand
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
//extension ListViewController:CustomRangeViewDelegate {
//    func didTapDone(filterProducts: [Product]) {
//        dataSource = filterProducts
//    }
//}


//class ViewController: UIViewController {
//
//    var dataSource = [String:[String]]()
//    let customRangeButton: UIButton = {
//        var configuration = UIButton.Configuration.gray()
//
//        configuration.titleAlignment = .center
//        configuration.buttonSize = .large
//        configuration.baseBackgroundColor = .systemPink
//
//        var container = AttributeContainer()
//        container.font = UIFont.boldSystemFont(ofSize: 15)
//        container.foregroundColor = .black
//        configuration.attributedTitle = AttributedString("CustomRangeVC", attributes: container)
//
//        var grayButton = UIButton(configuration: configuration)
//        grayButton.translatesAutoresizingMaskIntoConstraints = false
//        grayButton.addTarget(self, action: #selector(addCustomRangeButton(_:)), for: .touchUpInside)
//
//        return grayButton
//    }()
//
//    var dataManager = FactoryProducts.shared
//
//    let dependencyRangeButton: UIButton = {
//
//        var configuration = UIButton.Configuration.gray()
//
//        configuration.titleAlignment = .center
//        configuration.buttonSize = .large
//        configuration.baseBackgroundColor = .systemPink
//
//        var container = AttributeContainer()
//        container.font = UIFont.boldSystemFont(ofSize: 15)
//        container.foregroundColor = .black
//        configuration.attributedTitle = AttributedString("DependencyRangeVC", attributes: container)
//
//        var grayButton = UIButton(configuration: configuration)
//        grayButton.translatesAutoresizingMaskIntoConstraints = false
//        grayButton.addTarget(self, action: #selector(addDependencyRangeButton(_:)), for: .touchUpInside)
//
//        return grayButton
//    }()
//
//    let stackViewForButton: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .vertical
//        stack.distribution = .fill
//        stack.spacing = 5
//        return stack
//    }()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .systemGray6
//
//        stackViewForButton.addArrangedSubview(customRangeButton)
//        stackViewForButton.addArrangedSubview(dependencyRangeButton)
//        view.addSubview(stackViewForButton)
//
//        NSLayoutConstraint.activate([stackViewForButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), stackViewForButton.centerYAnchor.constraint(equalTo: view.centerYAnchor), stackViewForButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), stackViewForButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)])
//
//    }
//
//    @objc func addCustomRangeButton(_ sender: UIButton) {
//
////        let color = ["Red", "Blue", "Green", "Black", "White", "Purpure", "Yellow", "Pink"]
////        let brand = ["Nike", "Adidas", "Puma", "Reebok", "QuikSilver", "Boss", "LCWKK", "Marko", "BMW", "Copertiller"]
////        let material = ["leather", "artificial material"]
////        let season = ["summer", "winter", "demi-season"]
////        dataSource["colors"] = color
////        dataSource["brands"] = brand
////        dataSource["material"] = material
////        dataSource["season"] = season
//        let customVC = CustomRangeViewController()
//        customVC.allProducts = dataManager.createRandomProduct()
//        let navigationVC = CustomNavigationController(rootViewController: customVC)
//        navigationVC.navigationBar.backgroundColor = UIColor.secondarySystemBackground
//        navigationVC.modalPresentationStyle = .fullScreen
//        present(navigationVC, animated: true, completion: nil)
//    }
//
//    @objc func addDependencyRangeButton(_ sender: UIButton) {
//
//    }
//}
//
//class CustomNavigationController: UINavigationController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//    }
//}
//
//class Product {
//    var color: String?
//    var brand: String?
//    var material: String?
//    var season: String?
//    var price: Int?
//
//    init(color: String?, brand: String?, material: String?, season: String?, price: Int?) {
//        self.color = color
//        self.brand = brand
//        self.material = material
//        self.season = season
//        self.price = price
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
//
//            let product = Product(color: color[randomColorIndex],
//                                  brand: brand[randomBrandIndex],
//                                  material: material[randomMaterialIndex],
//                                  season: season[randomSeasonIndex],
//                                  price: randomPrice)
//
//            products.append(product)
//        }
//        print("createRandomProduct products.count - \(products.count)")
//        return products
//    }
//
//}






















// saved alert - logic filter -

//class CustomRangeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    var dataSource = [String:[String]]() {
//        didSet {
//            collectionView.reloadData()
//        }
//    }
//    var allProducts:[Product] = []
//    var filterProducts:[Product] = [] {
//        didSet {
//            customTabBarView.setCounterButton(count: filterProducts.count)
//            if filterProducts.isEmpty {
//                print("filterProducts.isEmpty")
////                isTouchUpInside = false
//                isForcedPrice = true
//                rangeSlider.isEnabled = false
//                rangeView.updateLabels(lowerValue: 0, upperValue: 0)
//            } else {
//                    print("calculatePriceForFilterProducts did")
//                    calculatePriceForFilterProducts(products: filterProducts)
//            }
//        }
//    }
//
//
//    // conserva
////    var filterProducts:[Product] = [] {
////        didSet {
////            customTabBarView.setCounterButton(count: filterProducts.count)
////            if filterProducts.isEmpty {
////                print("filterProducts.isEmpty")
////                isTouchUpInside = false
////                isForcedPrice = true
////                rangeView.updateLabels(lowerValue: 0, upperValue: 0)
////            } else {
////                if isTouchUpInside {
////                    isTouchUpInside = false
////                } else {
////                    calculatePriceForFilterProducts(products: filterProducts)
////                }
////            }
////        }
////    }
//
//    var fixedPriceFilterProducts:[Product] = [] {
//        didSet {
//            customTabBarView.setCounterButton(count: fixedPriceFilterProducts.count)
//        }
//    }
//
//    var selectedStates: [IndexPath: Bool] = [:]
//    var selectedCell: [Int: [String]] = [:]
//
//    var isForcedPrice: Bool = false
//    var isTouchUpInside:Bool = false
//    var isFixedProducts:Bool = false
//
//    var dataManager = FactoryProducts.shared
//
//    private let collectionView: UICollectionView = {
//        let layout = UserProfileTagsFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//
//    let closeButton: UIButton = {
//        var configButton = UIButton.Configuration.plain()
//        configButton.title = "Close"
//        configButton.baseForegroundColor = UIColor.systemPurple
//        configButton.titleAlignment = .leading
//        configButton.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incomig in
//
//            var outgoing = incomig
//            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//            return outgoing
//        }
//        var button = UIButton(configuration: configButton)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    let resetButton: UIButton = {
//        var configButton = UIButton.Configuration.plain()
//        configButton.title = "Reset"
//        configButton.baseForegroundColor = UIColor.systemPurple
//        configButton.titleAlignment = .trailing
//        configButton.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incomig in
//
//            var outgoing = incomig
//            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//            return outgoing
//        }
//        var button = UIButton(configuration: configButton)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    let customTabBarView: CustomTabBarView = {
//        let view = CustomTabBarView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private let rangeView = RangeView()
//    let rangeSlider = RangeSlider(frame: .zero)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.systemBackground
//
//        // Установка делегатов и источника данных UICollectionView
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        customTabBarView.delegate = self
//        collectionView.backgroundColor = .clear
//
//        // Регистрация класса ячейки UICollectionViewCell для использования в коллекции
//        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "cell")
//        collectionView.register(HeaderFilterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderFilterCollectionReusableView.headerIdentifier)
//
//        // Добавление UICollectionView на экран
//        view.addSubview(rangeView)
//        view.addSubview(rangeSlider)
//        view.addSubview(collectionView)
//        view.addSubview(customTabBarView)
//        configureNavigationBar(largeTitleColor: UIColor.label, backgoundColor: UIColor.secondarySystemBackground, tintColor: UIColor.label, title: "Filters", preferredLargeTitle: false)
//        configureNavigationItem()
////        configureRangeView(minimumValue: 135, maximumValue: 745)
//        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(rangeSlider:)), for: .valueChanged)
//        rangeSlider.addTarget(self, action: #selector(rangeSliderTouchUpInside(rangeSlider:)), for: .touchUpInside)
//
//        // Установка ограничений для UICollectionView чтобы его размер был равен размеру его ячеек
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: rangeSlider.bottomAnchor, constant: 10),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: customTabBarView.topAnchor)
//        ])
//
//        NSLayoutConstraint.activate([
//            customTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            customTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            // Прилипание к нижнему краю экрана
//            customTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//
//        calculateDataSource(products: allProducts)
//        customTabBarView.setCounterButton(count: allProducts.count)
//    }
//
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
////        navigationController?.navigationBar.frame.maxY ??
////        rangeView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90)
//        rangeView.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 90)
//        rangeSlider.frame = CGRect(x: 10, y: rangeView.frame.maxY, width: UIScreen.main.bounds.width - 20, height: 30)
//
//    }
//
//    @objc func rangeSliderValueChanged(rangeSlider: RangeSlider) {
//        print("rangeSliderValueChanged")
////        print("rangeSlider.lowerValue - \(rangeSlider.lowerValue)")
////        print("rangeSlider.upperValue - \(rangeSlider.upperValue)")
//
//        if !isForcedPrice {
//            rangeView.updateLabels(lowerValue: rangeSlider.lowerValue, upperValue: rangeSlider.upperValue)
//        }
//    }
//
//    // conserva
////    @objc func rangeSliderValueChanged(rangeSlider: RangeSlider) {
////        print("rangeSliderValueChanged")
//////        print("rangeSlider.lowerValue - \(rangeSlider.lowerValue)")
//////        print("rangeSlider.upperValue - \(rangeSlider.upperValue)")
////
////        if !isForcedPrice {
////            rangeView.updateLabels(lowerValue: rangeSlider.lowerValue, upperValue: rangeSlider.upperValue)
////        }
////    }
//
//    @objc func rangeSliderTouchUpInside(rangeSlider: RangeSlider) {
//        print("rangeSliderTouchUpInside")
//        //        print("rangeSliderTouchUpInside lowerValue - \(rangeSlider.lowerValue)")
//        //        print("rangeSliderTouchUpInside upperValue - \(rangeSlider.upperValue)")
//        isFixedProducts = true
//        fixedPriceFilterProducts = filterProductsUniversal(products: allProducts, color: selectedCell[0], brand: selectedCell[1], material: selectedCell[2], season: selectedCell[3], minPrice: Int(rangeSlider.lowerValue), maxPrice: Int(rangeSlider.upperValue))
//
//    }
//
//    // conserva
////    @objc func rangeSliderTouchUpInside(rangeSlider: RangeSlider) {
////                print("rangeSliderTouchUpInside")
////        isTouchUpInside = true
//////        isFixedProducts = true
////        //        isForcedPrice = false
////        if !isForcedPrice {
////            print("rangeSliderTouchUpInside lowerValue - \(rangeSlider.lowerValue)")
////            print("rangeSliderTouchUpInside upperValue - \(rangeSlider.upperValue)")
////            filterProducts = filterProductsUniversal(products: allProducts, color: selectedCell[0], brand: selectedCell[1], material: selectedCell[2], season: selectedCell[3], minPrice: Int(rangeSlider.lowerValue), maxPrice: Int(rangeSlider.upperValue))
////        }
////
////    }
//
//
//    @objc func didTapCloseButton() {
//        self.dismiss(animated: true, completion: nil)
//        print("didTapCloseButton")
////        rangeSlider.isEnabled = false
//    }
//
//    @objc func didTapResetButton() {
//        rangeSlider.isEnabled = true
//        isForcedPrice = false
//        isFixedProducts = false
//        selectedCell = [:]
//        selectedStates = [:]
//        customTabBarView.setCounterButton(count: allProducts.count)
//        calculatePriceForFilterProducts(products: allProducts)
//        collectionView.reloadData()
//        print("didTapResetButton")
//    }
//
//    // conserva
////    @objc func didTapResetButton() {
////        isForcedPrice = false
////        isTouchUpInside = false
////        selectedCell = [:]
////        selectedStates = [:]
////        customTabBarView.setCounterButton(count: allProducts.count)
////        calculatePriceForFilterProducts(products: allProducts)
////        collectionView.reloadData()
////        print("didTapResetButton")
////    }
//
//    private func configureNavigationItem() {
//
//        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
//        resetButton.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: resetButton)
//    }
//
//    private func configureRangeView(minimumValue:Double, maximumValue:Double) {
//        rangeSlider.minimumValue = minimumValue
//        rangeSlider.maximumValue = maximumValue
//        rangeSlider.lowerValue = minimumValue
//        rangeSlider.upperValue = maximumValue
//    }
//
//    private func calculateDataSource(products: [Product]) {
//
//        var minPrice = Int.max
//        var maxPrice = Int.min
//        var dataSource = [String: [String]]()
//        var counter = 0
//        for product in products {
//            counter+=1
//            if let color = product.color {
//                dataSource["color", default: []].append(color)
//            }
//            if let brand = product.brand {
//                dataSource["brand", default: []].append(brand)
//            }
//            if let material = product.material {
//                dataSource["material", default: []].append(material)
//            }
//            if let season = product.season {
//                dataSource["season", default: []].append(season)
//            }
//            if let price = product.price {
//
//                   if price < minPrice {
//                       minPrice = price
//                   }
//                   if price > maxPrice {
//                       maxPrice = price
//                   }
//               }
//        }
//        if counter == products.count {
//            for key in dataSource.keys {
//                let values = Set(dataSource[key]!)
//                dataSource[key] = Array(values)
//                let sortValue = dataSource[key]?.sorted()
//                dataSource[key] = sortValue
//            }
//            configureRangeView(minimumValue: Double(minPrice), maximumValue: Double(maxPrice))
////            rangeView.updateLabels(lowerValue: rangeSlider.lowerValue, upperValue: rangeSlider.upperValue)
//            self.dataSource = dataSource
//        }
//    }
//
//    private func calculatePriceForFilterProducts(products: [Product]) {
//
//        print("calculatePriceForFilterProducts(product.count) - \(products.count)")
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
//            print("minimumValue - \(minPrice)")
//            print("maximumValue - \(maxPrice)")
//            if minPrice != maxPrice {
//                configureRangeView(minimumValue: Double(minPrice), maximumValue: Double(maxPrice))
//            } else {
//                print("minPrice == maxPrice")
//                isForcedPrice = true
//                rangeSlider.isEnabled = false
//                rangeView.updateLabels(lowerValue: Double(minPrice), upperValue: Double(maxPrice))
//            }
//
//        }
//    }
//
//    // conserva
////    private func calculatePriceForFilterProducts(products: [Product]) {
////
////        print("calculatePriceForFilterProducts(product.count) - \(products.count)")
////        var minPrice = Int.max
////        var maxPrice = Int.min
////
////        var counter = 0
////        for product in products {
////            counter+=1
////
////            if let price = product.price {
////
////                if price < minPrice {
////                    minPrice = price
////                }
////                if price > maxPrice {
////                    maxPrice = price
////                }
////            }
////        }
////
////        if counter == products.count {
////            print("minimumValue - \(minPrice)")
////            print("maximumValue - \(maxPrice)")
////            if minPrice != maxPrice {
////                configureRangeView(minimumValue: Double(minPrice), maximumValue: Double(maxPrice))
////            } else {
////                print("minPrice == maxPrice")
////                isForcedPrice = true
////                rangeView.updateLabels(lowerValue: Double(minPrice), upperValue: Double(maxPrice))
////            }
////
////        }
////    }
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
//
////    func filterProductsUniversal(products: [Product], color: [String]? = nil, brand: [String]? = nil, material: [String]? = nil, season: [String]? = nil) -> [Product] {
////        let filteredProducts = products.filter { product in
////            var isMatched = true
////
////            if let color = color {
////                isMatched = isMatched && color.contains(product.color ?? "")
////            }
////
////            if let brand = brand {
////                isMatched = isMatched && brand.contains(product.brand ?? "")
////            }
////
////            if let material = material {
////                isMatched = isMatched && material.contains(product.material ?? "")
////            }
////
////            if let season = season {
////                isMatched = isMatched && season.contains(product.season ?? "")
////            }
////
////            return isMatched
////        }
////
////        return filteredProducts
////    }
//
//    // MARK: - UICollectionViewDataSource
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return dataSource.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        switch section {
//        case 0:
//            return dataSource["color"]?.count ?? 0
////            return colors.count
//        case 1:
//            return dataSource["brand"]?.count ?? 0
////            return brands.count
//        case 2:
//            return dataSource["material"]?.count ?? 0
////            return material.count
//        case 3:
//            return dataSource["season"]?.count ?? 0
////            return season.count
//        default:
//            print("Returned message for analytic FB Crashlytics error")
//            return 0
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCell else {
//            return UICollectionViewCell()
//        }
//
//        if let isSelected = selectedStates[indexPath], isSelected {
//            cell.contentView.backgroundColor = UIColor.systemPurple
//               } else {
//                   cell.contentView.backgroundColor = UIColor.secondarySystemBackground
//               }
//
//
//        switch indexPath.section {
//        case 0:
//            let colors = dataSource["color"]
//            cell.label.text = colors?[indexPath.row]
////            cell.label.text = colors[indexPath.row]
//        case 1:
//            let brands = dataSource["brand"]
//            cell.label.text = brands?[indexPath.row]
////            cell.label.text = brands[indexPath.row]
//        case 2:
//            let material = dataSource["material"]
//            cell.label.text = material?[indexPath.row]
////            cell.label.text = material[indexPath.row]
//        case 3:
//            let season = dataSource["season"]
//            cell.label.text = season?[indexPath.row]
////            cell.label.text = season[indexPath.row]
//        default:
//            print("Returned message for analytic FB Crashlytics error")
//        }
//        return cell
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        isForcedPrice = false
////        isTouchUpInside = false
//
//        if selectedStates[indexPath] == true {
//                    selectedStates[indexPath] = false
//                } else {
//                    selectedStates[indexPath] = true
//                }
//
//        guard let cell = collectionView.cellForItem(at: indexPath) as? MyCell else {
//                return
//            }
//
//            let section = indexPath.section
//            let item = cell.label.text ?? ""
//
//            if var cellsInSection = selectedCell[section] {
//                if let indexToRemove = cellsInSection.firstIndex(of: item) {
//                    // Удаляем элемент из массива, если он уже был выбран
//                    cellsInSection.remove(at: indexToRemove)
//                } else {
//                    // Добавляем элемент в массив, если он еще не был выбран
//                    cellsInSection.append(item)
//                }
//                if cellsInSection.isEmpty {
//                    selectedCell[section] = nil
//                } else {
//                    selectedCell[section] = cellsInSection
//                }
//            } else {
//                // Если ключ секции отсутствует в словаре, создаем новый массив и добавляем элемент
//                selectedCell[section] = [item]
//            }
//
//        if !isFixedProducts {
//            rangeSlider.isEnabled = true
//            filterProducts = filterProductsUniversal(products: allProducts, color: selectedCell[0], brand: selectedCell[1], material: selectedCell[2], season: selectedCell[3])
//        } else {
//            fixedPriceFilterProducts = filterProductsUniversal(products: allProducts, color: selectedCell[0], brand: selectedCell[1], material: selectedCell[2], season: selectedCell[3], minPrice: Int(rangeSlider.lowerValue), maxPrice: Int(rangeSlider.upperValue))
//        }
//
//        // уходим от анимированного изменения цвета
//        UIView.performWithoutAnimation {
//               collectionView.reloadItems(at: [indexPath])
//           }
//
//        print("didSelectItemAt - \(selectedCell)")
//    }
//
//    // conserva
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////
////        isForcedPrice = false
////        isTouchUpInside = false
////
////        if selectedStates[indexPath] == true {
////                    selectedStates[indexPath] = false
////                } else {
////                    selectedStates[indexPath] = true
////                }
////
////        guard let cell = collectionView.cellForItem(at: indexPath) as? MyCell else {
////                return
////            }
////
////            let section = indexPath.section
////            let item = cell.label.text ?? ""
////
////            if var cellsInSection = selectedCell[section] {
////                if let indexToRemove = cellsInSection.firstIndex(of: item) {
////                    // Удаляем элемент из массива, если он уже был выбран
////                    cellsInSection.remove(at: indexToRemove)
////                } else {
////                    // Добавляем элемент в массив, если он еще не был выбран
////                    cellsInSection.append(item)
////                }
////                if cellsInSection.isEmpty {
////                    selectedCell[section] = nil
////                } else {
////                    selectedCell[section] = cellsInSection
////                }
////            } else {
////                // Если ключ секции отсутствует в словаре, создаем новый массив и добавляем элемент
////                selectedCell[section] = [item]
////            }
//////        print("didSelectItemAt lowerValue - \(rangeSlider.lowerValue)")
//////        print("didSelectItemAt upperValue - \(rangeSlider.upperValue)")
//////        , minPrice: Int(rangeSlider.lowerValue), maxPrice: Int(rangeSlider.upperValue)
////        filterProducts = filterProductsUniversal(products: allProducts, color: selectedCell[0], brand: selectedCell[1], material: selectedCell[2], season: selectedCell[3])
////
////        // уходим от анимированного изменения цвета
////        UIView.performWithoutAnimation {
////               collectionView.reloadItems(at: [indexPath])
////           }
////
////        print("didSelectItemAt - \(selectedCell)")
////    }
//
//    // MARK: - UICollectionViewDelegateFlowLayout
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        var labelSize = CGSize()
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCell
//
//        switch indexPath.section {
//        case 0:
//            let colors = dataSource["color"]
//            cell?.label.text = colors?[indexPath.row]
////            cell?.label.text = colors[indexPath.row]
//            //             Определяем размеры метки с помощью метода sizeThatFits()
//            labelSize = cell?.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
//            labelSize = CGSize(width: labelSize.width + 20, height: labelSize.height + 20)
//        case 1:
//            let brands = dataSource["brand"]
//            cell?.label.text = brands?[indexPath.row]
////            cell?.label.text = brands[indexPath.row]
//            //             Определяем размеры метки с помощью метода sizeThatFits()
//            labelSize = cell?.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
//            labelSize = CGSize(width: labelSize.width + 20, height: labelSize.height + 20)
//        case 2:
//            let material = dataSource["material"]
//            cell?.label.text = material?[indexPath.row]
////            cell?.label.text = material[indexPath.row]
//            //             Определяем размеры метки с помощью метода sizeThatFits()
//            labelSize = cell?.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
//            labelSize = CGSize(width: labelSize.width + 20, height: labelSize.height + 20)
//        case 3:
//            let season = dataSource["season"]
//            cell?.label.text = season?[indexPath.row]
////            cell?.label.text = season[indexPath.row]
//            //             Определяем размеры метки с помощью метода sizeThatFits()
//            labelSize = cell?.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
//            labelSize = CGSize(width: labelSize.width + 20, height: labelSize.height + 20)
//        default:
//            print("Returned message for analytic FB Crashlytics error")
//            labelSize = .zero
//        }
//        return labelSize
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        if kind == UICollectionView.elementKindSectionHeader {
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderFilterCollectionReusableView.headerIdentifier, for: indexPath) as! HeaderFilterCollectionReusableView
//
//            // Customize your header view here based on the section index
//            switch indexPath.section {
//            case 0:
//                headerView.configureCell(title: "Color")
//            case 1:
//                headerView.configureCell(title: "Brand")
//            case 2:
//                headerView.configureCell(title: "Material")
//            case 3:
//                headerView.configureCell(title: "Season")
//            default:
//                break
//            }
//
//            return headerView
//        }
//        fatalError("Unexpected element kind")
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        let headerView = HeaderFilterCollectionReusableView()
//        headerView.configureCell(title: "Test")
//        let width = collectionView.bounds.width
//        let height = headerView.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)).height
//
//        return CGSize(width: width, height: height)
//    }
//}
//
//extension CustomRangeViewController: CustomTabBarViewDelegate {
//    func customTabBarViewDidTapButton(_ tabBarView: CustomTabBarView) {
//        // Ваш код обработки нажатия на кнопку
//        print("customTabBarViewDidTapButton")
//    }
//}
//
//
//
//
