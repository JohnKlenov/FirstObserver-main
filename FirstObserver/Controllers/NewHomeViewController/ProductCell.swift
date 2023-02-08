//
//  ProductCell.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.02.23.
//

import UIKit

class ProductCellNew: UICollectionViewCell {
    
    static var reuseID = "ProductCell"
    
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
        label.numberOfLines = 0
        return label
    }()
    
    let modelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        label.backgroundColor = .clear
        label.textColor = .black.withAlphaComponent(0.8)
        label.numberOfLines = 0
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
        stack.distribution = .fillEqually
        stack.spacing = 0
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
        addSubview(imageView)
        addSubview(stackView)
        setupConstraints()
//        backgroundColor = .lightGray
    }
    
    private func configureStackView() {
        let arrayViews = [brandLabel, modelLabel, mallLabel, priceLabel]
        arrayViews.forEach { view in
            stackView.addArrangedSubview(view)
        }
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
//            stackView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1/2),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)

        ])



        
//        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: topAnchor), imageView.bottomAnchor.constraint(equalTo: bottomAnchor), imageView.trailingAnchor.constraint(equalTo: trailingAnchor), imageView.leadingAnchor.constraint(equalTo: leadingAnchor)])
    }
    
    func configureCell(model: ItemCell) {
        imageView.image = UIImage(named: model.popularProduct?.refArray.first ?? "")
        brandLabel.text = "Nike"
        modelLabel.text = model.popularProduct?.model
        mallLabel.text = model.popularProduct?.malls.first
        priceLabel.text = model.popularProduct?.price
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
