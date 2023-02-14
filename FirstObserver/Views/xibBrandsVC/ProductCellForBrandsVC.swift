//
//  ProductCellForBrandsVC.swift
//  FirstObserver
//
//  Created by Evgenyi on 14.02.23.
//

import UIKit

protocol ProductCellDelegtate: AnyObject {
    func giveModel(model: PopularProduct)
}

class ProductCellForBrandsVC: UICollectionViewCell {
    
    static var reuseID = "ProductCellForBrandsVC"
    
    private var collectionViewLayout:UICollectionView!
    private var product = [PopularProduct]()
    weak var delegate: ProductCellDelegtate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        collectionViewLayout.dataSource = self
        collectionViewLayout.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        
        collectionViewLayout = UICollectionView(frame: contentView.bounds, collectionViewLayout: createLayout())
        collectionViewLayout.translatesAutoresizingMaskIntoConstraints = false
        collectionViewLayout.backgroundColor = .clear
        contentView.addSubview(collectionViewLayout)
        setupConstraints()
        collectionViewLayout.register(ProductCellForProductCell.self, forCellWithReuseIdentifier: ProductCellForProductCell.reuseID)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            return self.productSection()
        }
    return layout
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
        return section
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([collectionViewLayout.topAnchor.constraint(equalTo: contentView.topAnchor), collectionViewLayout.trailingAnchor.constraint(equalTo: contentView.trailingAnchor), collectionViewLayout.leadingAnchor.constraint(equalTo: contentView.leadingAnchor), collectionViewLayout.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    
    func setupCell(product: [PopularProduct]) {
        self.product = product
        self.collectionViewLayout.reloadData()
    }
}

extension ProductCellForBrandsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCellForProductCell", for: indexPath) as! ProductCellForProductCell
        let product = product[indexPath.item]
        cell.configureCell(model: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let product = product[indexPath.item]
                delegate?.giveModel(model: product)
    }
    
}
