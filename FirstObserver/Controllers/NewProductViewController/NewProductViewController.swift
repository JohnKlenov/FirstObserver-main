//
//  NewProductViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 24.02.23.
//

import Foundation
import UIKit

class NewProductViewController: UIViewController {
    
    
    private let modelImage = ModelForProductVC.shared.imagesProduct()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
//        scroll.isScrollEnabled = true
//        scroll.isUserInteractionEnabled = true
//        scroll.backgroundColor = .gray
        return scroll
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    
    var imageProductCollectionView : UICollectionView!
//    let imageProductCollectionView : UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        return collectionView
//    }()
    
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
        stack.spacing = 5
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
       
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 15)
        container.foregroundColor = UIColor.white
        
        configuration.attributedTitle = AttributedString("Flor plan", attributes: container)
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .black.withAlphaComponent(0.9)

        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        
        grayButton.addTarget(self, action: #selector(addToCardPressed(_:)), for: .touchUpInside)
        
        return grayButton
    }()
    
    let websiteButton: UIButton = {
        
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
        
        grayButton.addTarget(self, action: #selector(websiteButtonPressed(_:)), for: .touchUpInside)
        
        return grayButton
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "NameLabel"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PriceLabel"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let testView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 900).isActive = true
//        let height = view.heightAnchor.constraint(equalToConstant: 700)
//        height.priority = UILayoutPriority(999)
//        height.isActive = true
        view.backgroundColor = .orange
        return view
    }()
    
    let testView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        let height = view.heightAnchor.constraint(equalToConstant: 700)
//        height.priority = UILayoutPriority(999)
//        height.isActive = true
        view.heightAnchor.constraint(equalToConstant: 900).isActive = true
        view.backgroundColor = .green
        return view
    }()
    
    let testView3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let height = view.heightAnchor.constraint(equalToConstant: 700)
        height.priority = UILayoutPriority(999)
        height.isActive = true
        view.backgroundColor = .blue
        return view
    }()
    
    weak var footerDelegate: FooterViewSectionDelegate?
    
//    init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
//        setupCollectionView()
//        setupStackView()
        setupSubviews()
//        setupSubviews()
//        setupConstraints()
//        testView2.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        
        setupCnstr()
        
//        let topCnstr = testView2.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0)
//        topCnstr.priority = UILayoutPriority(999)
//        topCnstr.isActive = true
//        testView2.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
//        testView2.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
////        testView2.heightAnchor.constraint(equalToConstant: 700).isActive = true
//        testView2.bottomAnchor.constraint(equalTo: testView.topAnchor, constant: 0).isActive = true
//
//
//        testView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
//        testView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
////        testView.heightAnchor.constraint(equalToConstant: 950).isActive = true
////        testView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -20).isActive = true
//        let bottomCnstr = testView.bottomAnchor.constraint(equalTo: testView3.topAnchor, constant: -20)
//        bottomCnstr.priority = UILayoutPriority(999)
//        bottomCnstr.isActive = true
//
//        testView3.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
//        testView3.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
////        testView.heightAnchor.constraint(equalToConstant: 950).isActive = true
////        testView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -20).isActive = true
//        let bottomCnstr3 = testView3.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -20)
//        bottomCnstr3.priority = UILayoutPriority(999)
//        bottomCnstr3.isActive = true
    }
    
    func setupCnstr() {
        testView2.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        testView2.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        testView2.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        testView2.bottomAnchor.constraint(equalTo: testView.topAnchor, constant: 0).isActive = true
        
        testView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        testView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        testView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        
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
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
//        layout.footerReferenceSize = CGSize(width: view.frame.width, height: 30)
        layout.scrollDirection = .horizontal
        imageProductCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        imageProductCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageProductCollectionView.register(NewImageProductCell.self, forCellWithReuseIdentifier: NewImageProductCell.reuseID)
        imageProductCollectionView.register(FooterViewCollectionView.self, forSupplementaryViewOfKind: "FooterView", withReuseIdentifier: FooterViewCollectionView.footerIdentifier)
        imageProductCollectionView.delegate = self
        imageProductCollectionView.dataSource = self
        imageProductCollectionView.backgroundColor = .green
        imageProductCollectionView.isPagingEnabled = true
        imageProductCollectionView.showsVerticalScrollIndicator = false
        imageProductCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupStackView() {

//        stackViewForLabel.addArrangedSubview(nameLabel)
//        stackViewForLabel.addArrangedSubview(priceLabel)
        stackViewForButton.addArrangedSubview(websiteButton)
        stackViewForButton.addArrangedSubview(addToCardButton)
        
//        stackViewForStackView.addArrangedSubview(stackViewForLabel)
//        stackViewForStackView.addArrangedSubview(stackViewForButton)
    }
    
    private func setupSubviews() {
//        containerView.addSubview(imageProductCollectionView)
        
//        containerView.addSubview(stackViewForStackView)
        containerView.addSubview(testView2)
        containerView.addSubview(testView)
        
//        containerView.addSubview(testView3)
    }
    
    private func setupConstraints() {
        
        imageProductCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        imageProductCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        imageProductCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        imageProductCollectionView.heightAnchor.constraint(equalTo: imageProductCollectionView.widthAnchor, multiplier: 1).isActive = true
        imageProductCollectionView.bottomAnchor.constraint(equalTo: stackViewForStackView.topAnchor, constant: -20).isActive = true
        
        stackViewForStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        stackViewForStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        stackViewForStackView.bottomAnchor.constraint(equalTo: testView.topAnchor, constant: -20).isActive = true
        
        testView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        testView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        testView.heightAnchor.constraint(equalToConstant: 750).isActive = true
        testView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -20).isActive = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == imageProductCollectionView {
            print("scroll imageProductCollectionView")
            let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            footerDelegate?.currentPage(index: currentPage)
        } else {
            print("scrolling another view")

        }
    }
    
    @objc func addToCardPressed(_ sender: UIButton) {
        print("addToCardPressed")
    }
    
    @objc func websiteButtonPressed(_ sender: UIButton) {
        print("websiteButtonPressed")

    }
    
    
}



// MARK: - UICollectionViewDelegate -
extension NewProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewImageProductCell.reuseID, for: indexPath) as! NewImageProductCell
        cell.configureCell(image: modelImage[indexPath.row].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == "FooterView" {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: FooterViewCollectionView.footerIdentifier, withReuseIdentifier: FooterViewCollectionView.footerIdentifier, for: indexPath) as! FooterViewCollectionView
            print("viewForSupplementaryElementOfKind - \(indexPath.row)")
//            footerView.configure(with: <#T##Int#>)
            footerDelegate = footerView
            return footerView
        } else {
            return UICollectionReusableView()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    
}





