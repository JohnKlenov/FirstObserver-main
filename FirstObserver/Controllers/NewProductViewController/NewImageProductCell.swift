//
//  NewImageProductCell.swift
//  FirstObserver
//
//  Created by Evgenyi on 25.02.23.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class NewImageProductCell: UICollectionViewCell {
    
    static var reuseID: String = "NewImageProductCell"
    var storage: Storage!
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        setupConstraints()
        storage = Storage.storage()
    }
    
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: topAnchor),
                                     imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     imageView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    
    
    func configureCell(image:UIImage) {
//        model.brands?.refImage
//        if let firstRef = model.mallImage {
//            let urlRef = storage.reference(forURL: firstRef)
//
//            self.imageView.sd_setImage(with: urlRef, placeholderImage: UIImage(named: "DefaultImage"))
//        } else {
//            imageView.image = UIImage(named: "DefaultImage")
//        }
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
