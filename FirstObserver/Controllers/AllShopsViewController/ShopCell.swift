//
//  ShopCell.swift
//  FirstObserver
//
//  Created by Evgenyi on 31.08.23.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class ShopCell: UITableViewCell {

    static var reuseID: String = "ShopCell"
    var storage: Storage!
    
    let imageCell: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 4
        image.clipsToBounds = true
        image.tintColor = R.Colors.label
        return image
    }()
    
    let shopLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.backgroundColor = .clear
        label.textColor = R.Colors.label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = R.Colors.secondarySystemBackground
        contentView.addSubview(imageCell)
        contentView.addSubview(shopLabel)
        setupConstraints()
        storage = Storage.storage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.sd_cancelCurrentImageLoad()
        //        imageView.image = nil
    }
    
    private func setupConstraints() {
        
        let topImageViewCnstr = imageCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        topImageViewCnstr.priority = UILayoutPriority(999)
        topImageViewCnstr.isActive = true

        let leadingImageViewCnstr = imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        leadingImageViewCnstr.isActive = true

        let widthImageViewCnstr = imageCell.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/4)
        widthImageViewCnstr.isActive = true

        let heightImageViewCnstr = imageCell.heightAnchor.constraint(equalTo: imageCell.widthAnchor)
        heightImageViewCnstr.isActive = true

        let bottomImageViewCnstr = imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        bottomImageViewCnstr.priority = UILayoutPriority(999)
        bottomImageViewCnstr.isActive = true
        
        NSLayoutConstraint.activate([shopLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor), shopLabel.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor), shopLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)])
    }
    
    func configureCell(model: PreviewCategory?) {
        
        if let imageRef = model?.refImage {
            let urlRef = storage.reference(forURL: imageRef)
            let placeholderImage = UIImage(named: "DefaultImage")
            
            imageCell.sd_setImage(with: urlRef, placeholderImage: placeholderImage) { (image, error, cacheType, url) in
                guard let image = image else {
                    // Обработка ошибок
                    return
                }
                
                // Настройка цвета изображения в зависимости от текущей темы
                if #available(iOS 13.0, *) {
                    let tintableImage = image.withRenderingMode(.alwaysTemplate)
                    self.imageCell.image = tintableImage
                } else {
                    self.imageCell.image = image
                }
            }
            
        } else {
            imageCell.image = UIImage(named: "DefaultImage")
        }
        shopLabel.text = model?.brand
    }
}




//        if let imageRef = model?.refImage {
//            let urlRef = storage.reference(forURL: imageRef)
//            self.imageCell.sd_setImage(with: urlRef, placeholderImage: UIImage(named: "DefaultImage"))
//        } else {
//            imageCell.image = UIImage(named: "DefaultImage")
//        }
//        shopLabel.text = model?.brand
