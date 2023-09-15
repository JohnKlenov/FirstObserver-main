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
//    
//    let colors = ["Red", "Blue", "Green", "Black", "White", "Purpure", "Yellow", "Pink"]
//    let brands = ["Nike", "Adidas", "Puma", "Reebok", "QuikSilver", "Boss", "LCWKK", "Marko", "BMW", "Copertiller"]
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
//        configButton.baseForegroundColor = .black
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
//        configButton.baseForegroundColor = .black
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
//        view.backgroundColor = .systemPink
////        navigationController?.navigationBar.backgroundColor = .systemGray
//        
//        // Установка делегатов и источника данных UICollectionView
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        customTabBarView.delegate = self
//        collectionView.backgroundColor = .systemGray6
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
//        
//        configureNavigationItem()
//        configureRangeView(minimumValue: 135, maximumValue: 745)
//        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(rangeSlider:)), for: .valueChanged)
//
//        // Установка ограничений для UICollectionView чтобы его размер был равен размеру его ячеек
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: rangeSlider.bottomAnchor, constant: 10),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//        
//        NSLayoutConstraint.activate([
//            customTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            customTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            // Прилипание к нижнему краю экрана
//            customTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
////            customTabBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
//    }
//    
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        rangeView.frame = CGRect(x: 0, y: navigationController?.navigationBar.frame.maxY ?? 0, width: UIScreen.main.bounds.width, height: 90)
//        rangeSlider.frame = CGRect(x: 10, y: rangeView.frame.maxY, width: UIScreen.main.bounds.width - 20, height: 30)
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
//    // MARK: - UICollectionViewDataSource
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return colors.count
//        } else {
//            return brands.count
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCell else {
//            return UICollectionViewCell()
//        }
//        if indexPath.section == 0 {
//            cell.label.text = colors[indexPath.row]
//        } else {
//            cell.label.text = brands[indexPath.row]
//        }
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        self.dismiss(animated: true, completion: nil)
//        configureRangeView(minimumValue: 356, maximumValue: 934)
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
//            cell?.label.text = colors[indexPath.row]
//            //             Определяем размеры метки с помощью метода sizeThatFits()
//            labelSize = cell?.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
//            labelSize = CGSize(width: labelSize.width + 10, height: labelSize.height + 10)
//        case 1:
//            cell?.label.text = brands[indexPath.row]
//            //             Определяем размеры метки с помощью метода sizeThatFits()
//            labelSize = cell?.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
//            labelSize = CGSize(width: labelSize.width + 10, height: labelSize.height + 10)
//        default:
//            labelSize = .zero
//        }
//
//        return labelSize
//    }
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
//        label.font = UIFont.systemFont(ofSize: 20)
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        // Добавление метки на ячейку и установка ограничений для ее размера
//        contentView.backgroundColor = .systemGray
//        contentView.addSubview(label)
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
//            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 0),
//            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
//            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
//        ])
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.black.cgColor
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
//    
//    let label:UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        label.backgroundColor = .clear
//        label.tintColor = .black
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(label)
//        setupConstraints()
//        backgroundColor = .systemPurple
//    }
//   
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: topAnchor, constant: 5), label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5), label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10), label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)])
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
//        backgroundColor = .white
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
//        configButton.baseForegroundColor = .black
//        configButton.buttonSize = .large
//        configButton.baseBackgroundColor = .systemPink
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
//        backgroundColor = .systemGray4
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
//        view.textAlignment = .center
//        return view
//    }()
//    
//    let toLabel: UILabel = {
//        let view = UILabel()
//        view.textAlignment = .center
//        return view
//    }()
//
//    let titleLabel: UILabel = {
//        let view = UILabel()
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
//        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        addSubview(titleLabel)
//
//        // Левый UILabel в одном ряду со сверху лежащим UILabel
//        fromLabel.frame = CGRect(x: 10, y: titleLabel.frame.maxY + 10, width: 60, height: 30)
////        fromLabel.text = "238"
//        fromLabel.backgroundColor = .systemGray3
//        fromLabel.layer.cornerRadius = 5
//        fromLabel.clipsToBounds = true
//        addSubview(fromLabel)
//
//        // Правый UILabel в одном ряду со сверху лежащим UILabel и прижатый к правому краю
//        toLabel.frame = CGRect(x: frame.width - 70, y: titleLabel.frame.maxY + 10, width: 60, height: 30)
////        toLabel.text = "765"
//        toLabel.backgroundColor = .systemGray3
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
