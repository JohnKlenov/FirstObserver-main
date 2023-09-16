//
//  CustomRangeViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 15.09.23.
//

import Foundation
import UIKit


//protocol CustomTabBarViewDelegate: AnyObject {
//    func customTabBarViewDidTapButton(_ tabBarView: CustomTabBarView)
//}
//
//class CustomRangeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    var dataSource = [String:[String]]() {
//        didSet {
//            collectionView.reloadData()
//        }
//    }
//
//    var dataSourceFetch = [String:[String]]()
//
//    let colors2 = ["Red", "Blue", "Green", "Black", "White", "Purpure", "Yellow", "Pink"]
//    let brands2 = ["Nike", "Adidas", "Puma", "Reebok", "QuikSilver", "Boss", "LCWKK", "Marko", "BMW", "Copertiller"]
//    let material2 = ["leather", "artificial material","Nike", "Adidas", "Puma", "Reebok", "QuikSilver", "Boss", "LCWKK", "Marko", "BMW", "Copertiller","Nike", "Adidas", "Puma", "Reebok", "QuikSilver", "Boss", "LCWKK", "Marko", "BMW", "Copertiller"]
//    let season2 = ["summer", "winter", "demi-season","Nike", "Adidas", "Puma", "Reebok", "QuikSilver", "Boss", "LCWKK", "Marko", "BMW", "Copertiller","Nike", "Adidas", "Puma", "Reebok", "QuikSilver", "Boss", "LCWKK", "Marko", "BMW", "Copertiller"]
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
//        configureRangeView(minimumValue: 135, maximumValue: 745)
//        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(rangeSlider:)), for: .valueChanged)
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
////        print("First Start")
//        rangeView.updateLabels(lowerValue: rangeSlider.lowerValue, upperValue: rangeSlider.upperValue)
////        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
//    }
//
//    @objc func didTapCloseButton() {
//        print("didTapCloseButton")
//    }
//
//    @objc func didTapResetButton() {
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
//
////        rangeView.updateLabels(lowerValue: minimumValue, upperValue: maximumValue)
//        rangeSlider.minimumValue = minimumValue
//        rangeSlider.maximumValue = maximumValue
//        rangeSlider.lowerValue = minimumValue
//        rangeSlider.upperValue = maximumValue
//    }
//
//    private func testFetchData() {
//        dataSourceFetch["colors"] = colors2
//        dataSourceFetch["brands"] = brands2
//        dataSourceFetch["material"] = material2
//        dataSourceFetch["season"] = season2
//        dataSource = dataSourceFetch
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
//            return dataSource["colors"]?.count ?? 0
////            return colors.count
//        case 1:
//            return dataSource["brands"]?.count ?? 0
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
//        switch indexPath.section {
//        case 0:
//            let colors = dataSource["colors"]
//            cell.label.text = colors?[indexPath.row]
////            cell.label.text = colors[indexPath.row]
//        case 1:
//            let brands = dataSource["brands"]
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
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        self.dismiss(animated: true, completion: nil)
//        configureRangeView(minimumValue: 356, maximumValue: 934)
//        testFetchData()
//    }
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
//            let colors = dataSource["colors"]
//            cell?.label.text = colors?[indexPath.row]
////            cell?.label.text = colors[indexPath.row]
//            //             Определяем размеры метки с помощью метода sizeThatFits()
//            labelSize = cell?.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
//            labelSize = CGSize(width: labelSize.width + 20, height: labelSize.height + 20)
//        case 1:
//            let brands = dataSource["brands"]
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
//                headerView.configureCell(title: "Colors")
//            case 1:
//                headerView.configureCell(title: "Brands")
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
//        configButton.title = "Done"
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
//    @objc func didTapDoneButton() {
//        delegate?.customTabBarViewDidTapButton(self)
//        print("didTapDoneButton")
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
//


//class ViewController: UIViewController {
//
//    var dataSource = [String:[String]]()
//    let customRangeButton: UIButton = {
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
//        configuration.attributedTitle = AttributedString("CustomRangeVC", attributes: container)
//
//        var grayButton = UIButton(configuration: configuration)
//        grayButton.translatesAutoresizingMaskIntoConstraints = false
//        grayButton.addTarget(self, action: #selector(addCustomRangeButton(_:)), for: .touchUpInside)
//
//        return grayButton
//    }()
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
//        let colors = ["Red", "Blue", "Green", "Black", "White", "Purpure", "Yellow", "Pink"]
//        let brands = ["Nike", "Adidas", "Puma", "Reebok", "QuikSilver", "Boss", "LCWKK", "Marko", "BMW", "Copertiller"]
//        let material = ["leather", "artificial material"]
//        let season = ["summer", "winter", "demi-season"]
//        dataSource["colors"] = colors
//        dataSource["brands"] = brands
//        dataSource["material"] = material
//        dataSource["season"] = season
//        let customVC = CustomRangeViewController()
//        customVC.dataSource = dataSource
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
