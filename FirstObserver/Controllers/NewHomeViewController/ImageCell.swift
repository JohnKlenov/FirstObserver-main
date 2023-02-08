//
//  ImageCell.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.02.23.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    static var reuseID: String = "ImageCell"
    
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
        label.backgroundColor = .clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(labelName)
        addSubview(imageView)
        setupConstraints()
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: topAnchor),
                                     imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
                                     labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
                                     labelName.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     labelName.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     labelName.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    
    func configureCell(model: ItemCell) {
        imageView.image = UIImage(named: model.brands?.refImage ?? "")
        labelName.text = model.brands?.brand
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
