//
//  ImageCell.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.02.23.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class ImageCell: UICollectionViewCell {
    
    static var reuseID: String = "ImageCell"
    var storage: Storage!
    
//    let imageView: UIImageView = {
//        let image = UIImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.contentMode = .scaleAspectFill
//        image.layer.cornerRadius = 4
//        image.clipsToBounds = true
//        return image
//    }()
//
//    let labelName: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//        label.textColor = R.Colors.label
//        label.backgroundColor = .clear
//        return label
//    }()
    let labelName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        label.textColor = R.Colors.label
        label.backgroundColor = R.Colors.secondarySystemBackground
        label.layer.cornerRadius = label.frame.size.width/2
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(labelName)
//        addSubview(imageView)
        setupConstraints()
        storage = Storage.storage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        imageView.sd_cancelCurrentImageLoad()
//        imageView.image = nil
    }
    
    func setupConstraints() {
//        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: topAnchor),
//                                     imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
//                                     imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
//                                     imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
//                                     labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
//                                     labelName.trailingAnchor.constraint(equalTo: trailingAnchor),
//                                     labelName.leadingAnchor.constraint(equalTo: leadingAnchor),
//                                     labelName.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
        NSLayoutConstraint.activate([labelName.topAnchor.constraint(equalTo: topAnchor), labelName.trailingAnchor.constraint(equalTo: trailingAnchor), labelName.leadingAnchor.constraint(equalTo: leadingAnchor), labelName.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    
    func configureCell(model: ItemCell) {
        
//        if let firstRef = model.brands?.refImage {
//            let urlRef = storage.reference(forURL: firstRef)
//
//            self.imageView.sd_setImage(with: urlRef, placeholderImage: UIImage(named: "DefaultImage"))
//        } else {
//            imageView.image = UIImage(named: "DefaultImage")
//        }
        labelName.text = model.brands?.brand
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
