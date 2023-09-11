//
//  PriceRangeView.swift
//  FirstObserver
//
//  Created by Evgenyi on 10.09.23.
//
import UIKit

import UIKit

class FiltersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

//    private let titles = [
//        "cersei",
//        "daenerys the stormborn",
//        "lannister",
//        "snow the bastard",
//        "stark",
//        "baratheon",
//        "tyrion the dworf"
//    ]
    
    let colors = ["Red", "Blue", "Green", "Black", "White", "Purpure", "Yellow", "Pink"]
    let brands = ["Nike", "Adidas", "Puma", "Reebok", "QuikSilver", "Boss", "LCWKK", "Marko", "BMW", "Copertiller"]

    private let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
        let layout = UserProfileTagsFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Установка делегатов и источника данных UICollectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemGray6

        // Регистрация класса ячейки UICollectionViewCell для использования в коллекции
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(HeaderFilterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderFilterCollectionReusableView.headerIdentifier)
//        collectionView.register(FooterFilterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterFilterCollectionReusableView.headerIdentifier)
        // Добавление UICollectionView на экран
        view.addSubview(collectionView)

        // Установка ограничений для UICollectionView чтобы его размер был равен размеру его ячеек
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return colors.count
        } else {
            return brands.count
        }
//        return titles.count // Здесь указываете количество ячеек, которые хотите отобразить
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCell else {
            return UICollectionViewCell()
        }
        if indexPath.section == 0 {
            cell.label.text = colors[indexPath.row]
        } else {
            cell.label.text = brands[indexPath.row]
        }

        // Настройка метки в ячейке
//        cell.label.text = titles[indexPath.row]

        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let labelSize = CGSize(width: 100, height: 50) // Здесь устанавливаете размер метки
        //        return labelSize
        var labelSize = CGSize()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCell else { fatalError("Unable to dequeue MyCell") }
        
        if indexPath.section == 0 {
            cell.label.text = colors[indexPath.row]
            //             Определяем размеры метки с помощью метода sizeThatFits()
            labelSize = cell.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            labelSize = CGSize(width: labelSize.width + 10, height: labelSize.height + 10)
        } else {
            cell.label.text = brands[indexPath.row]
            //             Определяем размеры метки с помощью метода sizeThatFits()
            labelSize = cell.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            labelSize = CGSize(width: labelSize.width + 10, height: labelSize.height + 10)
        }
        
        return labelSize
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderFilterCollectionReusableView.headerIdentifier, for: indexPath) as! HeaderFilterCollectionReusableView

            // Customize your header view here based on the section index
            switch indexPath.section {
            case 0:
                headerView.configureCell(title: "Colors")
            case 1:
                headerView.configureCell(title: "Brands")
            default:
                break
            }

            return headerView
        }
        
//        if kind == UICollectionView.elementKindSectionFooter {
//            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterFilterCollectionReusableView.headerIdentifier, for: indexPath) as! FooterFilterCollectionReusableView
//            if indexPath.section == 1 {
//                footerView.configureCell(title: "Footer")
//            }
//        }
        
        fatalError("Unexpected element kind")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let headerView = HeaderFilterCollectionReusableView()
        headerView.configureCell(title: "Test")
        let width = collectionView.bounds.width
        let height = headerView.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)).height
        
        return CGSize(width: width, height: height)
        //            return CGSize(width: collectionView.bounds.width, height: 50)
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//
//        let footerView = FooterFilterCollectionReusableView()
//        footerView.configureCell(title: "Test")
//        let width = collectionView.bounds.width
//        let height = footerView.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)).height
//
//        return CGSize(width: width, height: height)
//        //            return CGSize(width: collectionView.bounds.width, height: 50)
//    }

}

class MyCell: UICollectionViewCell {

    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Добавление метки на ячейку и установка ограничений для ее размера
//        contentView.backgroundColor = .green
        contentView.backgroundColor = .systemGray
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 0),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 5
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class UserProfileTagsFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesForElementsInRect = super.layoutAttributesForElements(in: rect) else { return nil }
        guard var newAttributesForElementsInRect = NSArray(array: attributesForElementsInRect, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }

        var leftMargin: CGFloat = 0.0;

        for attributes in attributesForElementsInRect {
            if (attributes.frame.origin.x == self.sectionInset.left) {
                leftMargin = self.sectionInset.left
            }
            else {
                var newLeftAlignedFrame = attributes.frame
                newLeftAlignedFrame.origin.x = leftMargin
                attributes.frame = newLeftAlignedFrame
            }
            leftMargin += attributes.frame.size.width + 8 // Makes the space between cells
            newAttributesForElementsInRect.append(attributes)
        }

        return newAttributesForElementsInRect
    }
}



protocol HeaderFilterCollectionViewDelegate: AnyObject {
    func didSelectSegmentControl()
}

class HeaderFilterCollectionReusableView: UICollectionReusableView {
    
    static let headerIdentifier = "HeaderFilterVC"
    weak var delegate: HeaderFilterCollectionViewDelegate?
    
    let label:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.backgroundColor = .clear
        label.tintColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        setupConstraints()
        backgroundColor = .systemPurple
    }
   
    private func setupConstraints() {
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: topAnchor, constant: 5), label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5), label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0), label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)])
    }
    
    func configureCell(title: String) {
        label.text = title
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(label)
        setupConstraints()
        backgroundColor = .white
//        fatalError("init(coder:) has not been implemented")
    }
        
}

class FooterFilterCollectionReusableView: UICollectionReusableView {
    
    static let headerIdentifier = "FooterFilterVC"
    
    
    let label:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.backgroundColor = .clear
        label.tintColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        setupConstraints()
        backgroundColor = .systemPurple
    }
   
    private func setupConstraints() {
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: topAnchor, constant: 5), label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5), label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0), label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)])
    }
    
    func configureCell(title: String) {
        label.text = title
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(label)
        setupConstraints()
        backgroundColor = .white
//        fatalError("init(coder:) has not been implemented")
    }
        
}




class PriceRangeView: UIView {
    private let slider = UISlider()
    private let fromLabel = UILabel()
    private let toLabel = UILabel()

    var minimumPrice: Float {
        return slider.value
    }

    var maximumPrice: Float {
        return slider.value
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSlider()
        setupLabels()

        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSlider() {
        // Set the range of the slider
        slider.minimumValue = 0.0
        slider.maximumValue = 100.0

        // Add lower and upper track tint colors to indicate the selected range
        slider.tintColor = UIColor.blue.withAlphaComponent(0.5)

        addSubview(slider)

        // Add constraints to position the slider within the view
        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor),
            slider.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        // Adjust the appearance of the thumb and track for better usability
        slider.setThumbImage(UIImage(named: "slider_thumb"), for: .normal)
        slider.setThumbImage(UIImage(named: "slider_thumb_highlighted"), for: .highlighted)

        // Customize the track colors if desired
//         let trackRect = CGRect(x: 0, y: 0, width: 10, height: 2)
//         let upperTrackColorView = UIView(frame: trackRect)
//         upperTrackColorView.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
//         slider.addSubview(upperTrackColorView)
//         slider.sendSubviewToBack(upperTrackColorView)

    }

    private func setupLabels() {
        fromLabel.textAlignment = .left
        toLabel.textAlignment = .right

        addSubview(fromLabel)
        addSubview(toLabel)

        // Add constraints to position the labels above the slider
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fromLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            fromLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            fromLabel.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -8)
        ])

        toLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            toLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            toLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 8)
        ])

        updateLabels()
    }

    @objc private func sliderValueChanged() {
        updateLabels()
    }

    private func updateLabels() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

      let minimumValueString = formatter.string(from: NSNumber(value: minimumPrice))
      let maximumValueString = formatter.string(from: NSNumber(value: maximumPrice))

      fromLabel.text = "From \(minimumValueString ?? "")"
      toLabel.text = "To \(maximumValueString ?? "")"
    }
}

//```
//
//You can then use this custom `PriceRangeView` in your view controller's code:
//
//```swift
//let priceRangeView = PriceRangeView(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
//view.addSubview(priceRangeView)
//
//// Adjust constraints or frame as needed
//
//// Access selected price range values
//let minimumPrice = priceRangeView.minimumPrice
//let maximumPrice = priceRangeView.maximumPrice
//
//// Use the selected values as needed, such as filtering products based on the price range
//```
//
//Make sure to customize the appearance and behavior according to your needs.



//swift
//import UIKit
//
//class PriceRangeView: UIView {
//
//    private let minimumLabel = UILabel()
//    private let maximumLabel = UILabel()
//    private let slider = UISlider()
//
//    var minimumPrice: Float {
//        return round(slider.minimumValue * 100) / 100
//    }
//
//    var maximumPrice: Float {
//        return round(slider.maximumValue * 100) / 100
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        setupUI()
//        addSubviews()
//        setupConstraints()
//
//        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
//        updateLabels()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    @objc private func sliderValueChanged() {
//        updateLabels()
//    }
//
//    private func setupUI() {
//        // Customize the appearance of the labels and slider as needed
//
//        minimumLabel.textAlignment = .center
//        maximumLabel.textAlignment = .center
//
//        slider.minimumValue = 0.0
//        slider.maximumValue = 100.0
//    }
//
//    private func addSubviews() {
//        addSubview(minimumLabel)
//        addSubview(maximumLabel)
//        addSubview(slider)
//    }
//
//    private func setupConstraints() {
//      // Add constraints to position and size the labels and slider within the view
//
//      // For example:
//      minimumLabel.translatesAutoresizingMaskIntoConstraints = false
//      minimumLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//      minimumLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
//
//      maximumLabel.translatesAutoresizingMaskIntoConstraints = false
//      maximumLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//      maximumLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
//
//      slider.translatesAutoresizingMaskIntoConstraints = false
//      slider.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//      slider.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//      slider.topAnchor.constraint(equalTo: minimumLabel.bottomAnchor, constant: 8.0).isActive = true
//    }
//
//    private func updateLabels() {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//
//        let minimumPriceString = formatter.string(from: NSNumber(value: minimumPrice))
//        let maximumPriceString = formatter.string(from: NSNumber(value: maximumPrice))
//
//        minimumLabel.text = minimumPriceString
//        maximumLabel.text = maximumPriceString
//
//        // Use the selected values as needed, such as filtering products based on the price range
//
//        // Update any other UI elements that display the selected price range
//    }
//}
//
//
//Вы можете использовать данный пользовательский класс PriceRangeView в вашем контроллере:
//
//swift
//let priceRangeView = PriceRangeView(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
//view.addSubview(priceRangeView)
//
//// Adjust constraints or frame as needed
//
//// Access selected price range values
//let minimumPrice = priceRangeView.minimumPrice
//let maximumPrice = priceRangeView.maximumPrice
//
//// Use the selected values as needed, such as filtering products based on the price range
//
//
//Не забудьте настроить внешний вид и поведение слайдера в соответствии с вашими потребностями.



// Устанавливаем текст для метки
//            cell.label.text = titles[indexPath.row] // Замените этот текст на свой реальный текст
//
//            // Определяем размеры метки с помощью метода sizeThatFits()
//            labelSize = cell.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))



//        let tag = titles[indexPath.row]
//        let font = UIFont.systemFont(ofSize: 20)//UIFont(name: "Label Test Data", size: 16)!
//        let size = tag.size(withAttributes: [NSAttributedString.Key.font: font])
//        let dynamicCellWidth = size.width




// MARK: - -

//class FiltersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//
//    // Define your colors and brands arrays here
//    let colors = ["Red", "Blue", "Green", "Black", "White"]
//    let brands = ["Nike", "Adidas", "Puma", "Reebok"]
//
//    var selectedColors: [UIColor] = []
//    var selectedBrands: [String] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupCollectionView()
//        setupNavigationBar()
//    }
//
//    func setupCollectionView() {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//
//        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//
//        view.addSubview(collectionView)
//    }
//
//    func setupNavigationBar() {
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
//
//        navigationItem.rightBarButtonItem = doneButton
//    }
//
//    // MARK: - Collection View Delegate & Data Source
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
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//
//        if indexPath.section == 0 {   // Colors section
//            let color = UIColor(named: colors[indexPath.item])!
//
//            cell.backgroundColor = color
//
//            if selectedColors.contains(color) {
//                cell.contentView.layer.borderWidth = 5.0
//                cell.contentView.layer.borderColor = UIColor.green.cgColor
//            } else {
//                cell.contentView.layer.borderWidth = 0.0
//                cell.contentView.layer.borderColor = UIColor.clear.cgColor
//            }
//
//        } else {   // Brands section
//            let brand = brands[indexPath.item]
//
//            cell.backgroundColor = .white
//
//            if selectedBrands.contains(brand) {
//                cell.contentView.layer.borderWidth = 5.0
//                cell.contentView.layer.borderColor = UIColor.green.cgColor
//            } else {
//                cell.contentView.layer.borderWidth = 0.0
//                cell.contentView.layer.borderColor = UIColor.clear.cgColor
//            }
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedCell = collectionView.cellForItem(at: indexPath)
//
//        if indexPath.section == 0 {   // Colors section
//            let color = UIColor(named: colors[indexPath.item])!
//
//            if selectedColors.contains(color) {
//                selectedColors.removeAll { $0 == color }
//                selectedCell?.contentView.layer.borderWidth = 0.0
//
//            } else {
//                selectedColors.append(color)
//                selectedCell?.contentView.layer.borderWidth = 5.0
//                selectedCell?.contentView.layer.borderColor = UIColor.green.cgColor
//            }
//
//        } else {   // Brands section
//
//            let brand = brands[indexPath.item]
//
//           if  self.selectedBrands.firstIndex(of: brand) != nil{
//               self.selectedBrands.remove(at : self.selectedBrands.firstIndex(of: brand)!)
//               selectedCell?.contentView.layer.borderWidth = 0.0
//
//           }
//           else{
//               self.selectedBrands.append(brand)
//               selectedCell?.contentView.layer.borderWidth = 5.0
//               selectedCell?.contentView.layer.borderColor = UIColor.green.cgColor
//           }
//
//        }
//    }
//
//    // MARK: - Actions
//
//    @objc func didTapDone() {
//        print("Selected colors: \(selectedColors)")
//        print("Selected brands: \(selectedBrands)")
//
//        dismiss(animated: true, completion: nil)
//    }
//}

//class FilterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    let colors = ["Red", "Blue", "Green", "Black", "White"]
//    let brands = ["Nike", "Adidas", "Puma", "Reebok"]
//
//    var selectedColors: [String] = []
//    var selectedBrands: [String] = []
//
//    @IBOutlet weak var collectionView: UICollectionView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Set up collection view
//        collectionView.dataSource = self
//        collectionView.delegate = self
//
//        // Register cell classes
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "FilterCell")
//
//        // Configure collection view layout
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 10
//        layout.minimumInteritemSpacing = 10
//        collectionView.collectionViewLayout = layout
//
//        // Add done button to navigation bar
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
//        navigationItem.rightBarButtonItem = doneButton
//    }
//
//    // MARK: - Collection View Data Source
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2   // One section for colors, one section for brands
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
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath)
//
//        // Configure cell appearance
//        cell.backgroundColor = .lightGray
//
//        // Set text label based on section and row
//        if indexPath.section == 0 {
//            cell.textLabel?.text = colors[indexPath.item]
//            // Check if color is selected
//            if selectedColors.contains(colors[indexPath.item]) {
//                cell.isSelected = true
//                cell.backgroundColor = .green
//            } else {
//                cell.isSelected = false
//                cell.backgroundColor = .lightGray
//            }
//        } else {
//            cell.textLabel?.text = brands[indexPath.item]
//            // Check if brand is selected
//            if selectedBrands.contains(brands[indexPath.item]) {
//                cell.isSelected = true
//                cell.backgroundColor = .green
//            } else {
//                cell.isSelected = false
//                cell.backgroundColor = .lightGray
//            }
//        }
//
//        return cell
//    }
//
//    // MARK: - Collection View Delegate
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedCell = collectionView.cellForItem(at: indexPath)
//
//        // Update selected colors or brands based on selection
//
//        if indexPath.section == 0 {   // Colors section
//            let color = colors[indexPath.item]
//
//            if selectedColors.contains(color) {
//                // Color already selected, deselect it
//                selectedColors.removeAll { $0 == color }
//                selectedCell?.backgroundColor = .lightGray
//
//            } else {
//                // Color not selected, select it
//                selectedColors.append(color)
//                selectedCell?.backgroundColor = .green
//
//            }
//
//        } else {   // Brands section
//
//            let brand = brands[indexPath.item]
//
//           if  self.selectedBrands.firstIndex(of: brand) != nil{
//               self.selectedBrands.remove(at : self.selectedBrands.firstIndex(of: brand)!)
//               selectedCell?.backgroundColor = .lightGray
//
//           }
//            else{
//                self.selectedBrands.append(brand)
//                selectedCell?.backgroundColor = .green
//            }
//
//        }
//
//    }
//
//    // MARK: - Actions
//
//    @objc func didTapDone() {
//        // Perform filtering based on selected colors and brands
//
//        print("Selected colors: \(selectedColors)")
//        print("Selected brands: \(selectedBrands)")
//
//        // Dismiss the filters view controller
//        dismiss(animated: true, completion: nil)
//    }
//}
