//
//  BrandCell.swift
//  FirstObserver
//
//  Created by Evgenyi on 22.02.23.
//

import UIKit

class BrandCellMallVC: UICollectionViewCell {
    
    static var reuseID: String = "BrandCell"
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 4
        image.clipsToBounds = true
        return image
    }()
    
    let labelName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        label.backgroundColor = .orange
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(labelName)
        addSubview(imageView)
        setupConstraints()
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.black.cgColor
    }
    
    
    private func setupConstraints() {
        
        let topImageViewCnstr = imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        topImageViewCnstr.priority = UILayoutPriority(999)
        topImageViewCnstr.isActive = true
        
        let trailingImageViewCnstr = imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
//        trailingImageViewCnstr.priority = UILayoutPriority(1000)
        trailingImageViewCnstr.isActive = true
        
        let leadingImageViewCnstr = imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
//        leadingImageViewCnstr.priority = UILayoutPriority(1000)
        leadingImageViewCnstr.isActive = true
        
        let heightImageViewCnstr = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
//        heightImageViewCnstr.priority = UILayoutPriority(1000)
        heightImageViewCnstr.isActive = true
        
        let topStackCnstr = labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0)
//        topStackCnstr.priority = UILayoutPriority(1000)
        topStackCnstr.isActive = true
        
        let trailingStackCnstr = labelName.trailingAnchor.constraint(equalTo: trailingAnchor)
//        trailingStackCnstr.priority = UILayoutPriority(1000)
        trailingStackCnstr.isActive = true
        
        let leadingStackCnstr = labelName.leadingAnchor.constraint(equalTo: leadingAnchor)
//        leadingStackCnstr.priority = UILayoutPriority(1000)
        leadingStackCnstr.isActive = true
        
        let bottomStackCnstr = labelName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        bottomStackCnstr.priority = UILayoutPriority(999)
        bottomStackCnstr.isActive = true
    }
    
    func configureCell(model: MImage) {
        imageView.image = UIImage(named: model.image)
        labelName.text = model.brand
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
