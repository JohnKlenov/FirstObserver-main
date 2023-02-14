//
//  ProductCellForProductCell.swift
//  FirstObserver
//
//  Created by Evgenyi on 14.02.23.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class ProductCellForProductCell: UICollectionViewCell {
    
    static var reuseID = "ProductCellForProductCell"
    var storage: Storage!
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    let brandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.backgroundColor = .clear
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    let modelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        label.backgroundColor = .clear
        label.textColor = .black.withAlphaComponent(0.8)
        label.numberOfLines = 2
        return label
    }()
    
    let mallLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        label.backgroundColor = .clear
        label.textColor = .orange.withAlphaComponent(0.8)
        label.numberOfLines = 0
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.backgroundColor = .clear
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 0
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        setupConstraints()
        storage = Storage.storage()
    }
    
    private func configureStackView() {
        let arrayViews = [brandLabel, modelLabel, mallLabel, priceLabel]
        arrayViews.forEach { view in
            stackView.addArrangedSubview(view)
        }
    }
    
    func configureCell(model: PopularProduct) {
//        imageView.image = UIImage(named: model.popularProduct?.refArray.first ?? "")
//        if let firstRef = model.popularProduct?.refArray.first {
//            let urlRef = storage.reference(forURL: firstRef)
//            self.imageView.sd_setImage(with: urlRef, placeholderImage: UIImage(named: "DefaultImage"))
//        } else {
//            imageView.image = UIImage(named: "DefaultImage")
//        }
        let refURL = storage.reference(forURL: model.refArray.first ?? "")
        imageView.sd_setImage(with: refURL, placeholderImage: UIImage(named: "DefaultImage"))
        brandLabel.text = "Nike"
        modelLabel.text = model.model
        mallLabel.text = model.malls.first
        priceLabel.text = model.price
    }
    
    private func setupConstraints() {
        
        let topImageViewCnstr = imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)
        topImageViewCnstr.priority = UILayoutPriority(999)
        topImageViewCnstr.isActive = true
        
        let trailingImageViewCnstr = imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        trailingImageViewCnstr.isActive = true
        
        let leadingImageViewCnstr = imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0)
        leadingImageViewCnstr.isActive = true
        
        let heightImageViewCnstr = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
        heightImageViewCnstr.isActive = true
        
        let topStackCnstr = stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0)
        topStackCnstr.isActive = true
        
        let trailingStackCnstr = stackView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        trailingStackCnstr.isActive = true
        
        let leadingStackCnstr = stackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        leadingStackCnstr.isActive = true
        
        let bottomStackCnstr = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        bottomStackCnstr.priority = UILayoutPriority(999)
        bottomStackCnstr.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
