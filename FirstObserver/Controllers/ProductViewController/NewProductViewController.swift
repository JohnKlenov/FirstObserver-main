//
//  NewProductViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 24.02.23.
//

import Foundation
import MapKit
import UIKit
import SPAlert

class NewProductViewController: ParentNetworkViewController {
    
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    var imageProductCollectionView : UICollectionView!
    
    let pagesView: NumberPagesView = {
        let view = NumberPagesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()

    let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.translatesAutoresizingMaskIntoConstraints = false
//        control.isUserInteractionEnabled = false
        control.currentPageIndicatorTintColor = R.Colors.label
        control.pageIndicatorTintColor = R.Colors.systemGray
//        control.backgroundColor = .orange
        control.addTarget(self, action: #selector(didTapPageControl(_:)), for: .valueChanged)
        return control
    }()
    
    let stackViewForButton: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5
        return stack
    }()
    
    let stackViewForLabel: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 10
        return stack
    }()
    
    let stackViewForDescription: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 10
        return stack
    }()
    
    let stackViewForStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        return stack
    }()
    
    let addToCardButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = R.Colors.systemPurple
        configuration.imagePlacement = .trailing
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .large)
        var grayButton = UIButton(configuration: configuration)
        
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        grayButton.addTarget(self, action: #selector(addToCardPressed(_:)), for: .touchUpInside)
        
        return grayButton
    }()
    
    let websiteButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 15)
        container.foregroundColor = R.Colors.label
        
        configuration.attributedTitle = AttributedString(R.Strings.OtherControllers.Product.websiteButton, attributes: container)
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = R.Colors.systemPurple

        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        
        grayButton.addTarget(self, action: #selector(websiteButtonPressed(_:)), for: .touchUpInside)
        
        return grayButton
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Naike Air"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = R.Colors.label
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "450 BYN"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = R.Colors.label
        return label
    }()
    
    let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = R.Strings.OtherControllers.Product.descriptionTitleLabel
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = R.Colors.label
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = R.Colors.label
        return label
    }()
    
    let titleTableViewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = R.Strings.OtherControllers.Product.titleTableViewLabel
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = R.Colors.label
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = R.Colors.systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let titleMapLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = R.Strings.OtherControllers.Product.titleMapLabel
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = R.Colors.label
        return label
    }()
    
    let mapView: CustomMapView = {
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
    

    // MARK: - Constraint property -
    var heightCnstrTableView: NSLayoutConstraint!
    
    
    
    // MARK: - model property -
    var productModel:PopularProduct?
    var arrayPin:[PlacesTest] = []
    var isAddedToCard = false {
        didSet {
            addToCardButton.setNeedsUpdateConfiguration()
        }
    }
    
    private let encoder = JSONEncoder()
    let managerFB = FBManager.shared
    private var isMapSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = R.Colors.systemBackground
        tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
        
        configureToCardButton()
        setupScrollView()
        setupCollectionView()
        setupStackView()
        setupTableView()
        setupSubviews()
        setupConstraints()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // refactor getCartObservser
//        managerFB.removeObserverForCartProductsUser()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightTV:CGFloat = CGFloat(arrayPin.count)*50
        heightCnstrTableView.constant = heightTV
    }
    
    
    
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let fullScreenMap = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            fullScreenMap.modalPresentationStyle = .fullScreen
            fullScreenMap.arrayPin = arrayPin
            present(fullScreenMap, animated: true, completion: nil)
        }
    }
    
    
    private func configureToCardButton() {
        
        addToCardButton.configurationUpdateHandler = { [weak self] button in
            
            guard let isAddedToCard = self?.isAddedToCard else {return}
            var config = button.configuration
            var container = AttributeContainer()
            container.font = UIFont.boldSystemFont(ofSize: 15)
            container.foregroundColor = R.Colors.label
            
            config?.attributedTitle = isAddedToCard ? AttributedString(R.Strings.OtherControllers.Product.addedToCardButton, attributes: container) : AttributedString(R.Strings.OtherControllers.Product.addToCardButton, attributes: container)
            config?.image = isAddedToCard ? UIImage(systemName: R.Strings.OtherControllers.Product.imageSystemNameCartFill)?.withTintColor(R.Colors.label, renderingMode: .alwaysOriginal) : UIImage(systemName: R.Strings.OtherControllers.Product.imageSystemNameCart)?.withTintColor(R.Colors.label, renderingMode: .alwaysOriginal)
            
            button.isEnabled = !isAddedToCard
            button.configuration = config
        }
    }
    private func configureViews() {
        nameLabel.text = productModel?.model
        priceLabel.text = productModel?.price
        descriptionLabel.text = productModel?.description
        pageControl.numberOfPages = productModel?.refArray.count ?? 1
        pagesView.configureView(currentPage: 1, count: productModel?.refArray.count ?? 0)
        mapView.arrayPin = arrayPin
        mapView.delegateMap = self
        mapTapGestureRecognizer.addTarget(self, action: #selector(didTapRecognizer(_:)))
        mapView.addGestureRecognizer(mapTapGestureRecognizer)
    }
    
    private func saveProductFB() {
        
        guard let product = productModel else { return }
        
        let productEncode = AddedProduct(product: product)
        
        do {
            let data = try encoder.encode(productEncode)
            let json = try JSONSerialization.jsonObject(with: data)
            managerFB.addProductInBaseData(nameProduct: product.model, json: json)
            configureBadgeValue()
        } catch {
            print("an error occured", error)
        }
    }
    
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyTableViewCell")
        tableView.register(MallTableViewCell.self, forCellReuseIdentifier: MallTableViewCell.reuseID)
        
        heightCnstrTableView = tableView.heightAnchor.constraint(equalToConstant: 50)
        heightCnstrTableView.isActive = true
    }
    
    private func setupScrollView() {
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .horizontal
        imageProductCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        imageProductCollectionView.delegate = self
        imageProductCollectionView.dataSource = self
        imageProductCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageProductCollectionView.register(NewImageProductCell.self, forCellWithReuseIdentifier: NewImageProductCell.reuseID)

        imageProductCollectionView.backgroundColor = .clear
        imageProductCollectionView.isPagingEnabled = true
        imageProductCollectionView.showsVerticalScrollIndicator = false
        imageProductCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupStackView() {

        stackViewForLabel.addArrangedSubview(nameLabel)
        stackViewForLabel.addArrangedSubview(priceLabel)
        stackViewForButton.addArrangedSubview(websiteButton)
        stackViewForButton.addArrangedSubview(addToCardButton)
        stackViewForDescription.addArrangedSubview(descriptionTitleLabel)
        stackViewForDescription.addArrangedSubview(descriptionLabel)
        
        stackViewForStackView.addArrangedSubview(stackViewForLabel)
        stackViewForStackView.addArrangedSubview(stackViewForButton)
        stackViewForStackView.addArrangedSubview(stackViewForDescription)
    }
    
    private func setupSubviews() {
        
        
        containerView.addSubview(imageProductCollectionView)
        containerView.addSubview(pageControl)
        containerView.addSubview(stackViewForStackView)
        containerView.addSubview(titleTableViewLabel)
        containerView.addSubview(tableView)
        containerView.addSubview(titleMapLabel)
        containerView.addSubview(mapView)
        containerView.addSubview(pagesView)
    }
    
    private func setupConstraints() {
        
        
        
        imageProductCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        imageProductCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        imageProductCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        imageProductCollectionView.heightAnchor.constraint(equalTo: imageProductCollectionView.widthAnchor, multiplier: 1).isActive = true
        imageProductCollectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -10).isActive = true
        
        pageControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: stackViewForStackView.topAnchor, constant: -20).isActive = true
        
        stackViewForStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        stackViewForStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        stackViewForStackView.bottomAnchor.constraint(equalTo: titleTableViewLabel.topAnchor, constant: -20).isActive = true
        
        titleTableViewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        titleTableViewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        titleTableViewLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: titleMapLabel.topAnchor, constant: -20).isActive = true
        
        titleMapLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        titleMapLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        titleMapLabel.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -10).isActive = true
        
        mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 1).isActive = true
        mapView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        
        pagesView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
//        pagesView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        pagesView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == imageProductCollectionView {
            let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            pageControl.currentPage = currentPage
            pagesView.configureView(currentPage: currentPage + 1, count: productModel?.refArray.count ?? 0)
        } else {
            print("scrolling another view")

        }
    }
    
    private func configureBadgeValue() {
        
        if let items = self.tabBarController?.tabBar.items {
            if let badgeValue = items[3].badgeValue {
                let currentCount = (Int(badgeValue) ?? 0) + 1
                items[3].badgeValue = "\(currentCount)"
            } else {
                items[3].badgeValue = "1"
            }
        }
    }
    
    @objc func addToCardPressed(_ sender: UIButton) {
        
        saveProductFB()
        let alertView = SPAlertView(title: "Product added to cart", preset: .done)
//        alertView = SPAlertView(preset: .spinner)
        alertView.layout.margins.top = 30
        alertView.layout.iconSize = .init(width: view.frame.width/4, height: view.frame.width/4)
        alertView.duration = 2
        alertView.present()
        isAddedToCard = !isAddedToCard
    }
    
    @objc func websiteButtonPressed(_ sender: UIButton) {

//        let profileVC = NewProfileViewController()
//        let nav = NavigationController(rootViewController: profileVC)
//
//        nav.modalPresentationStyle = .fullScreen
//        present(nav, animated: true, completion: nil)
        
//        signInVC.presentationController?.delegate = self
//        present(signInVC, animated: true, completion: nil)
    }
    
    @objc func didTapButtonItem() {
        print("didTapButtonItem")
    }
    
    @objc func didTapPageControl(_ sender: UIPageControl) {

        imageProductCollectionView.scrollToItem(at: IndexPath(item: sender.currentPage, section: 0), at: .centeredHorizontally, animated: true)
        pagesView.configureView(currentPage: sender.currentPage + 1, count: productModel?.refArray.count ?? 0)
//        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
//                imageProductCollectionView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    
    }
    
    deinit {
        print("Deinit NewProductViewController")
    }
    
}



// MARK: - UICollectionViewDelegate -
extension NewProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productModel?.refArray.count ?? 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewImageProductCell.reuseID, for: indexPath) as! NewImageProductCell
        guard let refImage = productModel?.refArray[indexPath.row] else { return UICollectionViewCell() }
        cell.configureCell(refImage: refImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullScreenVC = FullScreenViewController()
        fullScreenVC.productImages = productModel?.refArray ?? []
        fullScreenVC.indexPath = IndexPath(item: indexPath.row, section: 0)
        fullScreenVC.modalPresentationStyle = .fullScreen
        present(fullScreenVC, animated: true, completion: nil)
    }
}


// MARK: - -

extension NewProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPin.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: MallTableViewCell.reuseID, for: indexPath) as! MallTableViewCell
        cell.configureCell(imageMall: arrayPin[indexPath.row].image, nameMall: arrayPin[indexPath.row].title)
//        var contentCell = cell.defaultContentConfiguration()
//        contentCell.text = arrayPin[indexPath.row].title
//        contentCell.textProperties.color = R.Colors.label
//        contentCell.textProperties.font = UIFont.systemFont(ofSize: 15, weight: .regular)
//        contentCell.image = arrayPin[indexPath.row].image
//        cell.contentConfiguration = contentCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.modalPresentationStyle = .pageSheet
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        vc.nameMallLabel.text = arrayPin[indexPath.row].title
        present(vc, animated: true, completion: nil)
    }
}


// MARK: - MapViewManagerDelegate -

extension NewProductViewController: MapViewManagerDelegate {
    
    func selectAnnotationView(isSelect: Bool) {
        isMapSelected = isSelect
    }
}








