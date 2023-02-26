//
//  NewProductViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 24.02.23.
//

import Foundation
import UIKit

class NewProductViewController: UIViewController {
    
    var currentPage = 1
    private let modelImage = ModelForProductVC.shared.imagesProduct()

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    var imageProductCollectionView : UICollectionView!
    
    let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.translatesAutoresizingMaskIntoConstraints = false
//        control.isUserInteractionEnabled = false
        control.currentPageIndicatorTintColor = .black
        control.pageIndicatorTintColor = .systemGray5
        control.backgroundColor = .orange
        control.addTarget(self, action: #selector(didTapPageControl(_:)), for: .touchUpInside)
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
        view.backgroundColor = .orange
        return view
    }()
    

//    weak var footerDelegate: FooterViewSectionDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupCollectionView()
        setupStackView()
        setupSubviews()
        setupConstraints()
        pageControl.numberOfPages = modelImage.count
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
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .horizontal
        imageProductCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        imageProductCollectionView.delegate = self
        imageProductCollectionView.dataSource = self
        imageProductCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageProductCollectionView.register(NewImageProductCell.self, forCellWithReuseIdentifier: NewImageProductCell.reuseID)

        imageProductCollectionView.backgroundColor = .green
        imageProductCollectionView.isPagingEnabled = true
        imageProductCollectionView.showsVerticalScrollIndicator = false
        imageProductCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupStackView() {

        stackViewForLabel.addArrangedSubview(nameLabel)
        stackViewForLabel.addArrangedSubview(priceLabel)
        stackViewForButton.addArrangedSubview(websiteButton)
        stackViewForButton.addArrangedSubview(addToCardButton)
        
        stackViewForStackView.addArrangedSubview(stackViewForLabel)
        stackViewForStackView.addArrangedSubview(stackViewForButton)
    }
    
    private func setupSubviews() {
        
        containerView.addSubview(imageProductCollectionView)
        containerView.addSubview(pageControl)
        containerView.addSubview(stackViewForStackView)
        containerView.addSubview(testView)
    }
    
    private func setupConstraints() {
        
        imageProductCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        imageProductCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        imageProductCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        imageProductCollectionView.heightAnchor.constraint(equalTo: imageProductCollectionView.widthAnchor, multiplier: 1).isActive = true
        imageProductCollectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20).isActive = true
        
        pageControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: stackViewForStackView.topAnchor, constant: 0).isActive = true
        
        stackViewForStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        stackViewForStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        stackViewForStackView.bottomAnchor.constraint(equalTo: testView.topAnchor, constant: -20).isActive = true
        
        testView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        testView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        testView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == imageProductCollectionView {
            print("scroll imageProductCollectionView")
            let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            print("currentPage - \(currentPage)")
            pageControl.currentPage = currentPage
//            footerDelegate?.currentPage(index: currentPage)
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
    
    @objc func didTapPageControl(_ sender: UIPageControl) {
//        currentPage+=sender.currentPage
//        print("changePageControl - currentPage \(sender.currentPage)")
////        print("currentPage - \(currentPage)")
//
//
//        imageProductCollectionView.scrollToItem(at: IndexPath(item: sender.currentPage+1, section: 0), at: .centeredHorizontally, animated: true)
//        if sender.currentPage == 0  {
//            imageProductCollectionView.setContentOffset(CGPoint(x:scrollView.frame.size.width, y:0), animated: true)
//        } else {
//            let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
//                    imageProductCollectionView.setContentOffset(CGPoint(x:x, y:0), animated: true)
//        }
//        print("modelImage.count \(modelImage.count)")
        let current = pageControl.currentPage
       
        print("\(current)")
        
        let x = CGFloat(current) * scrollView.frame.size.width
                imageProductCollectionView.setContentOffset(CGPoint(x:x, y:0), animated: true)
        

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
    
}





